---
title: 知識庫紀錄
type: overview
tags: [log]
created: 2026-10-01
updated: 2026-10-01
---

# 知識庫紀錄（Log）

> 只能 append。查詢最近紀錄：`grep "^## \[" wiki/log.md | tail -5`

## [2026-10-01] setup | 建立 SBOM 研究 LLM Wiki 骨架
- 依 Karpathy LLM Wiki 模式建立三層架構：`raw/`、`wiki/`、`CLAUDE.md`
- 建立頁面範本：source、concept、standard、tool、regulation、organization、practice、analysis
- 新增：[[overview]]、[[index]]，以及 stub 頁 [[concepts/sbom]]、[[concepts/vex]]、[[standards/spdx]]、[[standards/cyclonedx]]
- 下一步：依 [[overview]] 的研究路線圖蒐集第一批來源放入 `raw/`

## [2026-10-01] ingest | raw/industry 首批 4 份來源（OpenSSF 命名、CISA SBOM 類型、Wikipedia 軟體供應鏈中英文）
- 新增：[[sources/2026-10-01-openssf-sbom-naming]]、[[sources/2026-10-01-openssf-sbom-types]]、[[sources/2026-10-01-wikipedia-software-supply-chain]]、[[sources/2026-10-01-wikipedia-zh-software-supply-chain]]
- 新增：[[concepts/sbom-types]]、[[concepts/software-supply-chain]]、[[practices/sbom-file-naming]]、[[regulations/eo-14028]]、[[regulations/ntia-minimum-elements]]、[[organizations/openssf]]、[[organizations/cisa]]、[[standards/swid]]
- 更新：[[concepts/sbom]]、[[concepts/vex]]、[[standards/spdx]]、[[standards/cyclonedx]]、[[overview]]、[[index]]
- 備註：無直接矛盾；SWID「由 NIST 提出」僅見中文維基，已標待驗證。法規／標準頁僅有二手來源，需補一手資料。

## [2026-10-01] ingest | 第二批 5 份來源（NIST SWID、Aqua VEX、資策會 SBOM 趨勢、CVE 中英文）
- 新增：[[sources/2026-10-01-nist-swid-tagging]]、[[sources/2026-10-01-aqua-what-is-vex]]、[[sources/2026-10-01-moea-sbom-trends]]、[[sources/2026-10-01-wikipedia-cve]]、[[sources/2026-10-01-wikipedia-zh-cve]]
- 新增：[[concepts/cve]]、[[tools/trivy]]、[[tools/syft-grype]]、[[organizations/mitre]]、[[organizations/nist]]、[[organizations/ntia]]
- 更新：[[standards/swid]]（stub→draft）、[[concepts/vex]]（stub→draft）、[[regulations/ntia-minimum-elements]]（補七項欄位）、[[regulations/eo-14028]]、[[concepts/sbom]]、[[concepts/software-supply-chain]]、[[standards/spdx]]、[[standards/cyclonedx]]、[[organizations/cisa]]、[[overview]]、[[index]]
- 備註：矛盾已標示——[[standards/swid]]（NIST 一手頁稱 ISO 定義、NIST 推廣，MIC／中文維基稱 NIST 開發）；[[organizations/mitre]]（兩版維基的 FFRDC 名稱不同）。MIC 稱 NTIA「要求」三種格式之一，用語待對照原文。

