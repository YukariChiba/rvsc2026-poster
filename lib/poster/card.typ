// ─────────────────────────────────────────────────────────────────────────────
// 内容卡片：deepin-card。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "../includes.typ" as inc
#import "icon.typ": deepin-icon

// 卡片标题行：标题左、副标题右（同一行，省纵向空间），下方一条与「图标＋标题」等长的品牌短色条。
// title 前可选 icon（Heroicons 图标名，见 heroicons.com）。
// 标题为空时直接返回正文。
#let section-head(title, subtitle, body, icon: none, head-gap: layout.card.head-gap, body-gap: layout.card.body-gap) = {
  if title == "" { return body }

  // 标题单元：有图标时「图标 + 标题」，否则仅标题。
  let title-cell = {
    let label = text(
      font: typo.fonts.card-title,
      size: typo.sizes.card-title,
      weight: "semibold",
      fill: inc.deepin-blue,
      title,
    )
    if icon == none {
      label
    } else {
      grid(
        columns: (auto, auto),
        column-gutter: layout.card.icon-gap,
        align: horizon,
        deepin-icon(icon, size: typo.sizes.card-icon),
        label,
      )
    }
  }

  context {
    // 短色条与「图标 + 标题」等长。
    let w = measure(title-cell).width
    stack(
      dir: ttb,
      spacing: 0pt,
      grid(
        columns: (auto, 1fr, auto),
        align: horizon,
        title-cell,
        [],
        if subtitle != none { text(font: typo.fonts.card-subtitle, size: typo.sizes.card-subtitle, weight: "regular", fill: luma(130), subtitle) },
      ),
      v(head-gap),
      align(left, rect(width: w, height: layout.card.rule-thickness, fill: inc.deepin-blue)),
      v(body-gap),
      body,
    )
  }
}

// 分栏卡片。
// 卡片内边距 / 圆角 / 边框与间距默认取自 lib/layout.typ 的 card 分组；
// 下列 auto 参数可逐项覆盖，deepin-wide（全宽概览）即借此复用本组件。
// gap: auto → 取 layout.card.gap；length → 显式覆盖。
#let deepin-card(
  title: "",
  subtitle: none,
  icon: none,
  fill: none,
  gap: auto,
  stroke: auto,
  radius: auto,
  inset: auto,
  head-gap: auto,
  body-gap: auto,
  text-fill: auto,
  body,
) = {
  let effective-gap = if gap != auto { gap } else { layout.card.gap }
  let pick(value, fallback) = if value != auto { value } else { fallback }
  // 正文风格在 block 之前设定：这样 block 的 em 边距（inset）以正文字号为基准，
  // 与字体大小挂钩而不受外层环境字号影响；set 不会泄漏到函数外。
  set text(font: typo.fonts.body, size: typo.sizes.body, weight: "regular")
  // 关闭 Typst 在块之间隐式加入的间距（默认 par.spacing ≈ 1.2em），
  // 让版面上的块间距完全由 #deepin-gap 决定，避免「显式间距 + 隐式间距」叠加。
  // 卡片块与卡片块之间的间距改由 layout.card.gap 显式给出。
  set block(spacing: 0pt)
  if text-fill != auto { set text(fill: text-fill) }
  block(
    fill: if fill != none { fill } else { white },
    width: 100%,
    inset: pick(inset, layout.card.inset),
    radius: pick(radius, layout.card.radius),
    stroke: pick(stroke, layout.card.stroke) + inc.deepin-panel-border,
    section-head(
      title,
      subtitle,
      body,
      icon: icon,
      head-gap: pick(head-gap, layout.card.head-gap),
      body-gap: pick(body-gap, layout.card.body-gap),
    ),
  )
  v(effective-gap)
}
