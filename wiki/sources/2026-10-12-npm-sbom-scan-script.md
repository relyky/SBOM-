---
title: 使用者腳本：npm-sbom-scan.sh（cyclonedx-npm + trivy）
type: source
tags: [sbom, npm, javascript, cyclonedx, trivy, script]
sources: [raw/tools/npm-sbom-scan.sh]
source_url: 無（使用者自撰）
source_author: 使用者
source_date: 2026-10-12（檔案修改日）
created: 2026-10-12
updated: 2026-10-12
status: draft
---

# 使用者腳本：npm-sbom-scan.sh

## 基本資訊
- 類型：使用者自撰的 bash 腳本（實務做法，非文件）
- 作者/發布者：使用者
- 發布日期：2026-10-12（檔案修改日）
- 可信度評估：個人實務；是否已實跑、產出為何，檔內未記載。專案名為 `TFB_RES-client`，與 `WFAHRS` 系列腳本是不同專案

## 重點摘要
1. 針對前端 `client/`（有 `package.json`／`package-lock.json`）：`cyclonedx-npm --package-lock-only --omit dev --output-file <SBOM> client/package.json`，只讀 lockfile、只含正式環境套件，不需 `npm install`。
2. 版本字串為執行當天日期 `YYYYMMDD`（不同於 .NET 腳本讀 csproj 版本）；輸出 `.sbom/TFB_RES-client.{版本}.cdx.json`。
3. 之後與 .NET 腳本同型：`trivy sbom` 產 `.vuln.txt`、`.vuln.json`、`.lic.txt`。**未做**授權前綴過濾（沒有 `python -I` 步驟）。
4. 在方案根目錄（含 `TFB_RES.sln`）執行；Windows 用 Git Bash。

## 關鍵主張與數據
- 「範圍:只掃正式環境套件(--omit dev);只讀 package-lock.json,不需 npm install」— 意涵：與 [[tools/cyclonedx-npm]] README 的 `--package-lock-only`、`--omit dev` 選項用法一致。
- `--list-all-pkgs=false` 加在 JSON 弱點報告（見下方「本次一併 ingest 的修改」）。

## 本次一併 ingest 的修改（既有兩支腳本）
`dotnet-sbom-scan.sh`、`dotnet-js-sbom-scan.sh` 皆只改動 JSON 弱點報告那行：`trivy sbom ... --format json` 前加 `--list-all-pkgs=false`；前者另補檔尾換行。意涵：三支腳本現在一致；此旗標的推測用途是讓 JSON 只列有弱點的套件、縮小檔案（待驗證，檔內無說明）。

## 影響的 wiki 頁面
- [[practices/npm-sbom-cyclonedx-trivy]] — 新增
- [[tools/cyclonedx-npm]] — 補腳本化用法
- [[tools/trivy]] — 補 `--list-all-pkgs=false`
- [[practices/dotnet-sbom-cyclonedx-trivy]]、[[sources/2026-10-07-dotnet-sbom-scan-script]]、[[sources/2026-10-07-dotnet-js-sbom-scan-script]] — 同步旗標變更

## 與既有知識的關係
- 支持：[[tools/cyclonedx-npm]] 的 lockfile-only 用法；[[sources/2026-10-07-dotnet-sbom-scan-script]] 的 trivy 報告三件組。
- 矛盾：無。
- 新增：前端 npm 專案的腳本化流程；日期式版本；腳本間的差異（無授權前綴過濾）。

## 待追問題
- 實際輸出元件數？`--package-lock-only` 的結果與 `node_modules` 版本是否一致？
- 與 [[tools/retire-js]]、[[tools/syft-grype|Syft]] 掃同一前端的元件清單差異（[[tools/cyclonedx-npm]] 頁已列為待實測）。
- `--list-all-pkgs=false` 的實際效果。
