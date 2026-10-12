---
title: CycloneDX for npm（cyclonedx-npm）
type: tool
tags: [sbom, tool, cyclonedx, npm, nodejs]
aliases: [cyclonedx-npm, "@cyclonedx/cyclonedx-npm", cyclonedx-node-npm]
sources: [raw/tools/cyclonedx-npm.md, raw/tools/npm-sbom-scan.sh]
vendor: CycloneDX（GitHub 組織）
license: Apache 2.0
version_checked: 6.0.1（截至 2026-10，依 npm 套件頁；僅讀文件，未實測）
created: 2026-10-07
updated: 2026-10-12
status: stub
---

# CycloneDX for npm

> 本頁僅依官方 README 撰寫，尚未實測。

## 用途與定位
從 npm 專案產生 CycloneDX SBOM；官方自評為 npm 專案「最準確、完整」的產生器（廠商自評），產出幾乎符合 OWASP SCVS Level-2，簽章需外部處理。[^s]

## 支援範圍
- 輸出格式：CycloneDX 1.2–1.6（預設 1.6）；JSON（預設）或 XML；預設輸出到 STDOUT。[^s]
- 語言/生態系：Node.js／npm（需 node >= 20.18.0、npm >= 9）。pnpm／yarn 未提及（待驗證）。[^s]
- 輸入來源：`package.json`（可指定路徑）；預設參考 `node_modules`，`--package-lock-only` 可只用 `package-lock.json`／`npm-shrinkwrap.json`。[^s]

## 基本用法
```bash
npm install --save-dev @cyclonedx/cyclonedx-npm
npx @cyclonedx/cyclonedx-npm --output-file bom.cdx.json
npx @cyclonedx/cyclonedx-npm --package-lock-only --omit dev --sv 1.6 -o bom.cdx.json
```
（命令依 README 選項組合，尚未實測[^s]）

- 重要選項：`--omit dev|optional|peer`、`-w`／`--no-workspaces`／`--include-workspace-root`（workspaces，實驗性）、`--gather-license-texts`（實驗性）、`--flatten-components`、`--short-PURLs`、`--output-reproducible`、`--validate`、`--mc-type`、`--ignore-npm-errors`（`npm install` 用過 `--force`／`--legacy-peer-deps` 時）。[^s]
- 以 npm 蒐集證據；npm 執行檔自動偵測，可由環境變數 `npm_execpath` 覆寫。[^s]
- 可程式呼叫 CLI（`execFileSync` 取 STDOUT JSON）；無穩定公開 API。[^s]

## CI/CD 整合
README 無 pipeline 範例；僅說明可作為 devDependency 以 `npx` 執行、可用 `--output-reproducible` 取得可重現輸出。[^s]

## 優缺點
- 優：原生 CycloneDX；可只讀 lockfile（CI 不必安裝）；可排除 dev 依賴；支援 workspaces、授權文字蒐集、輸出驗證。[^s]
- 缺／注意：
  - 不去重，同一元件多處安裝會重複出現；可用 `--flatten-components` 改變呈現。[^s]
  - `--short-PURLs` 會遺失 qualifier 資訊。[^s]
  - workspaces、授權文字蒐集為實驗性。[^s]
  - 預設規格 1.6，低於 [[tools/cyclonedx-dotnet]] 預設的 1.7。[^s]
  - 僅 npm 生態；與 [[tools/retire-js]]（可抓 vendored JS 檔）、[[tools/syft-grype|Syft]] 的元件清單差異未實測。（對照為本庫推論）

## 實測紀錄
使用者已寫成腳本：`cyclonedx-npm --package-lock-only --omit dev --output-file <SBOM> client/package.json`，再交給 [[tools/trivy]] 掃弱點與授權；腳本無實跑輸出，元件數、授權欄位、與 Syft／Retire.js 的比較仍待實測。[^u] 見 [[practices/npm-sbom-cyclonedx-trivy]]。

## 參考來源
[^s]: [[sources/2026-10-07-cyclonedx-npm-readme]]
[^u]: [[sources/2026-10-12-npm-sbom-scan-script]]