## [2026-10-01] ingest | 第三批 Anchore 工具文件與 .NET 實測（raw/tools、raw/assets）
- 新增：[[sources/2026-10-01-anchore-oss-overview]]、[[sources/2026-10-01-anchore-syft-readme]]、[[sources/2026-10-01-anchore-grype-readme]]、[[sources/2026-10-01-anchore-sbom-generation-guide]]、[[sources/2026-10-01-anchore-vulnerability-scanning-guide]]、[[sources/2026-10-01-syft-grype-dotnet-sample]]
- 新增：[[practices/dotnet-sbom-syft-grype]]、[[organizations/anchore]]
- 更新：[[tools/syft-grype]]（stub→draft，納入 Grant 與實測）、[[standards/cyclonedx]]（實測見 specVersion 1.7）、[[standards/spdx]]、[[concepts/vex]]（Grype 支援 OpenVEX）、[[concepts/cve]]、[[concepts/sbom]]、[[overview]]、[[index]]
- 備註：無矛盾；資策會對 Syft／Grype 的二手描述獲官方文件支持。`publish.sbom.cdx.json`、`publish.grype.json`、`Anchore tools flow.png` 為輔助資料，併入對應來源頁而未各自建頁。決定保留單一 [[tools/syft-grype]] 頁而未拆成 syft、grype、grant 三頁（拆分需先徵得同意）。

## [2026-10-01] lint | 首次健康檢查（38 頁）
- 機械檢查：frontmatter 欄位、wikilink、孤兒頁、raw 未引用、來源路徑、腳註對應，皆無問題
- 發現：未經來源驗證的推論 1 項、章節偏離範本 2 頁、缺少交叉引用 1 項、反覆提及但無專頁的概念 5 項、時效資訊 2 項
- 備註：本次僅回報，未修改內容；待使用者同意後修正

## [2026-10-01] lint | 修正首次健康檢查的 4 項問題
- 更新：[[concepts/software-supply-chain]]（統計口徑改標推論待驗證）、[[standards/spdx]]、[[standards/cyclonedx]]（改依 templates/standard.md 章節，補 current_version／maintainer，移除無來源的 ECMA-424 別名）、[[practices/sbom-file-naming]]（補工具連結與實測檔名差異）、[[regulations/eo-14028]]（補時效聲明）
- 備註：purl／CPE、SCA、in-toto／SLSA、NVD／EPSS／KEV、Grant 等概念頁尚未建立，待使用者指定

## [2026-10-01] ingest | Microsoft sbom-tool README（raw/tools/sbom-tool.md）
- 新增：[[sources/2026-10-01-microsoft-sbom-tool]]、[[tools/microsoft-sbom-tool]]
- 更新：[[standards/spdx]]（補 2.2／3.0 版本線索）、[[practices/sbom-file-naming]]、[[practices/dotnet-sbom-syft-grype]]（補替代方案）、[[overview]]、[[index]]
- 備註：來源內部矛盾——標題稱 SPDX 2.2、內文稱 2.2 與 3.0，已於工具頁標示。資策會稱「微軟提供 SPDX 格式 SBOM 檢測工具」獲官方 README 支持。Component Detection、ClearlyDefined 尚無專頁。

## [2026-10-01] lint | 第二次健康檢查（40 頁）
- 發現：`raw/tools/` 整個目錄被移到 `raw/standards/tools/`（原因不明，疑為 Obsidian 拖曳），造成 41 筆 frontmatter `sources` 路徑失效、7 個 raw 檔案顯示未被引用
- 發現：index.md 6 個條目的來源數與頁面 frontmatter 不符（sbom、software-supply-chain、vex、cyclonedx、sbom-file-naming、dotnet-sbom-syft-grype）
- 備註：本次僅回報，未修改；raw/ 為人類擁有，待使用者決定移回或改路徑

## [2026-10-01] lint | 修正第二次健康檢查的問題
- 處理：`raw/standards/tools/` 移回 `raw/tools/`（依使用者同意），41 筆失效的 `sources` 路徑恢復
- 更新：[[index]]（6 個條目的來源數對齊頁面 frontmatter）

## [2026-10-02] ingest | openvex/vexctl README（raw/tools/vexctl.md）
- 新增：[[sources/2026-10-02-openvex-vexctl-readme]]、[[tools/vexctl]]
- 更新：[[concepts/vex]]（補 OpenVEX 結構、狀態值、justification、驗證、簽證、多文件重播）、[[overview]]、[[index]]
- 備註：無矛盾；CycloneDX 與 OpenVEX 的 justification 詞彙不同，已於 [[concepts/vex]] 註記。OpenVEX 規格、sigstore／cosign／in-toto 尚無專頁或一手來源。

