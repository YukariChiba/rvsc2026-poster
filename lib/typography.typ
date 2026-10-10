// ─────────────────────────────────────────────────────────────────────────────
// 统一排版：各层级的字体族与字号档位映射
//
// 约定：
//   • 海报中每个「层级」（标题、副标题、卡片标题、正文、图注、页脚……）在
//     本文件映射到某个字体族与某个字号档位；
//   • lib/ 下的组件一律引用本文件的变量，不得写死字体名或 pt 字号；
//   • 主文档（poster.typ）等外部文档不得自行指定 font / size，需要新层级时
//     先在此处补充，再经由 lib 组件使用。
//
// 「字体族」与「字号」各自有独立的单一事实来源：
//   • 字体栈（含缺字回退）见 lib/fonts.typ；
//   • 字号档位（preset）也见 lib/fonts.typ 的 size-presets；
// 本文件只做「层级 → 字体族 / 字号档位」的映射，不直接写 pt / em 数值。
// 因此要调整字号，请改 lib/fonts.typ 的 size-presets，而不是这里。
// ─────────────────────────────────────────────────────────────────────────────

#import "fonts.typ": sans-font, raw-font, math-font, size-presets as sz

// ── 字体族：层级 → 字体栈 ─────────────────────────────────────────────────────
#let fonts = (
  // 标题区
  title:          sans-font,
  subtitle:       sans-font,
  author:         sans-font,
  author-label:   sans-font,
  author-sub:     sans-font,
  poster-id:      sans-font,
  summit:         sans-font,

  // 正文与卡片
  body:           sans-font,
  card-title:     sans-font,
  card-subtitle:  sans-font,
  subhead:        sans-font,
  subhead-sub:    sans-font,
  note:           sans-font,
  term:           sans-font,
  term-desc:      sans-font,

  // 注：全宽概览（deepin-wide）复用卡片标题 / 正文字形，故不另设 wide-* 层级。

  // 图示
  flow-title:     sans-font,
  flow-desc:      sans-font,
  flow-arrow:     sans-font,

  // 信息图（图表 / 矩阵 / 时间线 / 对比 / 进度）
  timeline-label: sans-font,
  timeline-desc:  sans-font,
  diagram-label:  sans-font,
  diagram-sub:    sans-font,
  tile-title:     sans-font,
  tile-desc:      sans-font,
  stat-value:     sans-font,
  stat-label:     sans-font,

  // 页脚
  footer:         sans-font,
  footer-pill:    sans-font,

  // 药丸标签（信息图通用）
  pill:           sans-font,

  // 代码与数学
  raw:            raw-font,
  math:           math-font,
)

// ── 字号：层级 → 字号档位（档位数值见 lib/fonts.typ 的 size-presets） ────────
#let sizes = (
  // 标题区
  title:          sz.display,
  subtitle:       sz.hero,
  author:         sz.heading,
  author-label:   sz.lead,
  author-sub:     sz.lead,
  poster-id:      sz.lead,
  summit:         sz.subhead,

  // 正文与卡片
  body:           sz.body,
  card-title:     sz.heading,
  card-subtitle:  sz.body,
  card-icon:      sz.heading,
  subhead:        sz.body,
  subhead-sub:    sz.xxsmall,
  note:           sz.note,
  caption:        sz.caption,
  term:           sz.xsmall,
  term-desc:      sz.xxsmall,

  // 图示
  flow-title:     sz.small,
  flow-desc:      sz.xxsmall,
  flow-arrow:     sz.xxsmall,

  // 信息图（图表 / 矩阵 / 时间线 / 对比 / 进度）
  timeline-label: sz.body,
  timeline-desc:  sz.small,
  diagram-label:  sz.small,
  diagram-sub:    sz.xxsmall,
  tile-title:     sz.medium,
  tile-desc:      sz.xxsmall,
  stat-value:     sz.body,
  stat-label:     sz.body,

  // 页脚
  footer-primary:   sz.lead,
  footer-secondary: sz.small,
  footer-row:       sz.small,
  footer-pill:      sz.micro,

  // 药丸标签（信息图通用）
  pill:             sz.small,
)
