---
title: 以 cyclonedx-npm + trivy 為 npm 前端專案產生 SBOM 並掃描弱點與授權
type: practice
tags: [sbom, practice, npm, javascript, cyclonedx, trivy, script]
sources: [raw/tools/npm-sbom-scan.sh]
created: 2026-10-12
updated: 2026-10-12
status: draft
---

# 以 cyclonedx-npm + trivy 為 npm 前端專案產生 SBOM 並掃描

> 本頁依使用者自撰腳本整理，腳本內未附實跑輸出，結論僅限「流程設計」。

## 目標
不安裝依賴，直接由 `package-lock.json` 產出正式環境套件的 CycloneDX SBOM，並產出弱點與授權報告。[^a]

## 適用情境
- 前端有 `package.json` 與 `package-lock.json`（如 React／TypeScript 的 `client/`）。[^a]
- 與 [[practices/dotnet-sbom-cyclonedx-trivy]] 互補：後者的前端來源是 libman（無 `package.json`），故改用 retire；本流程適用有 npm 依賴樹者。

## 流程步驟
1. 版本取執行日 `YYYYMMDD`。[^a]
2. `cyclonedx-npm --package-lock-only --omit dev --output-file .sbom/<專案>.<V>.cdx.json client/package.json`。[^a]
3. 弱點：`trivy sbom <SBOM> --scanners vuln`，table 與 json（`--list-all-pkgs=false`）各一份。[^a]
4. 授權：`trivy sbom <SBOM> --scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --format table`。[^a]

## 角色與責任
未定（個人腳本）。

## 使用工具
- [[tools/cyclonedx-npm]]、[[tools/trivy]]

## 檢核清單
- [ ] 安裝：node／npm、cyclonedx-npm、trivy、bash（Windows 用 Git Bash）
- [ ] trivy 能下載弱點資料庫
- [ ] lockfile 已提交且與 `package.json` 同步
- [ ] 保存 SBOM 與三份報告

## 常見陷阱
- 只掃 `--omit dev`：開發／建置期依賴不在 SBOM 內（是否符合需求視範圍而定）。[^a]
- 不去重：同一元件多處安裝會重複出現（[[tools/cyclonedx-npm]] README）。
- 授權報告未過濾任何前綴，與 .NET 腳本做法不同。[^a]
- 硬寫專案名稱與路徑（`TFB_RES-client`、`client/package.json`）。[^a]

## 業界案例
（尚無）

## 參考來源
[^a]: [[sources/2026-10-12-npm-sbom-scan-script]]