## [2026-10-02] query | syft-grype-vexctl 使用順序流程圖
- 新增：[[analyses/syft-grype-vexctl-workflow]]
- 更新：[[index]]
- 備註：grype `--vex` 實際用法待驗證

## [2026-10-02] ingest | Retire.js 網站與 GitHub README（raw/tools/）
- 新增：[[sources/2026-10-02-retirejs-website]]、[[sources/2026-10-02-retirejs-repo]]、[[tools/retire-js]]
- 更新：[[standards/cyclonedx]]（補 Retire.js 支援的 1.4／1.6／1.7 與 `_VEX` 變體）、[[overview]]（新增論點 10、路線圖）、[[index]]
- 備註：矛盾——網站列 Firefox 擴充為正式組成，README 標為 deprecated，已於工具頁以 callout 標示。網站漏洞表約 730 列，筆數為粗略解析，未逐筆 ingest。

## [2026-10-02] lint | 第三次健康檢查（46 頁）
- 結果：frontmatter 完整、無孤兒頁、無失效 wikilink、`sources` 路徑皆存在、raw 檔案皆已被引用、index 來源數與 frontmatter 一致
- 發現：[[sources/2026-10-02-retirejs-website]] 稱漏洞表「約八成篇幅」，實際近乎全文；[[concepts/sbom]] 的「與 SCA 差異」仍無來源；purl、SCA、OWASP 等被多頁提及但無專頁
- 備註：本次僅回報，未修改

## [2026-10-02] lint | 修正第三次健康檢查的問題
- 處理：[[sources/2026-10-02-retirejs-website]] 的「約八成篇幅」改為「幾乎全文」

## [2026-10-02] ingest | 建立 purl 概念頁（依既有來源，非新來源）
- 新增：[[concepts/purl]]
- 更新：[[index]]
- 備註：僅整理 vexctl 文件、syft 實測 SBOM 內的 purl 用法；purl 規格一手來源尚缺，結構細節標（待驗證）。

## [2026-10-05] ingest | CycloneDX/cyclonedx-dotnet README（raw/tools/）
- 新增：[[sources/2026-10-05-cyclonedx-dotnet-readme]]、[[tools/cyclonedx-dotnet]]
- 更新：[[standards/cyclonedx]]（補 1.0–1.7 可選版本與 .NET 工具）、[[tools/microsoft-sbom-tool]]、[[practices/dotnet-sbom-syft-grype]]（補替代方案）、[[overview]]（論點 8 改為三條路線）、[[index]]
- 備註：無矛盾。剪藏中「This module runs on」被截斷；`docs/best-practices.md`、`docs/bom-metadata.md` 尚未蒐集；三工具對同一 .NET 專案的元件清單差異待實測。

## [2026-10-05] ingest | cyclonedx-dotnet 實測筆記（raw/tools/）
- 新增：[[sources/2026-10-05-cyclonedx-dotnet-practice]]
- 更新：[[tools/cyclonedx-dotnet]]（補 6.2.0 實測紀錄）、[[practices/dotnet-sbom-syft-grype]]、[[overview]]、[[index]]
- 備註：無矛盾。實測預設輸出 XML；檔名 `-cdx.json` 與 [[practices/sbom-file-naming]] 慣例不同。未附 BOM 內容，無法與 syft 比較元件清單。

## [2026-10-05] ingest | cyclonedx-dotnet 實測筆記（重新 ingest，raw 已修訂）
- 更新：[[sources/2026-10-05-cyclonedx-dotnet-practice]]（原文引句改為修訂後文字，補預設檔名 `bom.xml`、JSON 範例說明）、[[tools/cyclonedx-dotnet]]
- 備註：raw 修訂僅為措辭補充，無新事實，結論與矛盾狀態不變。

