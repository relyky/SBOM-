---
title: 使用者腳本：dotnet-sbom-scan.sh（dotnet-CycloneDX + trivy）
type: source
tags: [sbom, dotnet, cyclonedx, trivy, script]
sources: [raw/tools/dotnet-sbom-scan.sh]
source_url: 無（使用者自撰）
source_author: 使用者
source_date: 2026-10-07（檔案修改日）
created: 2026-10-07
updated: 2026-10-07
status: draft
---

# 使用者腳本：dotnet-sbom-scan.sh

## 基本資訊
- 類型：使用者自撰的 bash 腳本（實務做法，非文件）
- 作者/發布者：使用者
- 發布日期：2026-10-07（檔案修改日）
- 可信度評估：個人實務；是否已實跑、產出為何，檔內未記載

## 重點摘要
1. 在方案根目錄（含 `WFAHRS.sln`）執行，兩步完成：`dotnet-CycloneDX` 產 SBOM，再用 `trivy sbom` 掃弱點與 license，輸出全放 `.sbom/`。
2. 版本字串由 `WFAHRS.csproj` 的 `VersionPrefix`、`VersionSuffix` 以 `sed` 擷取，組成 `{專案}.{版本}.cdx.json` 檔名，符合 [[practices/sbom-file-naming]] 的 `.cdx.json` 慣例。
3. 弱點報告同時輸出 table（`.vuln.txt`）與 json（`.vuln.json`）；license 報告另以 `python -I` 先濾掉 `System`／`Microsoft`／`runtime`／`NETStandard` 開頭的元件，再用 trivy 的 license scanner、嚴重度 `UNKNOWN,MEDIUM,HIGH,CRITICAL` 輸出 `.lic.txt`。
4. 2026-10-12 修改：JSON 弱點報告改為 `trivy sbom ... --list-all-pkgs=false --format json`（見 [[sources/2026-10-12-npm-sbom-scan-script]]）；檔尾補換行。

## 關鍵主張與數據
- 「license 報告排除 System/Microsoft/runtime/NETStandard 開頭的套件(皆為 Microsoft 發行,可免費商用)」— 意涵：以名稱前綴白名單降低授權雜訊；前綴比對可能誤殺同名前綴的第三方套件（本庫推論）。
- 「`dotnet-CycloneDX WFAHRS.sln -o .sbom -fn "$P.$V.cdx.json" --json`」— 意涵：與 [[sources/2026-10-05-cyclonedx-dotnet-practice]] 的 `-F Json` 寫法不同，此處用 `--json`。
- 前置需求：.NET SDK、dotnet-CycloneDX、trivy（需能下載弱點資料庫）、python 3、bash（Windows 用 Git Bash）。

## 影響的 wiki 頁面
- [[practices/dotnet-sbom-cyclonedx-trivy]] — 新增
- [[tools/trivy]] — 補 `trivy sbom` 掃 license 與弱點的實務用法
- [[tools/cyclonedx-dotnet]] — 補腳本化用法與 `--json` 旗標
- [[practices/dotnet-sbom-syft-grype]] — 加上與本流程的交叉引用

## 與既有知識的關係
- 支持：[[sources/2026-10-05-cyclonedx-dotnet-practice]] 提到改用 cyclonedx-dotnet 是為了 license 檢查；本腳本是其下游（以 trivy 補 license 報告）。
- 矛盾：無。
- 新增：以 trivy 取代 grype 做弱點比對；license 掃描流程。

## 待追問題
- `--json` 與 `-F Json` 是否等價？（README 摘要頁未載 `--json`，待查。）
- trivy 對 `pkg:nuget` 元件的 license 取得是否完整？取決於 SBOM 內 license 欄位，尚未檢視實際輸出。
