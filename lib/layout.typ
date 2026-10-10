// ─────────────────────────────────────────────────────────────────────────────
// 统一版式度量：页面边距、卡片边距、页脚间距、各类偏移（单一事实来源）
//
// 正像 lib/typography.typ 统一了「字体与字号」，本文件统一海报里所有「距离」：
// 页边距、内边距（inset / pad）、组件间距（gutter / gap）、纵向预留与偏移。
//
// 约定：
//   • 海报中任何距离都只在本文件定义（cm / mm / pt / em 一律写在这里）；
//   • lib/ 下的组件一律引用本文件的变量，不得写死距离；
//   • 主文档（poster.typ）不得自行写 v(…) / inset: … / margin: …；需要新的间距
//     时先在此处补充，再经由 lib 组件（如 #deepin-gap）使用。
//
// 计量单位：
//   • em  —— 相对当前字号的间距，随 lib/typography.typ 的字号自动缩放；
//   • cm / mm / pt —— 与字号无关的绝对量，构成版面骨架。
//
// 分组以 layout.<组>.<字段> 的方式引用，例如 layout.page.margin。
// ─────────────────────────────────────────────────────────────────────────────

// ── 页面骨架：页边距与页眉 / 页脚预留 ───────────────────────────────────────
#let page = (
  // 页边到正文、页眉、页脚与背景装饰的统一留白（约 4cm）。
  margin: 4cm,
  // 页眉底边与标题区之间的留白。
  header-gap: 0.8cm,
  // 标题区上方除页边距外的额外预留（≈ 页眉高度）。
  header-reserve: 3.6cm,
  // 页脚信息块上方除页边距外的额外预留（≈ 页脚高度）。
  footer-reserve: 3.6cm,
  // 标题溢出警告框距页面顶部的纵向偏移。
  warn-offset: 7cm,
  // 页脚分隔线粗细（横贯正文宽度）。
  rule-thickness: 2pt,
)

// ── 页眉 ────────────────────────────────────────────────────────────────────
#let header = (
  mark-height: 4cm,        // deepin mark 高度
  wordmark-height: 2.4cm,  // deepin wordmark 高度
  logo-height: 3.2cm,      // RISC-V 标志高度
  gutter: 0.5cm,           // mark / wordmark、标志 / 峰会名之间的水平间距
  summit-gutter: 0.3cm,    // 峰会名内部间距
)

// ── 标题区 ──────────────────────────────────────────────────────────────────
#let title = (
  subtitle-before: 1.5cm,  // 主标题与副标题之间
  subtitle-after: 8mm,     // 副标题与其下内容之间
  no-subtitle: 16pt,       // 无副标题时，主标题与其下内容之间
  authors-gap: 1.1cm,      // 从属信息与署名行之间
  divider-gap: 1.1cm,      // 署名行与品牌分隔线之间
  overview-gap: 1.1cm,     // 品牌分隔线与全宽概览之间
  bottom-trim: -100pt,      // 标题块底部负外边距（缩小与正文之间的默认间距）
  leading: 0.5em,          // 主标题多行时的行距
  author-line-gap: 20pt,   // 署名条目内「角色 / 姓名」两行之间
  author-sub-gap: 16pt,     // 姓名与其下联系方式之间
  authors-gutter: 1em,     // 各署名条目之间的水平间距
)

// ── 品牌分隔线（哈希点线） ──────────────────────────────────────────────────
#let divider = (
  bits-length: 64cm,       // 位点聚集的跨度（左对齐，其余为线）
  thickness: 2pt,          // 线粗
  square-size: 18pt,       // 两端方块边长
  circle-r: 6pt,           // 位点圆半径
  n-bits: 48,              // 表示哈希的位数
)

// ── 卡片 ────────────────────────────────────────────────────────────────────
#let card = (
  inset: 1.2em,              // 卡片内边距
  radius: 13pt,            // 卡片圆角
  stroke: 2pt,             // 卡片边框粗细（颜色见 lib/includes.typ）
  gap: 0.8em,              // 卡片之后的间距（卡片体内隐式块间距已关闭，故此处即实际间距）
  head-gap: 0.3em,         // 卡片标题与其下短色条之间的间距
  rule-thickness: 4pt,     // 卡片标题下的品牌短色条粗细（长度＝图标＋标题宽度）
  body-gap: 1.1em,         // 标题短色条与正文之间的间距
  icon-gap: 0.35em,        // 标题前图标与标题文字之间的水平间距
)

// ── 全宽区块（概览，复用 deepin-card） ─────────────────────────────────────
#let wide = (
  stroke: 1.5pt,           // 边框粗细
  radius: 13pt,            // 圆角
  inset: 1.2em,            // 内边距
)

