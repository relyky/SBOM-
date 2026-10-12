#!/usr/bin/env bash
# 產生 SBOM(dotnet-CycloneDX)與弱點/license 報告(trivy sbom),輸出至 .sbom/
#
# 事先需安裝:
#   1. .NET SDK            (dotnet-CycloneDX 會對各專案執行 restore)
#   2. dotnet-CycloneDX    dotnet tool install --global CycloneDX   (指令名稱 dotnet-CycloneDX)
#   3. trivy               https://trivy.dev  (需能下載弱點資料庫)
#   4. python 3            (license 報告篩選用;以 python -I 呼叫)
#   5. bash                (Windows 請用 Git Bash)
#
# 執行方式:在方案根目錄(含 WFAHRS.sln)執行  bash dotnet-sbom-scan.sh
# 輸出:.sbom/{專案}.{版本}.cdx.json、.vuln.txt、.vuln.json、.lic.txt
set -euo pipefail

P=WFAHRS
CSPROJ=WFAHRS/WFAHRS.csproj
PREFIX=$(sed -n 's:.*<VersionPrefix>\(.*\)</VersionPrefix>.*:\1:p' "$CSPROJ" | tr -d '\r')
SUFFIX=$(sed -n 's:.*<VersionSuffix>\(.*\)</VersionSuffix>.*:\1:p' "$CSPROJ" | tr -d '\r')
V="$PREFIX-$SUFFIX"
SBOM=".sbom/$P.$V.cdx.json"

mkdir -p .sbom
dotnet-CycloneDX WFAHRS.sln -o .sbom -fn "$P.$V.cdx.json" --json

trivy sbom "$SBOM" --scanners vuln    --format table --output ".sbom/$P.$V.vuln.txt"
trivy sbom "$SBOM" --scanners vuln    --list-all-pkgs=false --format json  --output ".sbom/$P.$V.vuln.json"

# license 報告排除 System/Microsoft/runtime/NETStandard 開頭的套件(皆為 Microsoft 發行,可免費商用)
LIC_SBOM=".sbom/$P.$V.lic.tmp.cdx.json"
python -I -c "
import json, re, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
d['components'] = [c for c in d.get('components', []) if not re.match(r'(System|Microsoft|runtime|NETStandard)\.', c.get('name', ''))]
json.dump(d, open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False)
" "$SBOM" "$LIC_SBOM"
trivy sbom "$LIC_SBOM" --scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --format table --output ".sbom/$P.$V.lic.txt"
rm -f "$LIC_SBOM"