## [2026-10-05] ingest | cyclonedx-dotnet 實測筆記（第二次重新 ingest，新增「為何使用」段）
- 更新：[[sources/2026-10-05-cyclonedx-dotnet-practice]]、[[tools/cyclonedx-dotnet]]、[[tools/syft-grype]]（補授權資訊限制）、[[practices/dotnet-sbom-syft-grype]]（補陷阱）、[[overview]]（論點 8）、[[index]]
- 備註：新事實——使用者測得 syft 取不到 .NET 套件授權資訊。與 [[tools/syft-grype]] 的「支援 .NET（NuGet）」不矛盾（元件偵測 vs 授權欄位），但為其限制；本庫檢視 `publish.sbom.cdx.json` 無 license 欄位，相符。Grant 在 .NET 的效用為推論，待驗證。

## [2026-10-06] ingest | CycloneDX 組織首頁、cyclonedx-cli README、sbom-tools README（Clippings → raw/）
- 新增：[[sources/2026-10-06-cyclonedx-org-github]]、[[sources/2026-10-06-cyclonedx-cli-readme]]、[[sources/2026-10-06-sbom-tools-readme]]、[[tools/cyclonedx-cli]]、[[tools/sbom-tools]]、[[organizations/owasp]]
- 更新：[[standards/cyclonedx]]（補 ECMA-424 別名、10 類 BOM、Protobuf、1.0–1.7 工具支援）、[[standards/spdx]]（SPDX 互轉與工具支援）、[[regulations/ntia-minimum-elements]]（補 CISA 2026 後繼版，待驗證）、[[concepts/vex]]（sbom-tools 的 VEX 閘門）、[[tools/microsoft-sbom-tool]]（加與 sbom-tools 的辨識提醒）、[[overview]]（新增論點 11、路線圖）、[[index]]
- 備註：矛盾已解決——[[standards/cyclonedx]] 先前因無來源移除的 ECMA-424，現由官方首頁支持而補回（批准日期待查）。路徑修正——`raw/tools/sbom-tool.md` 已被使用者更名為 `Microsoft sbom-tool.md`，已同步更新 overview、spdx、sbom-file-naming、dotnet-sbom-syft-grype、microsoft-sbom-tool 與其來源頁的 `sources` 路徑（舊 log 條目保留原樣）。CISA 2026 最低要素 v2.1 僅由 sbom-tools 轉述，尚無原文。

## [2026-10-06] lint | 第四次健康檢查與修正
- 結果：機械檢查全過（無失效連結、孤兒頁，`sources` 路徑與 index 來源數一致）
- 處理：[[tools/sbom-tools]]、[[tools/microsoft-sbom-tool]] 的「不產生 SBOM」無來源，改為「README 未列 SBOM 產生功能（待驗證）」
- 備註：SCA／KEV／CSAF／Sigstore／SARIF／CBOM 仍無專頁；CISA 2026 最低要素仍待原文

## [2026-10-07] ingest | @cyclonedx/cyclonedx-npm README（Clippings → raw/tools/）
- 新增：[[sources/2026-10-07-cyclonedx-npm-readme]]、[[tools/cyclonedx-npm]]
- 更新：[[standards/cyclonedx]]（1.6 預設、1.2–1.6 可選、工具清單）、[[overview]]（論點 10 補 npm 路線，來源 25 份）、[[index]]
- 備註：無矛盾。預設規格 1.6 低於 cyclonedx-dotnet 的 1.7，屬工具差異。僅讀文件，未實測；「最準確、完整」為廠商自評；pnpm／yarn 支援待驗證。

## [2026-10-07] lint | 第五次健康檢查與修正
- 結果：機械檢查全過（58 頁無失效連結、孤兒頁；25 份 raw 皆已 ingest；來源頁原文引句對照 raw 無誤，12 處標示為連結格式／弧形引號誤判）
- 處理：[[tools/retire-js]] 補與 [[tools/cyclonedx-npm]] 分工的待實測說明；[[concepts/purl]] 補 `--short-PURLs` 資訊損失（來源 4 份）；[[index]] 移除工具區多餘空行
- 備註：未處理——[[standards/cyclonedx]] 仍為 stub 且含 2024-02 的 ISO 說法；OWASP SCVS、in-toto、SARIF、KEV、CSAF、Sigstore 仍無專頁；npm／React 實務流程待實測

