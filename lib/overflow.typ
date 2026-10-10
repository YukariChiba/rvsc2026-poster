// ─────────────────────────────────────────────────────────────────────────────
// 标题 / 副标题溢出检测与警告框（内部工具，与内容无关）
// 移植自 isc-hei-typst-templates (lib/overflow.typ)。
//
// 标题过长会换行过多、破坏海报版面，因此这里用 measure() 精确测量，而不是数
// 字符。行数预算见 lib/layout.typ。
// ─────────────────────────────────────────────────────────────────────────────

#import "layout.typ" as layout
#import "fonts.typ": body-font

// 固定中文界面文案（本主题仅中文）。
#let _str-title-too-long = "标题过长，超出了允许的行数。"
#let _str-subtitle-too-long = "副标题过长，超出了允许的行数。"
#let _str-layout-warning = "⚠ 排版警告 — 内容可能溢出"

// ── 基准版面 ─────────────────────────────────────────────────────────────────
// 在所有文档中固定同一基准宽度与样式，保证溢出判定一致。
#let _ref-width          = 157mm
#let _ref-title-style    = body => par(leading: 11pt, text(body, font: body-font, size: 24pt, weight: 660))
#let _ref-subtitle-style = body => par(leading: 11pt, text(body, font: body-font, size: 12pt))

// 当 `body` 按 `style` 在 `width` 内换行后超过 `max-lines` 行时为真。
// 必须在 `context` 块中调用（内部使用 measure()）。
#let exceeds-lines(style, body, width, max-lines) = {
  let probe  = range(max-lines).map(_ => [M]).join(linebreak())
  let budget = measure(style(probe), width: width).height
  let actual = measure(style(body),  width: width).height
  actual > budget + 0.5pt // epsilon 吸收边界处的浮点误差
}

// 标题（或副标题）是否超过行数预算。必须在 `context` 块中调用。
#let title-too-long(title) = (
  title not in (none, "") and exceeds-lines(_ref-title-style, title, _ref-width, layout.max-title-lines)
)
#let subtitle-too-long(subtitle) = (
  subtitle not in (none, "") and exceeds-lines(_ref-subtitle-style, subtitle, _ref-width, layout.max-subtitle-lines)
)

// 返回溢出问题列表（中文文案），无溢出时为空。必须在 `context` 块中调用。
#let title-overflow-issues(title, subtitle: none) = {
  let issues = ()
  if title-too-long(title) { issues.push(_str-title-too-long) }
  if subtitle-too-long(subtitle) { issues.push(_str-subtitle-too-long) }
  issues
}

// 渲染红色警告框。
//   issues — 问题条目列表（每条渲染为 “— 文本”）
//   header — 红色标题行；默认为本地化文案
//   width  — 框宽（默认填满容器）
//   font   — 字体；none 时继承环境字体
//   scale  — 所有度量的倍数；A1 海报需放大（A4 尺寸会看不清）
#let overflow-warning-box(issues, header: none, width: 100%, font: none, scale: 1.0) = {
  let head = if header != none { header } else { _str-layout-warning }
  box(
    width: width,
    fill: rgb("#ffe3e3"),
    stroke: (2.5pt * scale) + rgb("#c1121f"),
    radius: 4pt * scale,
    inset: 10pt * scale,
    {
      set text(fill: rgb("#9d0208"))
      if font != none { set text(font: font) }
      text(weight: 900, size: 13pt * scale, head)
      v(4pt * scale)
      set text(size: 10pt * scale, weight: 500)
      for it in issues {
        block(below: 5pt * scale, [— #it])
      }
    },
  )
}
