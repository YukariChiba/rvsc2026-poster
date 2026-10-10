// ─────────────────────────────────────────────────────────────────────────────
// 术语 / 仓库清单：两列网格，每项为「名称（品牌蓝加粗）+ 说明（灰）」。
// 字形取自 lib/typography.typ，主文档只提供数据。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "../includes.typ" as inc

// items 为 (名称, 说明) 数组。
#let deepin-term-grid(items, columns: (1fr, 1fr), column-gutter: layout.term.gutter, row-gutter: layout.term.row-gutter) = grid(
  columns: columns,
  column-gutter: column-gutter,
  row-gutter: row-gutter,
  ..items.map(r => stack(
    dir: ttb,
    spacing: layout.term.item-gap,
    text(font: typo.fonts.term, size: typo.sizes.term, weight: "bold", fill: inc.deepin-blue, r.at(0)),
    text(font: typo.fonts.term-desc, size: typo.sizes.term-desc, fill: luma(85), r.at(1)),
  )),
)
