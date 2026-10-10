// ─────────────────────────────────────────────────────────────────────────────
// 标题区：主标题 / 副标题 / 署名行 / 品牌分隔线 /（可选）全宽概览。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
// 注：本文件用到 Typst 内建 layout() 函数，故版式模块改以 metrics 引入以免重名。
#import "../layout.typ" as metrics
#import "../decorations.typ": hash-rule

// 作者条目：title（角色标签，灰）在上，name（名字，粗）在下；
// contact 为可选第三行（联系邮箱 / 链接），为 none 时不占行。
#let author-entry(title, name, contact: none) = stack(
  dir: ttb,
  spacing: metrics.title.author-line-gap,
  text(font: typo.fonts.author-label, size: typo.sizes.author-label, weight: "regular", fill: luma(120), title),
  if contact != none {
    stack(dir: ttb, spacing: metrics.title.author-sub-gap, name, text(font: typo.fonts.author-sub, size: typo.sizes.author-sub, weight: "regular", fill: luma(160), contact))
  } else { name },
)

// 署名行：按传入条目数均分，行数由调用方决定（不再写死四栏）。
// 每个条目形如 (title, name) 或 (title, name, contact)；缺省 contact 即不显示第三行。
#let authors-row(entries) = grid(
  columns: entries.map(_ => 1fr),
  gutter: metrics.title.authors-gutter,
  ..entries.map(e => align(center, text(
    font: typo.fonts.author,
    size: typo.sizes.author,
    weight: "bold",
    fill: luma(30),
    author-entry(e.at(0), e.at(1), contact: e.at(2, default: none)),
  ))),
)

// 品牌分隔线：哈希点线，种子由海报编号与作者拼成，保证同一文档图案稳定。
#let poster-divider(seed) = layout(size => hash-rule(
  seed,
  length: size.width,
  bits-length: metrics.divider.bits-length,
  n-bits: metrics.divider.n-bits,
  thickness: metrics.divider.thickness,
  square-size: metrics.divider.square-size,
  circle-r: metrics.divider.circle-r,
))

// 将任意值转为可拼接的字符串（用于生成分隔线种子）。
#let seed-string(v) = if v == none { "" } else if type(v) == str { v } else { repr(v) }

// 标题块：标题 → 副标题 → 署名行 → 分隔线 →（可选）全宽概览。
// 段间用绝对间距，避免隐式段落间距；pad(bottom: …) 缩小 placard 在标题与内容之间的默认间距。
#let title-block(
  title,
  subtitle: none,
  authors: none,
  divider: none,
  overview: none,
) = {
  // hyphenate: false 防止长词被断开。
  let tight-title = {
    set par(leading: metrics.title.leading)
    set text(hyphenate: false)
    title
  }
  let parts = (
    tight-title,
    if subtitle != none { (metrics.title.subtitle-before, text(font: typo.fonts.subtitle, size: typo.sizes.subtitle, weight: "regular", subtitle), metrics.title.subtitle-after) } else { (metrics.title.no-subtitle,) },
    metrics.title.authors-gap,
    authors,
    metrics.title.authors-gap,
    divider,
    if overview != none { (metrics.title.overview-gap, align(left, overview)) } else { () },
  ).flatten()
  pad(bottom: metrics.title.bottom-trim, stack(dir: ttb, ..parts))
}
