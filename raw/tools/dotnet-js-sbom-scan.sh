#!/usr/bin/env bash
# 流程:1. dotnet-CycloneDX 掃 WFAHRS.sln(.NET 主體)
#       2. retire 掃 libman 管理的前端函式庫(WFAHRS/wwwroot/lib)補足
#       3. cyclonedx-cli 合併兩份 SBOM
#       4. trivy sbom 對合併檔統一掃弱點與 license 風險,輸出至 .sbom/
#
# 事先需安裝:
#   1. .NET SDK            (dotnet-CycloneDX 會對各專案執行 restore)
#   2. dotnet-CycloneDX    dotnet tool install --global CycloneDX   (指令名稱 dotnet-CycloneDX)
#   3. trivy               https://trivy.dev  (需能下載弱點資料庫)
#   4. python 3            (license 報告篩選用;以 python -I 呼叫)
#   5. bash                (Windows 請用 Git Bash)
#   6. retire              npm install -g retire   (前端 JS 函式庫掃描)
#   7. cyclonedx-cli       https://github.com/CycloneDX/cyclonedx-cli/releases  (指令名稱 cyclonedx-win-x64)
#
# 執行方式:在方案根目錄(含 WFAHRS.sln)執行  bash dotnet-js-sbom-scan.sh
# 輸出:.sbom/{專案}.{版本}.cdx.json(合併檔;.dotnet/.js 中間檔執行完會刪除)、
#       .vuln.txt、.vuln.json、.lic.txt(皆以合併檔掃描)
set -euo pipefail

P=WFAHRS
CSPROJ=WFAHRS/WFAHRS.csproj
PREFIX=$(sed -n 's:.*<VersionPrefix>\(.*\)</VersionPrefix>.*:\1:p' "$CSPROJ" | tr -d '\r')
SUFFIX=$(sed -n 's:.*<VersionSuffix>\(.*\)</VersionSuffix>.*:\1:p' "$CSPROJ" | tr -d '\r')
V="$PREFIX-$SUFFIX"
SBOM=".sbom/$P.$V.dotnet.cdx.json"
JS_SBOM=".sbom/$P.$V.js.cdx.json"
ALL_SBOM=".sbom/$P.$V.cdx.json"

command -v cyclonedx-win-x64 >/dev/null || { echo "找不到 cyclonedx-win-x64(cyclonedx-cli)" >&2; exit 1; }

mkdir -p .sbom
dotnet-CycloneDX WFAHRS.sln -o .sbom -fn "$P.$V.dotnet.cdx.json" --json

# 前端函式庫(libman → wwwroot/lib):retire.js 以檔案內容特徵辨識函式庫版本
# 限制:animate.css(CSS)不掃;print-js、viewerjs 可能辨識不到。
# retire 發現弱點時 exit code 為 13,故以 || true 避免中斷腳本。
retire --path WFAHRS/wwwroot/lib --outputformat cyclonedxJSON --outputpath "$JS_SBOM" || true

# 合併 .NET 與前端 SBOM
cyclonedx-win-x64 merge --input-files "$SBOM" "$JS_SBOM" --output-file "$ALL_SBOM" --output-format json

trivy sbom "$ALL_SBOM" --scanners vuln    --format table --output ".sbom/$P.$V.vuln.txt"
trivy sbom "$ALL_SBOM" --scanners vuln    --list-all-pkgs=false --format json  --output ".sbom/$P.$V.vuln.json"

# license 報告排除 System/Microsoft/runtime/NETStandard 開頭的套件(皆為 Microsoft 發行,可免費商用)
LIC_SBOM=".sbom/$P.$V.lic.tmp.cdx.json"
python -I -c "
import json, re, sys
d = json.load(open(sys.argv[1], encoding='utf-8'))
d['components'] = [c for c in d.get('components', []) if not re.match(r'(System|Microsoft|runtime|NETStandard)\.', c.get('name', ''))]
json.dump(d, open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False)
" "$ALL_SBOM" "$LIC_SBOM"
trivy sbom "$LIC_SBOM" --scanners license --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --format table --output ".sbom/$P.$V.lic.txt"
# 清除中間檔,只保留合併檔 $ALL_SBOM
rm -f "$LIC_SBOM" "$SBOM" "$JS_SBOM"