## [2026-10-07] ingest | dotnet-sbom-scan.sh、dotnet-js-sbom-scan.sh（Clippings → raw/tools/）
- 新增：[[sources/2026-10-07-dotnet-sbom-scan-script]]、[[sources/2026-10-07-dotnet-js-sbom-scan-script]]、[[practices/dotnet-sbom-cyclonedx-trivy]]
- 更新：[[tools/trivy]]（`trivy sbom` 掃弱點與授權）、[[tools/cyclonedx-dotnet]]、[[tools/cyclonedx-cli]]（merge 實務）、[[tools/retire-js]]（覆蓋缺口）、[[practices/dotnet-sbom-syft-grype]]（交叉引用）、[[overview]]（論點 12，來源 27 份）、[[index]]
- 備註：無矛盾。待查——腳本用 `dotnet-CycloneDX --json`，與實測筆記的 `-F Json` 是否等價；未見實跑輸出，trivy 的 .NET／前端授權與弱點比對品質未驗證。

## [2026-10-07] lint | 第六次健康檢查與修正
- 結果：機械檢查全過（61 頁無失效連結、孤兒頁、frontmatter 缺欄；27 份 raw 皆已 ingest；index 來源數與 `sources` 一致）
- 處理：[[tools/retire-js]] 頁首「尚無實測」改為含使用者腳本說明；[[tools/trivy]] 支援範圍補 SBOM 輸入的 .NET／前端用法
- 備註：未處理——[[standards/cyclonedx]] 仍為 stub 且含 2024-02 的 ISO 說法；OWASP SCVS、in-toto、SARIF、KEV、CSAF、Sigstore、SCA 仍無專頁；`dotnet-CycloneDX --json` 與 `-F Json` 是否等價待查；法規一手來源（EO 14028、NTIA、CRA）仍缺

## [2026-10-07] ingest | SBOM-實戰分享.marp.md（Clippings → raw/industry/）
- 新增：[[sources/2026-10-07-sbom-practice-talk-deck]]、[[practices/sbom-lifecycle-and-ci]]
- 更新：[[practices/dotnet-sbom-cyclonedx-trivy]]、[[practices/dotnet-sbom-syft-grype]]（路線選擇、交叉引用）、[[overview]]（論點 13，來源 28 份）、[[index]]
- 備註：無矛盾。此簡報為本庫的衍生品，事實多已有其他來源，不作獨立佐證；僅 CI gate 建議、重掃迴圈、路線選擇為新增（作者建議，未實測）。

## [2026-10-07] lint | 第七次健康檢查
- 結果：機械檢查全過（63 頁無失效連結、孤兒頁、`sources` 路徑失效；28 份 raw 皆已 ingest；index 來源數與 `sources` 一致）。`index.md` 的 frontmatter 無 `sources`／`status`，屬索引頁慣例，未處理
- 內容抽查：新簡報的 Heartbleed／NotPetya／SolarWinds／XZ、96%／70–90%、syft 1.52.0／grype 0.119.0／DB v6.1.9 皆與既有頁一致，無矛盾
- 備註：未處理——Log4Shell 僅見於 [[concepts/software-supply-chain]] 一行，尚無專頁；[[standards/cyclonedx]] 仍為 stub；OWASP SCVS、in-toto、SARIF、KEV、CSAF、Sigstore、SCA、Dependency-Track 仍無專頁；法規一手來源（EO 14028、NTIA、CRA、CISA 2026）仍缺

