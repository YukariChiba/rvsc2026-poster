// ─────────────────────────────────────────────────────────────────────────────
// 信息图基础块：药丸标签、信息块 / 统计块、对比块。
//
// 这些组件把原先「密密麻麻的表格 / 分点罗列」提炼为可复用的图形单元：
// 主文档只提供数据（字符串 / 字典），字形取自 lib/typography.typ，
// 间距与圆角取自 lib/layout.typ 的 info 分组，颜色取自 lib/includes.typ。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "../includes.typ" as inc
#import "icon.typ": deepin-icon

// ── 药丸标签 ────────────────────────────────────────────────────────────────
// label  — 文本
// icon   — 可选 Heroicons 图标名（尺寸随药丸字号）
// dot    — 可选颜色，在文字前画一个小圆点（用于按类别着色）
// solid  — true 时用品牌蓝实底、白字（用于强调）
#let deepin-pill(label, icon: none, dot: none, solid: false) = {
  // 以药丸字号为基准：图标 / 圆点 / 间距的 em 值都相对它计算。
  set text(font: typo.fonts.pill, size: typo.sizes.pill)
  let fg = if solid { white } else { inc.deepin-navy }
  let accent = if solid { white } else { inc.deepin-blue }
  let body = text(weight: "medium", fill: fg, label)
  // 前导元素与文字用 grid + align: horizon 做垂直居中，避免靠上 / 靠下。
  let lead = if dot != none {
    box(width: 0.52em, height: 0.52em, radius: 50%, fill: dot)
  } else if icon != none {
    deepin-icon(icon, color: accent, size: 0.95em)
  } else {
    none
  }
  box(
    fill: if solid { inc.deepin-blue } else { inc.deepin-chip },
    radius: layout.info.pill-radius,
    inset: layout.info.pill-inset,
    if lead == none {
      body
    } else {
      grid(
        columns: (auto, auto),
        column-gutter: layout.info.pill-gap,
        row-gutter: 0pt,
        align: horizon,
        lead,
        body,
      )
    },
  )
}

// 一行会自动换行的药丸标签。
// tags 为 (字符串 | (icon: …, label: …) | (dot: …, label: …)) 数组。
#let deepin-tag-row(tags, gap: layout.info.pill-gap) = {
  // 标签行不两端对齐，避免药丸之间被拉开；以药丸字号为基准，间距才不会被放大。
  set par(justify: false)
  set text(font: typo.fonts.pill, size: typo.sizes.pill)
  let out = ()
  for (i, t) in tags.enumerate() {
    if i > 0 {
      out.push(h(gap))
      out.push([ ])
    }
    out.push(if type(t) == dictionary { deepin-pill(t.at("label"), icon: t.at("icon", default: none), dot: t.at("dot", default: none), solid: t.at("solid", default: false)) } else { deepin-pill(t) })
  }
  out.join()
}

// ── 圆角信息块（device tile / 通用小块） ─────────────────────────────────────
// 左侧一条品牌色强调条；可选图标、标题、说明，以及标题右侧右对齐的单个标签 `tag`。
// tag 为字符串，或 (icon: …, label: …) / (dot: …, label: …) / (solid: true, label: …)。
// highlight: true 时用浅蓝底 + 深蓝强调条，用于突出关键条目。
#let deepin-tile(
  title,
  desc: none,
  icon: none,
  tag: none,
  accent: auto,
  fill: auto,
  highlight: false,
  title-size: typo.sizes.tile-title,
) = block(
  width: 100%,
  fill: if highlight { inc.deepin-chip } else { if fill == auto { white } else { fill } },
  radius: layout.info.tile-radius,
  inset: layout.info.tile-inset,
  stroke: (left: layout.info.tile-accent + (if highlight { inc.deepin-navy } else { if accent == auto { inc.deepin-blue } else { accent } }), rest: layout.info.tile-stroke + inc.deepin-line),
  {
    set par(justify: false)
    set text(font: typo.fonts.tile-title, size: title-size, weight: "semibold", fill: inc.deepin-ink)
    // 标题单元：有图标时「图标 + 标题」，否则仅标题。
    let title-cell = if icon == none {
      text(title)
    } else {
      grid(
        columns: (auto, auto),
        column-gutter: layout.info.tile-icon-gap,
        align: horizon,
        deepin-icon(icon, size: title-size, color: if highlight { inc.deepin-navy } else { if accent == auto { inc.deepin-blue } else { accent } }),
        text(title),
      )
    }
    // 标题行：标题左、标签右（右对齐）。
    let head = grid(
      columns: (auto, 1fr, auto),
      align: horizon,
      title-cell,
      [],
      if tag != none { deepin-tag-row((tag,)) },
    )
    let children = (head,)
    if desc != none { children.push(text(font: typo.fonts.tile-desc, size: typo.sizes.tile-desc, weight: "regular", fill: inc.deepin-muted, desc)) }
    stack(dir: ttb, spacing: layout.info.label-gap, ..children)
  },
)