// ── 卡片内子章节标题（deepin-subhead） ──────────────────────────────────────
#let subhead = (
  gap: 0.55em,             // 子标题与其下内容之间（em 相对于子标题字号）
  logo-height: 1.6cm,      // 右侧 logo 高度
)

// ── 流程带 ──────────────────────────────────────────────────────────────────
#let flow = (
  stroke: 2pt,             // 步骤边框粗细
  radius: 5pt,             // 步骤圆角
  inset: (x: 0.45em, y: 0.4em), // 步骤内边距
  step-gap: 0.4em,         // 步骤内「标题 / 说明」之间
  gutter: 0.35em,          // 步骤与箭头之间
)

// ── 术语 / 清单网格 ─────────────────────────────────────────────────────────
#let term = (
  gutter: 1.4em,           // 列间距
  row-gutter: 1em,         // 行间距
  item-gap: 0.4em,         // 条目内「名称 / 说明」之间
)

// ── 页脚信息块 ──────────────────────────────────────────────────────────────
#let footer = (
  qr-inset: 4pt,           // 二维码白色留边
  qr-radius: 2pt,          // 二维码圆角
  rows-gap: 10pt,          // 页脚信息行之间
  gutter: 3mm,             // 药丸 / 二维码 / 信息行之间
  pill-leading: 2pt,       // 竖排药丸的行距
)

// ── 背景点阵（右下角） ──────────────────────────────────────────────────────
#let background = (
  cols: 40,
  rows: 4,
  dot-d: 12pt,              // 圆点直径
  dot-gap: 8pt,            // 圆点间距
)

// ── 表格 ────────────────────────────────────────────────────────────────────
#let table = (
  inset: 5pt,              // 单元内边距
  rule-heavy: 1.6pt,       // 表头上边线（书版式粗线）
  rule-mid: 1.0pt,         // 表头下边线
  rule-light: 0.5pt,       // 其余细线
)

// ── 信息图通用度量 ──────────────────────────────────────────────────────────
// 下列度量供 lib/poster/blocks.typ（标签 / 药丸 / 统计块）与
// lib/poster/diagrams.typ（cetz 图示）共用。cetz 画布的坐标以画布宽度的
// 比例（0–1）为单位，其中以 em / pt 表示的量在此统一声明。
#let info = (
  // 药丸（pill）标签
  pill-inset: (x: 0.55em, y: 0.16em),
  pill-radius: 999pt,
  pill-gap: 0.3em,
  // 圆角信息块（device tile / stat tile）
  tile-inset: (x: 0.8em, y: 0.5em),
  tile-radius: 6pt,
  tile-stroke: 1.1pt,
  tile-accent: 3pt,        // 左侧强调色条宽度
  tile-gap: 0.5em,         // 块间距（横向）
  tile-row-gap: 0.42em,    // 块间距（纵向）
  tile-icon-gap: 0.4em,    // 图标与文字之间
  // 图内文字与节点
  node-radius: 7pt,        // cetz 圆角节点半径
  node-stroke: 1.4pt,      // cetz 节点描边
  connector: 1.6pt,        // 连接线 / 箭头粗细
  label-gap: 0.3em,        // 图内主标题与说明之间
  // 对比块（deepin-compare）
  compare-title-gap: 0.6em, // 标题与其下各条目之间
  compare-item-gap: 0.45em, // 条目与条目之间（行距）
  compare-item-gutter: 1em, // 条目分成多列时的列间距
)

// ── 插图 / 截图（deepin-figure / deepin-logo） ──────────────────────────────
#let figure = (
  height: 10cm,             // 截图默认高度（宽度按原比例自适应）
  gutter: 0.4em,           // 并排图片之间的间距
  radius: 8pt,             // 圆角
  stroke: 1pt,             // 描边粗细
  logo-height: 1.3cm,      // deepin-logo 默认高度
)

// ── 通用「块间距」：供主文档经 #deepin-gap 调用 ─────────────────────────────
// 卡片体内已关闭 Typst 的隐式块间距（见 lib/poster/card.typ），故下列数值
// 即段落与图示 / 表格 / 列表之间的实际间距（em 相对于正文字号）。
#let gap = (
  section: 1.0em,          // 段落与紧随其后的重点区块（时间线等）之间
  block:   0.7em,          // 段落与图示 / 表格 / 列表之间（默认）
  tight:   0.4em,          // 表格等与紧随其后的说明文字之间
)

// ── 其它版式预算（不影响实际排版，仅用于溢出判定与配色） ────────────────────

// 章节标题后的间距度量（字号见 lib/typography.typ）。
#let space-after-heading = 0.8em

// 行内代码与代码清单的背景色。
#let _luma-background = luma(250)

// 标题 / 副标题行数预算：超出即显示「排版警告」。仅影响溢出判定，不改变排版。
#let max-title-lines = 2
#let max-subtitle-lines = 2
