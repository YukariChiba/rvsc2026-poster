// ─────────────────────────────────────────────────────────────────────────────
// 横向流程带：steps 为 (标题, 说明) 数组，元素间以箭头连接。
// ─────────────────────────────────────────────────────────────────────────────

#import "../includes.typ" as inc
#import "../typography.typ" as typo
#import "../layout.typ" as layout

#let flow-step(step) = block(
  width: 100%,
  fill: white,
  stroke: layout.flow.stroke + inc.deepin-panel-border,
  radius: layout.flow.radius,
  inset: layout.flow.inset,
  align(center, stack(
    dir: ttb,
    spacing: layout.flow.step-gap,
    text(font: typo.fonts.flow-title, size: typo.sizes.flow-title, weight: "bold", fill: inc.deepin-blue, step.at(0)),
    text(font: typo.fonts.flow-desc, size: typo.sizes.flow-desc, fill: luma(70), step.at(1)),
  )),
)

#let flow(steps) = {
  let arrow = text(font: typo.fonts.flow-arrow, size: typo.sizes.flow-arrow, weight: "bold", fill: inc.deepin-blue, "→")
  let cells = ()
  for (i, step) in steps.enumerate() {
    if i > 0 { cells.push(arrow) }
    cells.push(flow-step(step))
  }
  // 交替列：卡片 1fr、箭头 auto，故共 2n-1 列。
  let cols = range(steps.len() * 2 - 1).map(i => if calc.even(i) { 1fr } else { auto })
  grid(columns: cols, align: horizon, column-gutter: layout.flow.gutter, ..cells)
}
