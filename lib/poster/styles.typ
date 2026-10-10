// ─────────────────────────────────────────────────────────────────────────────
// 全局排版样式片段：由 deepin-poster 通过 set/show 规则引用。
// ─────────────────────────────────────────────────────────────────────────────

#import "shared.typ": ui
#import "../layout.typ" as layout

// 图注补充文字：按元素类型返回「图 / 表 / 代码」。
#let caption-supplement(it) = {
  let f = it.func()
  if f == table { ui.table } else if f == raw { ui.listing } else { ui.figure }
}

// 书版式表格边框：表头上下加粗，其余细线。
#let table-stroke(x, y) = (
  top: if y == 0 { layout.table.rule-heavy + luma(28%) } else { layout.table.rule-light + luma(80%) },
  bottom: if y == 0 { layout.table.rule-mid + luma(28%) } else { layout.table.rule-light + luma(80%) },
  left: layout.table.rule-light + luma(82%),
  right: layout.table.rule-light + luma(82%),
)
