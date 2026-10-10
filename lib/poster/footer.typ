// ─────────────────────────────────────────────────────────────────────────────
// 页脚（前景层）：左下信息块 = 竖排药丸 + 二维码 + 项目 / 方向 / 年度。
// ─────────────────────────────────────────────────────────────────────────────

#import "@preview/tiaoma:0.3.0"
#import "../includes.typ" as inc
#import "../typography.typ" as typo
#import "../layout.typ" as layout
#import "shared.typ": ui

// 二维码：白底留边，确保在任意背景上可扫。
#let qr(url) = box(fill: white, inset: layout.footer.qr-inset, radius: layout.footer.qr-radius, tiaoma.barcode(url, "QRCode", options: (
  scale: 2.0,
  fg-color: black,
  bg-color: white,
  dot-size: 1.0,
  output-options: (barcode-dotty-mode: false),
)))

#let info-value(t, first: false) = text(
  font: typo.fonts.footer,
  size: if first { typo.sizes.footer-primary } else { typo.sizes.footer-secondary },
  weight: if first { "semibold" } else { "regular" },
  fill: if first { luma(50) } else { luma(110) },
  t,
)

#let info-row(label, value) = text(font: typo.fonts.footer, size: typo.sizes.footer-row)[#text(fill: luma(110))[#label · ]#text(fill: luma(50))[#value]]

// 竖排小药丸。
#let discover-pill() = rotate(-90deg, reflow: true, par(leading: layout.footer.pill-leading, text(
  font: typo.fonts.footer-pill,
  size: typo.sizes.footer-pill,
  weight: "semibold",
  fill: inc.deepin-blue,
  ui.discover.split("\n").join(linebreak()),
)))

// 左下信息块：药丸 +（可选）二维码 + 信息行。
#let info-block(programme: none, school: none, direction: none, year: none, qr-url: none) = {
  let primary = if programme != none { programme } else { school }
  let rows = (
    if primary != none { (info-value(primary, first: true),) } else { () },
    if direction != none { (info-row(ui.orientation, direction),) } else { () },
    if year != none { (info-row(ui.year, year),) } else { () },
  ).flatten()
  let cells = (
    discover-pill(),
    if qr-url != none { qr(qr-url) } else { none },
    stack(dir: ttb, spacing: layout.footer.rows-gap, ..rows),
  ).filter(c => c != none)
  grid(columns: cells.len(), column-gutter: layout.footer.gutter, align: horizon, ..cells)
}
