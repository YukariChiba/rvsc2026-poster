// ─────────────────────────────────────────────────────────────────────────────
// 行内图标：deepin-icon。
//
// 直接复用 Typst 社区的 @preview/heroic（Heroicons，MIT），不内置任何图标资源：
// 图标以 SVG 路径内嵌在包中，随当前文字颜色（currentColor）着色，因此默认取
// 品牌蓝（来自 lib/includes.typ），配色仍是公开可改的单一事实来源。
//
// 图标名见 https://heroicons.com/。solid: false 为线描（outline）风格，
// 与本海报的细线条一致；solid: true 为实心风格。
// ─────────────────────────────────────────────────────────────────────────────

#import "@preview/heroic:0.1.2": icon as hero-icon
#import "../typography.typ" as typo
#import "../includes.typ" as inc

// 渲染一个 Heroicons 图标。
//   name  — 图标名，如 "cpu-chip"
//   color — 颜色，默认品牌蓝
//   size  — 图标高度（长度），默认取卡片标题图标档位
//   solid — 是否使用实心风格（默认线描）
#let deepin-icon(name, color: inc.deepin-blue, size: typo.sizes.card-icon, solid: false) = box(hero-icon(
  name,
  height: size,
  solid: solid,
  color: color,
))