// 信息块网格。items 为 (title, …) 命名字典数组，或直接传关键字。
#let deepin-tiles(items, columns: 2, gap: layout.info.tile-gap, row-gap: layout.info.tile-row-gap) = grid(
  columns: columns,
  column-gutter: gap,
  row-gutter: row-gap,
  ..items.map(it => deepin-tile(
    it.at("title"),
    desc: it.at("desc", default: none),
    icon: it.at("icon", default: none),
    tag: it.at("tag", default: none),
    accent: it.at("accent", default: auto),
    fill: it.at("fill", default: auto),
    highlight: it.at("highlight", default: false),
  )),
)

// ── 统计块 ──────────────────────────────────────────────────────────────────
// 大号数值 + 小号说明，用于把「分点罗列」压缩成一眼可读的关键指标。
#let deepin-stat(value, label, icon: none, note: none) = block(
  width: 100%,
  fill: inc.deepin-chip,
  radius: layout.info.tile-radius,
  inset: layout.info.tile-inset,
  {
    set par(justify: false)
    stack(
      dir: ttb,
      spacing: layout.info.label-gap,
      if icon != none { deepin-icon(icon, size: typo.sizes.stat-value * 0.9, color: inc.deepin-blue) },
      text(font: typo.fonts.stat-value, size: typo.sizes.stat-value, weight: "bold", fill: inc.deepin-blue, value),
      text(font: typo.fonts.stat-label, size: typo.sizes.stat-label, weight: "regular", fill: inc.deepin-ink, label),
      if note != none { text(font: typo.fonts.tile-desc, size: typo.sizes.tile-desc, weight: "regular", fill: inc.deepin-muted, note) },
    )
  },
)

// 统计块网格。items 为 (value, label, icon?, note?) 命名字典数组。
#let deepin-stats(items, columns: 3, gap: layout.info.tile-gap) = grid(
  columns: columns,
  column-gutter: gap,
  ..items.map(it => deepin-stat(
    it.at("value"),
    it.at("label"),
    icon: it.at("icon", default: none),
    note: it.at("note", default: none),
  )),
)

// ── 条形图 ──────────────────────────────────────────────────────────────────
// items 为 (label, value, highlight?) 命名字典数组，用于把「各分类的数量对比」
// 压缩成一眼可读的横向条。颜色取自 lib/includes.typ。
#let deepin-bars(items, bar-height: 1em) = {
  set par(justify: false)
  set text(font: typo.fonts.pill, size: typo.sizes.pill)
  let maxv = calc.max(..items.map(it => it.at("value")))
  grid(
    columns: (auto, 1fr, auto),
    column-gutter: 0.7em,
    row-gutter: 0.4em,
    align: horizon,
    ..items.map(it => (
      text(fill: inc.deepin-ink, it.at("label")),
      rect(
        width: it.at("value") / maxv * 100%,
        height: bar-height,
        radius: 2pt,
        fill: if it.at("highlight", default: false) { inc.deepin-blue } else { inc.deepin-sky },
      ),
      text(weight: "bold", fill: inc.deepin-navy, str(it.at("value"))),
    )).flatten(),
  )
}

// ── 对比块 ──────────────────────────────────────────────────────────────────
// 左右两栏对照（如「旧基线 → 新基线」），中间以品牌箭头连接。
// side 形如 (title: …, items: ((标签, 值), …))，tone 为 "muted" / "accent"。
// item-columns: 每一栏内条目的列数（1＝单列，2＝双列，用于压缩纵向空间）。
#let _compare-side(side, tone, item-columns: 1) = block(
  width: 100%,
  fill: if tone == "accent" { inc.deepin-chip } else { luma(97%) },
  radius: layout.info.tile-radius,
  inset: layout.info.tile-inset,
  stroke: if tone == "accent" { layout.info.tile-stroke + inc.deepin-line } else { layout.info.tile-stroke + luma(88%) },
  stack(
    dir: ttb,
    spacing: layout.info.compare-title-gap,
    text(
      font: typo.fonts.stat-label,
      size: typo.sizes.stat-label,
      weight: "bold",
      fill: if tone == "accent" { inc.deepin-blue } else { luma(120) },
      side.at("title"),
    ),
    grid(
      columns: item-columns,
      column-gutter: layout.info.compare-item-gutter,
      row-gutter: layout.info.compare-item-gap,
      ..side.at("items").map(pair => grid(
        columns: (auto, 1fr),
        column-gutter: 0.5em,
        align: horizon,
        text(font: typo.fonts.pill, size: typo.sizes.pill, fill: inc.deepin-muted, pair.at(0)),
        align(right, text(
          font: typo.fonts.pill,
          size: typo.sizes.pill,
          weight: "bold",
          fill: if tone == "accent" { inc.deepin-navy } else { luma(110) },
          pair.at(1),
        )),
      )),
    ),
  ),
)

#let deepin-compare(before, after, arrow: "→", item-columns: 1) = grid(
  columns: (1fr, auto, 1fr),
  column-gutter: 0.6em,
  align: horizon,
  _compare-side(before, "muted", item-columns: item-columns),
  text(font: typo.fonts.card-title, size: typo.sizes.stat-value, weight: "bold", fill: inc.deepin-blue, arrow),
  _compare-side(after, "accent", item-columns: item-columns),
)
