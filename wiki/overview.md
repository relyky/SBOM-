---
title: SBOM 研究總覽
type: overview
tags: [sbom, overview]
sources: [raw/standards/CycloneDX BOM Standard.md, raw/tools/CycloneDX CLI tool for SBOM.md, raw/tools/sbom-tools.md, raw/tools/clonedx-dotnet.md, raw/tools/clonedx-dotnet-practice.md, raw/tools/cyclonedx-npm.md, raw/tools/dotnet-sbom-scan.sh, raw/tools/dotnet-js-sbom-scan.sh, raw/tools/npm-sbom-scan.sh, raw/tools/RetireJS - repo.md, raw/tools/Retire.js - website.md, raw/tools/vexctl.md, raw/tools/Microsoft sbom-tool.md, raw/tools/Overview of Anchore Open Source tools.md, raw/tools/Syft.md, raw/tools/Grype.md, raw/tools/SBOM Generation.md, raw/tools/Vulnerability Scanning.md, raw/tools/syft-grype.sample.md, raw/standards/Software Identification (SWID) Tagging.md, raw/industry/What Is VEX(Vulnerability Exploitability eXchange).md, raw/industry/軟體物料清單SBOM發展趨勢.md, raw/industry/Common Vulnerabilities and Exposures.md, raw/industry/公共漏洞和暴露 - 維基百科，自由的百科全書.md, raw/industry/Software supply chain.md, raw/industry/Types of Software Bill of Material (SBOM) Documents.md, raw/industry/Best Practices for Naming and Directory Conventions for SBOMs (Software Bill of Materials) in Open Source Projects.md]
created: 2026-10-01
updated: 2026-10-12
status: draft
---

# SBOM 研究總覽

> 本頁是整個知識庫的「目前論點」。每次 ingest 若影響整體認知，LLM 需更新本頁。

## 研究問題
1. SBOM 是什麼、解決什麼問題？與傳統資產清冊、SCA（Software Composition Analysis）有何不同？
2. 主流格式（[[standards/spdx|SPDX]]、[[standards/cyclonedx|CycloneDX]]、[[standards/swid|SWID]]）差異為何？如何選擇？
3. 哪些法規/政策要求 SBOM？對台灣企業（含出口、供應鏈）的實際影響？
4. SBOM 的完整生命週期：產生 → 驗證 → 簽章 → 散布/交換 → 儲存 → 消費（漏洞比對、授權合規）→ 更新。
5. [[concepts/vex|VEX]] 如何與 SBOM 搭配，降低漏洞誤報？
6. 業界實際導入流程與成熟度：誰在做、怎麼做、遇到什麼困難？
7. 在 Python / .NET / React(TypeScript) / 容器專案中，如何在 CI/CD 自動產出並管理 SBOM？

## 目前論點
（截至 2026-10，基於 28 份來源（NIST SWID 頁、Anchore 官方文件、Microsoft sbom-tool、vexctl、CycloneDX 組織首頁、cyclonedx-dotnet／cyclonedx-npm／cyclonedx-cli／sbom-tools README 為一手，另含 5 份使用者實測／腳本，其餘為業界／二手），尚無法規與規格一手資料，論點僅為初步。）

