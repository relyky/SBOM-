#!/usr/bin/env bash
# 產生前端 client/ 的 SBOM(cyclonedx-npm)與弱點/license 報告(trivy sbom),輸出至 .sbom/
#
# 事先需安裝:
#   1. node / npm
#   2. cyclonedx-npm       npm install -g @cyclonedx/cyclonedx-npm
#   3. trivy               https://trivy.dev  (需能下載弱點資料庫)
#   4. bash                (Windows 請用 Git Bash)
#
# 執行方式:在方案根目錄(含 TFB_RES.sln)執行  bash npm-sbom-scan.sh
# 範圍:只掃正式環境套件(--omit dev);只讀 package-lock.json,不需 npm install
# 版號:執行當天日期(YYYYMMDD)
# 輸出:.sbom/TFB_RES-client.{版本}.cdx.json、.vuln.txt、.vuln.json、.lic.txt
set -euo pipefail

P=TFB_RES-client
V=$(date +%Y%m%d)
SBOM=".sbom/$P.$V.cdx.json"

mkdir -p .sbom
cyclonedx-npm --package-lock-only --omit dev --output-file "$SBOM" client/package.json

trivy sbom "$SBOM" --scanners vuln    --format table --output ".sbom/$P.$V.vuln.txt"
trivy sbom "$SBOM" --scanners vuln    --list-all-pkgs=false --format json  --output ".sbom/$P.$V.vuln.json"
trivy sbom "$SBOM" --scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --format table --output ".sbom/$P.$V.lic.txt"
