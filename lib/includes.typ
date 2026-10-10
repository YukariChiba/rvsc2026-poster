// ─────────────────────────────────────────────────────────────────────────────
// 公共依赖与品牌调色板（与海报内容无关）
// 移植自 isc-hei-typst-templates (lib/includes.typ)，主题改为 deepin。
// ─────────────────────────────────────────────────────────────────────────────

// deepin 品牌调色板
// 主色：deepin 蓝（用于强调、标题、分隔线与点阵装饰）
#let deepin-blue = rgb("#008CFF")
// 次色：deepin workmark 中的深蓝，用于深色基调
#let deepin-navy = rgb("#2659B8")
// 浅蓝：面板与边框
#let deepin-sky = rgb("#D6EBFF")
// 卡片 / 面板 / 流程步骤的浅蓝描边
#let deepin-panel-border = rgb("#cfe4ff")

// ── 信息图专用色（正文内的可视化组件共用） ───────────────────────────────────
// 图内主文字：比正文略深，保证大字号下的清晰度。
#let deepin-ink = rgb("#22303f")
// 图内次级 / 说明文字。
#let deepin-muted = luma(120)
// 标签 / 药丸底色（与 deepin-sky 区分，更浅以便叠放）。
#let deepin-chip = rgb("#EEF6FF")
// 轨道 / 进度底槽。
#let deepin-track = rgb("#e9f2ff")
// 图内细线与连接线（与卡片描边同源，略深一点便于在浅底上可见）。
#let deepin-line = rgb("#c6ddfb")

// ── 页面背景：多种低饱和浅色的线性渐变（整体保持偏白） ───────────────────────
// 各色仅作极浅的色相变化（蓝色 / 蓝紫 / 青绿），明度高、饱和度低，
// 用作纸张底色时既不是单色，也不会抢夺前景内容的注意力。
#let deepin-paper = gradient.linear(
  (rgb("#f9fcff"), 0%),
  (rgb("#eef4fe"), 28%),
  (rgb("#f3f0fc"), 52%),
  (rgb("#eef8f6"), 76%),
  (rgb("#f9fcff"), 100%),
  angle: 135deg,
)
