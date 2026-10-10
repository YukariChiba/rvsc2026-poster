// ─────────────────────────────────────────────────────────────────────────────
// 卡片内的子章节标题：deepin-subhead。
//
// 用于在同一张 deepin-card 内划分多个小节（如「社区协作与人才培养」下的三个计划）：
// 品牌蓝小标题（可带图标），右侧可选 logo。不带下方色条（色条只用于卡片标题）。
// 字形取自 lib/typography.typ，间距取自 lib/layout.typ 的 subhead 分组。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "../includes.typ" as inc
#import "icon.typ": deepin-icon
#import "shared.typ": asset-path

// title  —— 子章节标题
// icon   —— 可选 Heroicons 图标名
// logo   —— 可选 logo 图片路径，显示在标题行右端（高度见 layout.subhead.logo-height）
#let deepin-subhead(title, icon: none, logo: none) = {
  set par(justify: false)
  set text(font: typo.fonts.subhead, size: typo.sizes.subhead, weight: "semibold", fill: inc.deepin-blue)
  block(width: 100%, {
    grid(
      columns: (auto, 1fr, auto),
      align: horizon,
      if icon == none {
        text(title)
      } else {
        grid(
          columns: (auto, auto),
          column-gutter: layout.card.icon-gap,
          align: horizon,
          deepin-icon(icon, size: typo.sizes.subhead),
          text(title),
        )
      },
      [],
      if logo != none { image(asset-path(logo), height: layout.subhead.logo-height) },
    )
  })
  v(layout.subhead.gap)
}
