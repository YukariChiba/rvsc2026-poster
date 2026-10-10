// ─────────────────────────────────────────────────────────────────────────────
// 页眉：左 deepin mark + wordmark；右 RISC-V 标志 + 峰会名称（两行加粗）。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as layout

#let poster-header(summit: none) = grid(
  columns: (auto, 1fr, auto),
  align: horizon,
  grid(
    columns: (auto, auto),
    column-gutter: layout.header.gutter,
    align: horizon,
    image("../assets/deepin_mark.svg", height: layout.header.mark-height),
    image("../assets/deepin_logo.svg", height: layout.header.wordmark-height),
  ),
  [],
  grid(
    columns: (auto, auto),
    column-gutter: layout.header.gutter,
    align: horizon,
    image("../assets/riscv_logo.svg", height: layout.header.logo-height),
    if summit != none {
      grid(
        columns: (auto, auto),
        column-gutter: layout.header.summit-gutter,
        align: horizon,
        text(font: typo.fonts.summit, size: typo.sizes.summit, weight: "bold", fill: luma(45), summit),
      )
    },
  ),
)
