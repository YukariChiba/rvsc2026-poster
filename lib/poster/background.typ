// ─────────────────────────────────────────────────────────────────────────────
// 背景装饰：右下角点阵，品牌蓝由左向右渐显。
// ─────────────────────────────────────────────────────────────────────────────

#import "../includes.typ" as inc
#import "../layout.typ" as layout

#let dot-grid(cols: layout.background.cols, rows: layout.background.rows, dot-d: layout.background.dot-d, dot-gap: layout.background.dot-gap) = {
  let cell = dot-d + dot-gap
  grid(
    columns: range(cols).map(_ => cell),
    rows: range(rows).map(_ => cell),
    align: center + horizon,
    ..range(cols * rows).map(idx => {
      let col = calc.rem(idx, cols)
      // 最左几乎不可见（95% 透明），最右完全不透明（0%）。
      let fade = 95% * (1 - col / (cols - 1))
      circle(radius: dot-d / 2, fill: inc.deepin-blue.transparentize(fade), stroke: none)
    }),
  )
}