1. **SBOM 是供應鏈透明度的基礎，但非完整性保證**：它列出元件，需搭配 provenance／簽章才能驗證完整性。[^a]
2. **類型決定用途**：CISA 定義 Design / Source / Build / Analyzed / Deployed / Runtime 六類，產生方式不同，涵蓋與限制各異。見 [[concepts/sbom-types]]。[^b]
3. **政策驅動明確，實務落後**：EO 14028 與 NTIA 最低要素確立自動化等要求，但開源專案採用率與工具準確度仍有明顯缺口（如僅約 0.56% 熱門 GitHub 儲存庫含符合政策的 SBOM）。見 [[regulations/eo-14028]]、[[concepts/sbom]]。[^a]
4. **交換層面已有慣例**：JSON 為通用格式，檔名採「製品檔名 + `.cdx.json`／`.spdx.json`」。見 [[practices/sbom-file-naming]]。[^c]
5. **SBOM 要搭配弱點脈絡才有用**：以 [[concepts/cve|CVE]] 為識別碼比對弱點，再用 [[concepts/vex|VEX]]（OpenVEX／CSAF／CycloneDX）標示不可利用者，可降低誤報；[[tools/trivy|Trivy]] 已能串起流程，OpenVEX 另有專用 CLI [[tools/vexctl]]（建立、驗證、簽證、過濾）。[^d][^i]
6. **三種格式的地位**：[[standards/spdx|SPDX]]（ISO/IEC 5962）、[[standards/swid|SWID]]（ISO/IEC 19770-2，偏已安裝軟體清冊）、[[standards/cyclonedx|CycloneDX]]（OWASP，專為 SBOM 設計；官方稱已成為 ECMA-424，並涵蓋 SBOM、VEX、CBOM 等 10 類 BOM）。NIST 一手頁指出 SWID 由 ISO 定義、NIST 推廣，與二手「NIST 開發」說法有出入，已於該頁標示。[^e]
7. **.NET 落地已有初步實測**：以 syft 掃描發佈產物（176 個 NuGet 元件）比掃整個目錄（1365 個，含重複）貼近實際部署；grype 只能比對有 purl 的元件，0 漏洞不代表無風險。見 [[practices/dotnet-sbom-syft-grype]]。[^g]
8. **.NET 生態系至少有三條工具路線**：Anchore Syft（CycloneDX／SPDX，掃出貨資料夾）、Microsoft sbom-tool（僅 SPDX 2.2／3.0，掃 `*.csproj` 並雜湊出貨檔，另可驗證），以及 CycloneDX for .NET（輸出 CycloneDX 1.0–1.7，由方案／專案檔經 `dotnet restore` 解析，可用 `-ef` 排除不在出貨輸出的套件）。使用者選用 cyclonedx-dotnet 的主因是 syft 取不到 .NET 套件授權資訊、無法快速檢查 license 是否核可。三者元件清單是否一致尚未實測（cyclonedx-dotnet 6.2.0 僅做過基本指令實測，預設輸出 XML，未檢視內容）。見 [[tools/microsoft-sbom-tool]]、[[tools/cyclonedx-dotnet]]。[^h][^k][^l]
9. **台灣視角（2024-02）**：趨勢為容器與 K8s 自動附帶 SBOM、結合 DevSecOps 每次發布自動產出；官方法規仍缺一手來源。[^f]
10. **前端 JS 有專用工具路線**：[[tools/retire-js|Retire.js]] 專精 JavaScript 函式庫，能抓不在套件清單內的 vendored 檔案，並可輸出 CycloneDX（含 `_VEX` 變體）；與 Syft 的 manifest／lockfile 型掃描互補。與 React／TypeScript 專案的實際差異尚未實測。另有官方 [[tools/cyclonedx-npm]]（由 npm 依賴樹／lockfile 產生 CycloneDX 1.2–1.6，不去重，workspaces 與授權文字蒐集為實驗性），三者元件清單差異待實測。[^j][^n]

11. **「產生之後」的工具層已浮現**：官方 [[tools/cyclonedx-cli]] 負責驗證、合併、轉換（含 SPDX JSON 2.3，可能遺失資訊）、簽章；第三方 [[tools/sbom-tools]] 負責語意 diff、品質評分、16 種合規標準驗證與機群查詢，可串接 syft 的 stdout。其法規描述（如 CISA 2026 最低要素 v2.1 為 NTIA 2021 的更嚴格後繼版）僅為工具方轉述，待法規原文核對。[^m1][^m2][^m3]

12. **.NET 已有「專案檔 → CycloneDX → trivy」的腳本化流程**：使用者以 dotnet-CycloneDX 產 SBOM，由 [[tools/trivy]] 掃弱點與授權（排除 Microsoft 前綴套件），另用 retire 掃 libman 前端函式庫並以 [[tools/cyclonedx-cli]] 合併；retire 有覆蓋缺口（CSS、部分函式庫）。為腳本設計，產出品質未驗證。見 [[practices/dotnet-sbom-cyclonedx-trivy]]。前端若有 npm 依賴樹，則另有 `cyclonedx-npm --package-lock-only --omit dev` → trivy 的腳本（只讀 lockfile，版本取日期），見 [[practices/npm-sbom-cyclonedx-trivy]]。三支腳本的 JSON 弱點報告皆加 `--list-all-pkgs=false`（用途待驗證）。[^s1][^s2][^s3]

