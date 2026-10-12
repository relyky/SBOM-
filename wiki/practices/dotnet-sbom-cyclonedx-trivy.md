---
title: 以 dotnet-CycloneDX + trivy 為 .NET 方案產生 SBOM 並掃描弱點與授權（含前端 JS 合併）
type: practice
tags: [sbom, practice, dotnet, cyclonedx, trivy, retire, script]
sources: [raw/tools/dotnet-sbom-scan.sh, raw/tools/dotnet-js-sbom-scan.sh]
created: 2026-10-07
updated: 2026-10-12
status: draft
---

# 以 dotnet-CycloneDX + trivy 為 .NET 方案產生 SBOM 並掃描弱點與授權

> 本頁依使用者自撰的兩支腳本整理，腳本內未附實跑輸出，結論僅限「流程設計」，產出品質尚未驗證。

## 目標
一個指令產出 CycloneDX SBOM、弱點報告與 license 報告；若有 libman 管理的前端函式庫，一併納入同一份 SBOM。[^a][^b]

## 適用情境
- .NET 方案（`.sln`），版本號寫在 csproj 的 `VersionPrefix`／`VersionSuffix`。[^a]
- 需要檢查 NuGet 套件授權（改用此路線的動機見 [[sources/2026-10-05-cyclonedx-dotnet-practice]]：syft 取不到 .NET 授權資訊）。
- 前端以 libman 放進 `wwwroot/lib`，無 `package.json`，故不適用 [[tools/cyclonedx-npm]]；有 npm 依賴樹的前端見 [[practices/npm-sbom-cyclonedx-trivy]]。[^b]

## 流程步驟
1. 擷取版本：以 `sed` 從 csproj 取 `VersionPrefix`、`VersionSuffix`，組成 `V`。[^a]
2. 產 .NET SBOM：`dotnet-CycloneDX <sln> -o .sbom -fn <專案>.<V>.cdx.json --json`。[^a]
3. （JS 擴充）`retire --path <wwwroot/lib> --outputformat cyclonedxJSON --outputpath <js.cdx.json> || true`；retire 發現弱點 exit code 為 13，需吞掉。[^b]
4. （JS 擴充）`cyclonedx-cli merge --input-files <dotnet> <js> --output-file <all> --output-format json`。[^b]
5. 弱點：`trivy sbom <SBOM> --scanners vuln --format table|json --output ...`（各輸出一份；json 版加 `--list-all-pkgs=false`，2026-10-12 新增，推測為只列有弱點的套件，待驗證）。[^a][^b][^c]
6. 授權：先用 `python -I` 濾掉 `System`／`Microsoft`／`runtime`／`NETStandard` 開頭元件，再 `trivy sbom --scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL`。[^a][^b]
7. 清掉中間檔，只留合併 SBOM 與報告（JS 版）。[^b]

## 角色與責任
未定（個人腳本；導入時需明定誰在 CI 執行、誰審 license 與弱點報告）。

## 使用工具
- [[tools/cyclonedx-dotnet]]、[[tools/trivy]]；JS 擴充另用 [[tools/retire-js]]、[[tools/cyclonedx-cli]]

## 檢核清單
- [ ] 安裝：.NET SDK、dotnet-CycloneDX、trivy、python 3、bash（Windows 用 Git Bash）；JS 擴充另需 retire、cyclonedx-cli
- [ ] trivy 能下載弱點資料庫（需對外連線）
- [ ] 確認 SBOM 內元件有 purl 與 license 欄位，trivy 才能比對
- [ ] 檢視 retire 辨識結果，補上未辨識的函式庫
- [ ] 保存 SBOM 與三份報告（`.vuln.txt`、`.vuln.json`、`.lic.txt`）

## 常見陷阱
- retire 覆蓋缺口：CSS（animate.css）不掃；print-js、viewerjs 可能辨識不到，這些函式庫不會出現在 SBOM。[^b]
- retire exit code 13 在 `set -e` 下會中斷腳本，需 `|| true`。[^b]
- license 前綴過濾可能誤排除同前綴的第三方套件（本庫推論）。
- 硬寫專案名稱、路徑（`WFAHRS`），換專案需改腳本。[^a]

## 與 syft + grype 路線的差異
| 項目 | [[practices/dotnet-sbom-syft-grype]] | 本流程 |
|---|---|---|
| 輸入 | 發佈產物（`dotnet publish` 資料夾） | 方案／專案檔（`dotnet restore` 解析） |
| 弱點比對 | grype | trivy |
| 授權 | syft 取不到 .NET 授權 | 以 trivy license scanner 檢查 |
| 前端 JS | 未涵蓋 | retire + 合併 |
（比較依兩條路線的來源整理；元件清單是否一致尚未實測）

使用者的選擇（簡報）：自家 .NET 專案走本路線，收到外部產物時才以 syft + grype 交叉檢查。CI 整合見 [[practices/sbom-lifecycle-and-ci]]。[^d]

## 業界案例
（尚無）

## 參考來源
[^a]: [[sources/2026-10-07-dotnet-sbom-scan-script]]
[^b]: [[sources/2026-10-07-dotnet-js-sbom-scan-script]]
[^c]: [[sources/2026-10-12-npm-sbom-scan-script]]（`--list-all-pkgs=false` 變更紀錄）
[^d]: [[analyses/sbom-practice-talk.marp|簡報：SBOM 實戰分享]]