## [2026-10-07] schema | 簡報歸類修正：raw/industry → wiki/analyses
- 原因：簡報由本庫提煉而成，屬衍生成品，不應放在 raw 來源層；依 Karpathy LLM Wiki 模式，查詢產出回存為 wiki 頁面
- 移動：`raw/industry/SBOM-實戰分享.marp.md` → [[analyses/sbom-practice-talk.marp]]（補 frontmatter）
- 刪除：`sources/2026-10-07-sbom-practice-talk-deck`（來源前提不成立；內容併入該分析頁與 [[practices/sbom-lifecycle-and-ci]]）
- 更新：[[practices/sbom-lifecycle-and-ci]]、[[practices/dotnet-sbom-cyclonedx-trivy]]、[[practices/dotnet-sbom-syft-grype]]、[[overview]]（來源回復 27 份）、[[index]]
- 備註：先前 ingest 紀錄中的來源頁與 raw 路徑已失效，以本筆為準。`slides/` 的 pptx 仍在 wiki 外，CLAUDE.md §3 尚未載明。

## [2026-10-07] schema | CLAUDE.md 補 slides/ 與簡報慣例
- 修改：§3 目錄樹新增 `slides/`（匯出成品，不 ingest／lint），`analyses/` 註明可放 `.marp.md`；§4.1 補簡報檔名慣例
- 備註：對應 [[analyses/sbom-practice-talk.marp]] 與 `slides/` 的 pptx

## [2026-10-07] schema | slides/ 更名為 outputs/
- 修改：目錄 `slides/` → `outputs/`（涵蓋簡報、PDF、圖表等匯出成品）；CLAUDE.md §3、§4.1 與 [[index]] 同步更新
- 備註：現有檔案 `outputs/sbom-practice-talk.pptx`，對應 [[analyses/sbom-practice-talk.marp]]

## [2026-10-12] ingest | npm-sbom-scan.sh（新）與兩支 .NET 腳本的修改
- 新增：[[sources/2026-10-12-npm-sbom-scan-script]]、[[practices/npm-sbom-cyclonedx-trivy]]
- 更新：[[tools/cyclonedx-npm]]（實測紀錄）、[[tools/trivy]]（`--list-all-pkgs=false`）、[[practices/dotnet-sbom-cyclonedx-trivy]]、[[sources/2026-10-07-dotnet-sbom-scan-script]]、[[sources/2026-10-07-dotnet-js-sbom-scan-script]]、[[overview]]（論點 12，來源 28 份）、[[index]]
- 備註：無矛盾。`dotnet-sbom-scan.sh`、`dotnet-js-sbom-scan.sh` 僅新增 `--list-all-pkgs=false`（及檔尾換行），未另建來源頁；該旗標用途為推測，待驗證。npm 腳本專案為 `TFB_RES-client`，與 `WFAHRS` 不同。`.obsidian/` 設定檔非來源，未 ingest。

## [2026-10-12] lint | 第八次健康檢查
- 結果：機械檢查全過（65 頁無失效連結、孤兒頁、frontmatter 缺欄；`raw/` 皆已 ingest；index 皆收錄）。`index` 頁首格式說明與 log 指向已刪除來源頁的連結為誤報
- 未處理：[[analyses/sbom-practice-talk.marp]] 的 `sources` 為 wiki 路徑（衍生頁設計）；「cyclonedx-npm 與 retire／Syft 清單差異待實測」散見 4 頁，待實測後一併更新
- 備註：19 頁仍為 stub；[[standards/cyclonedx]] 仍含 2024-02 ISO 說法；OWASP SCVS、in-toto、SARIF、KEV、CSAF、Sigstore、SCA、Log4Shell、Dependency-Track 仍無專頁；法規一手來源（EO 14028、NTIA、CRA、CISA 2026）仍缺

## [2026-10-28] query | outputs/sbom-practice-talk.pptx 版面潤稿
- 修改：`outputs/sbom-practice-talk.pptx`（僅版面，不改文字）——主題繁中字型對應由新細明體改為微軟正黑體；第 4 頁「說文解字」移除 `###` 標記、改用段距、標題對齊並補頁碼；第 2 頁調整提問區塊間距
- 備註：使用者先前直接在 pptx 新增第 4 頁並修改第 2、9、10、13、14、28 頁文字，尚未回寫 [[analyses/sbom-practice-talk.marp]]，兩者內容已不一致。outputs/ 非 wiki 頁，無類型可對應，暫記為 query。