13. **SBOM 要持續運作，而非一次性產出**：每次建置重產，並在弱點 DB 更新後對既有 SBOM 重掃；CI gate 可擋「新增高風險弱點且無 VEX」「授權不核可」「格式驗證失敗」。此為使用者簡報的作者建議，非標準要求，多數指令未實測；簽章尚未實作。見 [[practices/sbom-lifecycle-and-ci]]。[^t]

[^t]: [[analyses/sbom-practice-talk.marp|簡報：SBOM 實戰分享]]（本庫衍生品，非獨立來源）
[^s1]: [[sources/2026-10-07-dotnet-sbom-scan-script]]
[^s2]: [[sources/2026-10-07-dotnet-js-sbom-scan-script]]
[^s3]: [[sources/2026-10-12-npm-sbom-scan-script]]
[^m1]: [[sources/2026-10-06-cyclonedx-org-github]]
[^m2]: [[sources/2026-10-06-cyclonedx-cli-readme]]
[^m3]: [[sources/2026-10-06-sbom-tools-readme]]
[^n]: [[sources/2026-10-07-cyclonedx-npm-readme]]
[^k]: [[sources/2026-10-05-cyclonedx-dotnet-readme]]
[^l]: [[sources/2026-10-05-cyclonedx-dotnet-practice]]
[^j]: [[sources/2026-10-02-retirejs-repo]]、[[sources/2026-10-02-retirejs-website]]
[^i]: [[sources/2026-10-02-openvex-vexctl-readme]]
[^h]: [[sources/2026-10-01-microsoft-sbom-tool]]
[^g]: [[sources/2026-10-01-syft-grype-dotnet-sample]]
[^d]: [[sources/2026-10-01-aqua-what-is-vex]]
[^e]: [[sources/2026-10-01-nist-swid-tagging]]
[^f]: [[sources/2026-10-01-moea-sbom-trends]]

[^a]: [[sources/2026-10-01-wikipedia-software-supply-chain]]
[^b]: [[sources/2026-10-01-openssf-sbom-types]]
[^c]: [[sources/2026-10-01-openssf-sbom-naming]]

## 研究路線圖（建議蒐集的來源）
以下為建議放入 `raw/` 的一手資料，ingest 後打勾：

**標準**（→ `raw/standards/`）
- [ ] SPDX 規格書（最新版）
- [ ] CycloneDX 規格說明與 Guide（官方組織首頁已 ingest，規格本文尚缺）
- [ ] NTIA《The Minimum Elements for a Software Bill of Materials》

**政策與法規**（→ `raw/regulations/`）
- [ ] 美國行政命令 EO 14028（Improving the Nation's Cybersecurity）
- [ ] CISA SBOM 相關指引（最低要素更新——含據稱 2026-07-29 的 v2.1、SBOM 類型、VEX 文件）
- [ ] 歐盟 Cyber Resilience Act（CRA）SBOM 相關條文
- [ ] FDA 醫療器材上市前網路安全指引
- [ ] 台灣相關規範（如資安署/數位發展部、金管會之供應鏈資安要求）

**工具**（→ `raw/tools/`）
- [ ] Syft / Grype（已 ingest 官方文件與實測）、Microsoft sbom-tool（已 ingest 官方 README）、vexctl（已 ingest 官方 README）、Retire.js（已 ingest README 與網站）、CycloneDX for .NET（已 ingest README）、Trivy（僅二手）、cdxgen、CycloneDX CLI（已 ingest README）、sbom-tools（已 ingest README）、CycloneDX 其他語言外掛
- [ ] OWASP Dependency-Track、GUAC
- [ ] Sigstore / in-toto（簽章與證明）

**業界與案例**（→ `raw/industry/`、`raw/papers/`）
- [ ] Linux Foundation SBOM 採用調查報告
- [ ] OpenSSF 相關資源
- [ ] 企業導入案例、實務經驗分享

## 知識缺口
- （由 lint 填入）
