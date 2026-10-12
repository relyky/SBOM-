---
title: Trivy
type: tool
tags: [sbom, tool, vex, scanner]
sources: [raw/industry/What Is VEX(Vulnerability Exploitability eXchange).md, raw/tools/dotnet-sbom-scan.sh, raw/tools/dotnet-js-sbom-scan.sh, raw/tools/npm-sbom-scan.sh]
vendor: Aqua Security
license: 開源（具體授權待驗證）
version_checked: 未查證（來源為 2024-07 文章）
created: 2026-10-01
updated: 2026-10-12
status: stub
---

# Trivy

> 本頁依一份廠商文章與使用者的兩支腳本撰寫，腳本無實跑輸出紀錄。

## 用途與定位
開源的弱點與設定錯誤掃描工具，可產生 SBOM、以 SBOM 做弱點比對，並支援以 VEX 過濾結果。[^a] Aqua 稱 Trivy 是最早支援 VEX 的掃描器之一。[^a]

## 支援範圍
- 輸出格式：CycloneDX（來源範例）；其他格式待驗證
- 語言/生態系：來源範例為容器映像（Debian）；使用者腳本以 `trivy sbom` 掃 CycloneDX SBOM（.NET、前端 JS 元件），掃描品質待驗證
- 輸入來源：容器映像、SBOM 檔

## 基本用法
```bash
# 產生 SBOM
trivy image --format cyclonedx --output debian11.sbom.cdx debian:11

# 以 SBOM 掃描並套用 VEX
trivy sbom debian11.sbom.cdx --vex trivy.vex.cdx
```
（命令取自來源[^a]，尚未實測）

## CI/CD 整合
使用者腳本以 `trivy sbom <SBOM> --scanners vuln` 掃弱點（table、json 各一份），並以 `--scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL` 掃授權，用於 CycloneDX SBOM（來自 dotnet-CycloneDX，或再與 retire 輸出合併，或來自 [[tools/cyclonedx-npm]]）。需能下載弱點資料庫。[^s] 三支腳本的 JSON 弱點報告皆加 `--list-all-pkgs=false`（推測為只列有弱點的套件，待驗證）。[^n] 見 [[practices/dotnet-sbom-cyclonedx-trivy]]、[[practices/npm-sbom-cyclonedx-trivy]]。

## 優缺點
- 優：可串起「產生 SBOM → 掃描 → 以 VEX 去除不可利用弱點」流程。[^a]
- 缺：來源為廠商文章，無獨立評估。

## 實測紀錄
使用者已寫成腳本串接 dotnet-CycloneDX → trivy；trivy 對 .NET／前端元件的弱點與授權比對結果尚無紀錄。[^s]

## 參考來源
[^a]: [[sources/2026-10-01-aqua-what-is-vex]]
[^s]: [[sources/2026-10-07-dotnet-sbom-scan-script]]、[[sources/2026-10-07-dotnet-js-sbom-scan-script]]
[^n]: [[sources/2026-10-12-npm-sbom-scan-script]]
