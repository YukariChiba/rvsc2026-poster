// ─────────────────────────────────────────────────────────────────────────────
// 插图组件：deepin-figure / deepin-logo。
//
// deepin-figure —— 截图 / 插图：按给定高度等比缩放、居中，带圆角描边与可选图下注释；
// deepin-logo   —— 内联 logo（如合作社区 / 计划标识），按高度统一缩放。
// 尺寸与圆角取自 lib/layout.typ 的 figure 分组，注释字形取自 lib/typography.typ。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "../includes.typ" as inc
#import "shared.typ": asset-path

// 插图 / 截图。
//   path    —— 图片路径（相对主文档）
//   height  —— 图片高度（宽度按原比例自适应，默认见 layout.figure.height）
//   caption —— 可选图下注释
#let deepin-figure(path, height: layout.figure.height, caption: none) = block(width: 100%, {
  set par(justify: false)
  align(center, box(
    radius: layout.figure.radius,
    clip: true,
    stroke: layout.figure.stroke + inc.deepin-line,
    fill: white,
    image(asset-path(path), height: height),
  ))
  if caption != none {
    align(center, text(
      font: typo.fonts.note,
      size: typo.sizes.note,
      fill: luma(110),
      caption,
    ))
  }
})

// 内联 logo：统一按高度缩放。
#let deepin-logo(path, height: layout.figure.logo-height) = image(asset-path(path), height: height)

// 多张插图并排（如两张截图一左一右）。
//   items   —— 数组，元素为图片路径字符串，或字典 (path: …, caption: …, height: …)
//   columns —— 列数（默认 2）
#let deepin-figures(items, columns: 2, height: layout.figure.height) = grid(
  columns: columns,
  column-gutter: layout.figure.gutter,
  row-gutter: layout.figure.gutter,
  ..items.map(it => if type(it) == dictionary {
    deepin-figure(
      it.at("path"),
      height: it.at("height", default: height),
      caption: it.at("caption", default: none),
    )
  } else {
    deepin-figure(it, height: height)
  }),
)
