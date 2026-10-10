// ─────────────────────────────────────────────────────────────────────────────
// 全宽区块（用于概览区）：复用 deepin-card，仅覆盖为「全宽横幅」的版式度量。
// 标题左、副标题右，正文全宽，视觉与卡片保持一致。
// ─────────────────────────────────────────────────────────────────────────────

#import "../layout.typ" as layout
#import "card.typ": deepin-card

#let deepin-wide(title: "", subtitle: none, icon: none, body) = deepin-card(
  title: title,
  subtitle: subtitle,
  icon: icon,
  fill: white,
  gap: 0em,
  // 全宽概览沿用与卡片相同的标题 / 正文间距与字形，仅边距与描边更轻。
  stroke: layout.wide.stroke,
  radius: layout.wide.radius,
  inset: layout.wide.inset,
  text-fill: luma(30),
)[#body]
