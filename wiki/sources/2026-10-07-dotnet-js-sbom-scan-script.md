---
title: 使用者腳本：dotnet-js-sbom-scan.sh（.NET + 前端 JS 合併掃描）
type: source
tags: [sbom, dotnet, javascript, cyclonedx, trivy, retire, script]
sources: [raw/tools/dotnet-js-sbom-scan.sh]
source_url: 無（使用者自撰）
source_author: 使用者
source_date: 2026-10-07（檔案修改日）
created: 2026-10-07
updated: 2026-10-07
status: draft
---

# 使用者腳本：dotnet-js-sbom-scan.sh

## 基本資訊
- 類型：使用者自撰的 bash 腳本（實務做法，非文件）
- 作者/發布者：使用者
- 發布日期：2026-10-07（檔案修改日）
- 可信度評估：個人實務；是 [[sources/2026-10-07-dotnet-sbom-scan-script]] 的擴充版

## 重點摘要
1. 四步流程：`dotnet-CycloneDX` 掃 .NET → `retire` 掃 libman 管理的前端函式庫（`WFAHRS/wwwroot/lib`）→ `cyclonedx-cli merge` 合併兩份 SBOM → `trivy sbom` 對合併檔統一掃弱點與 license。
2. 中間檔（`.dotnet.cdx.json`、`.js.cdx.json`、license 暫存檔）執行完刪除，只留合併檔 `{專案}.{版本}.cdx.json` 與報告。
3. 其餘（版本由 csproj 擷取、license 前綴過濾）同前一支腳本。
4. 2026-10-12 修改：JSON 弱點報告改為 `trivy sbom ... --list-all-pkgs=false --format json`（見 [[sources/2026-10-12-npm-sbom-scan-script]]）。

## 關鍵主張與數據
- 「retire 發現弱點時 exit code 為 13,故以 || true 避免中斷腳本」— 意涵：與 [[tools/retire-js]] README 的 exit 13 一致；腳本用 `set -euo pipefail`，故需吞掉。
- 「限制:animate.css(CSS)不掃;print-js、viewerjs 可能辨識不到」— 意涵：retire 靠檔案內容特徵辨識，非 JS 或冷門函式庫會漏；這是使用者實測得到的覆蓋缺口，SBOM 不含這些元件。
- `retire --path WFAHRS/wwwroot/lib --outputformat cyclonedxJSON --outputpath ...`、`cyclonedx-win-x64 merge --input-files A B --output-file C --output-format json`— 意涵：Windows 上 cyclonedx-cli 的執行檔名為 `cyclonedx-win-x64`。
- 前置需求另含 `npm install -g retire`、cyclonedx-cli release 執行檔。

## 影響的 wiki 頁面
- [[practices/dotnet-sbom-cyclonedx-trivy]] — 新增（含 JS 擴充）
- [[tools/retire-js]] — 補實測用法與覆蓋缺口
- [[tools/cyclonedx-cli]] — 補 merge 實務用法
- [[tools/trivy]]、[[tools/cyclonedx-dotnet]] — 同前

## 與既有知識的關係
- 支持：[[tools/retire-js]] 的 exit 13 行為與 CycloneDX 輸出。
- 矛盾：無。[[tools/retire-js]] 原有的「與 cyclonedx-npm 分工待實測」仍未解——本腳本針對 libman（無 package.json）的前端函式庫，不適用 cyclonedx-npm。
- 新增：retire 的覆蓋缺口實例；「SBOM 合併」做為 .NET + 前端的整合手法。

## 待追問題
- 合併後相同元件／`bom-ref` 衝突如何處理？
- retire 輸出的元件是否帶 purl，trivy 能否比對？尚未檢視實際輸出。
- 合併檔的 metadata（主元件名稱、版本）為何？
