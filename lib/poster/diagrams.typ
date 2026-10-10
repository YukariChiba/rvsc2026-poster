// ─────────────────────────────────────────────────────────────────────────────
// 信息图（cetz 绘制）：时间线、流水线、分层栈。
//
// 这些组件把正文里「密密麻麻的表格 / 分点罗列」提炼为图形。绘制用社区包
// @preview/cetz（LGPL，绘图库）；字形取自 lib/typography.typ，间距 / 圆角 /
// 线宽取自 lib/layout.typ 的 info 分组，颜色取自 lib/includes.typ。
//
// 每个组件都用 layout() 取当前可用宽度，再以该宽度作为 cetz 的长度单位，
// 因此图会随卡片宽度自适应；坐标统一以画布宽度的比例（0–1）表示。
// 画布内外各画一个透明矩形（见 _frame）以锁定画布尺寸，避免内容外溢改变版面。
// ─────────────────────────────────────────────────────────────────────────────

#import "../typography.typ" as typo
#import "../layout.typ" as lay
#import "../includes.typ" as inc
#import "icon.typ": deepin-icon

// 画布几何常量（cetz 坐标 = 画布宽度的比例）。集中在此，便于统一调整。
// 注：时间线 / 分层栈的纵向留白不在此写死，而是按字号换算（见各函数），
// 以免宽幅画布（如全宽概览）把留白按宽度放大。
#let _geo = (
  pad: 0.02,
  pipeline-margin: 0.016,  // 流水线画布上下留白（比例）
  arrow: 0.04,            // 流水线箭头水平占位
  stack-vpad: 0.010,      // 分层栈画布上下留白（比例）
  stack-row-h: 0.058,     // 分层栈每层高度
  stack-gap: 0.016,       // 分层栈层间距
  timeline-pad: 0.08,     // 时间线首尾留白
)

// 每个画布内部以透明矩形锁定边界（宽 1、高 h），避免内容外溢改变版面。
// 说明见文件头注释。

// 图内主标题 / 说明。
#let _title(body, color: inc.deepin-blue) = text(
  font: typo.fonts.diagram-label, size: typo.sizes.diagram-label, weight: "bold", fill: color, body,
)
#let _sub(body, color: inc.deepin-muted) = text(
  font: typo.fonts.diagram-sub, size: typo.sizes.diagram-sub, weight: "regular", fill: color, body,
)

// ── 时间线：横向节点轴（合并原路线图与进度节点） ────────────────────────────
// entries —— 条目数组，元素为字典或二元组：
//   · 字典：{label, desc?, state?, place?}
//   · 二元组：(label, desc)
// place   —— 文字位置，默认 "below"：
//   · "below" 文字（标题 + 说明）在轴下方
//   · "above" 文字在轴上方
//   · "split" 标题在上、说明在下
// node    —— 默认节点样式（可用条目的 state 覆盖）：
//   · "point"  空心圆 + 实心点   · "dot"   实心点
//   · "ring"   空心圆            · "done"  实心圆 + 勾
//   · "active" 加粗空心圆 + 点   · "todo"  灰色空心圆
// spacing —— 可选：相邻节点中心距（长度，如 8cm），用于控制「点之间连线的长度」；
//            省略时节点在整幅宽度内均匀分布（两端留白为 pad 比例）。
#let deepin-timeline(entries, place: "below", node: "point", pad: none, spacing: none) = {
  let pad = if pad == none { _geo.timeline-pad } else { pad }
  // 归一化条目。
  let items = entries.map(e => {
    if type(e) == dictionary {
      (
        label: e.at("label"),
        desc: e.at("desc", default: none),
        state: e.at("state", default: none),
        place: e.at("place", default: place),
      )
    } else {
      (label: e.at(0), desc: if e.len() > 1 { e.at(1) } else { none }, state: none, place: place)
    }
  })
  let n = items.len()
  layout(ly => {
    import "@preview/cetz:0.5.2"
    // 纵向几何按字号换算（而非画布宽度），宽幅画布下留白不会被放大。
    let r = typo.sizes.timeline-label * 0.42 / ly.width
    let dy = typo.sizes.timeline-label * 1.0 / ly.width
    let margin = typo.sizes.timeline-desc * 0.15 / ly.width
    // 以画布宽度为单位估算文字块高度，据此决定轴的位置与画布高度。
    let label-h = typo.sizes.timeline-label * 1.3 / ly.width
    let desc-h = typo.sizes.timeline-desc * 1.45 / ly.width
    let stacked-h = label-h + 0.3 * typo.sizes.timeline-label / ly.width + desc-h
    let above-need = calc.max(..items.map(it => if it.place == "above" { stacked-h } else if it.place == "split" { label-h } else { 0 }))
    let below-need = calc.max(..items.map(it => if it.place == "below" { stacked-h } else if it.place == "split" { desc-h } else { 0 }))
    let top = margin + r + (if above-need > 0 { dy + above-need } else { 0 })
    let bottom = margin + r + (if below-need > 0 { dy + below-need } else { 0 })
    let h = top + bottom
    let yc = bottom
    // 节点横向位置：默认在整幅宽度内均匀分布；给定 spacing 时以固定中心距居中排布。
    let xs = if spacing == none {
      range(n).map(i => pad + i * (1 - 2 * pad) / calc.max(1, n - 1))
    } else {
      let step = spacing / ly.width
      let x0 = (1 - (n - 1) * step) / 2
      range(n).map(i => x0 + i * step)
    }
    cetz.canvas(length: ly.width, {
      import cetz.draw: rect, circle, line, content
      rect((0, 0), (1, h), stroke: none, fill: none)
      // 时间轴轨道：跨越全部节点，两端各留一点点。
      line((xs.first() - 0.012, yc), (xs.last() + 0.012, yc),
        stroke: (paint: inc.deepin-track, thickness: lay.info.connector * 3, cap: "round"))
      for (i, it) in items.enumerate() {
        let x = xs.at(i)
        let style = if it.state != none { it.state } else { node }
        // 节点
        if style == "done" {
          circle((x, yc), radius: r, fill: inc.deepin-blue, stroke: none)
          line((x - r * 0.5, yc), (x - r * 0.12, yc - r * 0.45), (x + r * 0.5, yc + r * 0.5),
            stroke: (paint: white, thickness: lay.info.connector * 1.3, cap: "round", join: "round"))
        } else if style == "active" {
          circle((x, yc), radius: r, fill: white, stroke: (paint: inc.deepin-blue, thickness: lay.info.connector * 1.6))
          circle((x, yc), radius: r * 0.45, fill: inc.deepin-blue, stroke: none)
        } else if style == "todo" {
          circle((x, yc), radius: r, fill: white, stroke: (paint: luma(150), thickness: lay.info.connector * 1.2))
        } else if style == "dot" {
          circle((x, yc), radius: r * 0.55, fill: inc.deepin-blue, stroke: none)
        } else if style == "ring" {
          circle((x, yc), radius: r, fill: white, stroke: (paint: inc.deepin-blue, thickness: lay.info.connector))
        } else {
          circle((x, yc), radius: r, fill: white, stroke: (paint: inc.deepin-blue, thickness: lay.info.connector))
          circle((x, yc), radius: r * 0.42, fill: inc.deepin-blue, stroke: none)
        }
        // 文字
        let label-fill = if style == "todo" { luma(150) } else { inc.deepin-blue }
        let label = text(font: typo.fonts.timeline-label, size: typo.sizes.timeline-label, weight: "bold", fill: label-fill, it.label)
        let desc = if it.desc == none { none } else {
          text(font: typo.fonts.timeline-desc, size: typo.sizes.timeline-desc, fill: inc.deepin-muted, it.desc)
        }
        let block = stack(dir: ttb, spacing: lay.info.label-gap, align(center, label), if desc != none { align(center, desc) })
        let up = it.place == "split" or it.place == "above"
        let down = it.place == "split" or it.place == "below"
        // 刻度线
        if up { line((x, yc + r * 0.5), (x, yc + dy - 0.002), stroke: (paint: inc.deepin-line, thickness: lay.info.node-stroke)) }
        if down { line((x, yc - r * 0.5), (x, yc - dy + 0.002), stroke: (paint: inc.deepin-line, thickness: lay.info.node-stroke)) }
        if up {
          content((x, yc + dy), anchor: "south", if it.place == "split" { label } else { block })
        }
        if down and desc != none {
          content((x, yc - dy), anchor: "north", if it.place == "split" { desc } else { block })
        }
      }
    })
  })
}

// ── 流水线：横向阶段节点，箭头连接 ──────────────────────────────────────────
#let deepin-pipeline(steps) = {
  let n = steps.len()
  let pad = _geo.pad
  let aw = _geo.arrow
  let nw = (1 - 2 * pad - (n - 1) * aw) / n
  // 节点高度按内容（图标 + 标题 + 说明）估算，避免随画布宽度被无限放大。
  let has-icon = steps.any(s => s.len() > 2 and s.at(2) != none)
  let icon-h = if has-icon { typo.sizes.diagram-label * 1.5 } else { 0pt }
  let label-h = typo.sizes.diagram-label * 1.3
  let desc-h = typo.sizes.diagram-sub * 1.45
  let gap-h = typo.sizes.diagram-label * 0.25
  let content-h = icon-h + label-h + desc-h + (if has-icon { 2 } else { 1 }) * gap-h
  let vpad = typo.sizes.diagram-label * 0.5
  layout(ly => {
    import "@preview/cetz:0.5.2"
    let nh = (content-h + 2 * vpad) / ly.width
    let h = nh + 2 * _geo.pipeline-margin
    cetz.canvas(length: ly.width, {
      import cetz.draw: rect, circle, line, content
      rect((0, 0), (1, h), stroke: none, fill: none)
      let yc = h * 0.5
      for (i, s) in steps.enumerate() {
        let x0 = pad + i * (nw + aw)
        rect((x0, yc - nh / 2), (x0 + nw, yc + nh / 2), name: "stage" + str(i),
          radius: lay.info.node-radius, fill: white,
          stroke: (paint: inc.deepin-line, thickness: lay.info.node-stroke))
        content((x0 + nw / 2, yc), align(center, stack(
          dir: ttb, spacing: lay.info.label-gap,
          if s.len() > 2 and s.at(2) != none {
            stack(dir: ttb, spacing: lay.info.label-gap,
              deepin-icon(s.at(2), size: typo.sizes.diagram-label * 1.5, color: inc.deepin-blue),
              _title(s.at(0)))
          } else { _title(s.at(0)) },
          _sub(s.at(1)),
        )))
        if i > 0 {
          line((x0 - aw + 0.006, yc), (x0 - 0.006, yc),
            stroke: (paint: inc.deepin-blue, thickness: lay.info.connector),
            mark: (end: ">", fill: inc.deepin-blue, scale: 1.6))
        }
      }
    })
  })
}

// 分层栈的横向版本：各层自左向右排列，箭头指向右方。
#let _stack-horizontal(layers) = {
  let n = layers.len()
  let pad = _geo.pad
  let aw = _geo.arrow
  let nw = (1 - 2 * pad - (n - 1) * aw) / n
  let gap-h = typo.sizes.diagram-label * 0.3
  // 标题最多两行、说明最多两行，留出固定高度，保证各格等高且不溢出。
  let head-h = typo.sizes.diagram-label * 1.3 * 2
  let desc-h = typo.sizes.diagram-sub * 1.45 * 2
  let content-h = head-h + gap-h + desc-h
  let vpad = typo.sizes.diagram-label * 0.5
  layout(ly => {
    import "@preview/cetz:0.5.2"
    let nh = (content-h + 2 * vpad) / ly.width
    let h = nh + 2 * _geo.pipeline-margin
    cetz.canvas(length: ly.width, {
      import cetz.draw: rect, circle, line, content
      rect((0, 0), (1, h), stroke: none, fill: none)
      let yc = h * 0.5
      // 每格内容的可用宽度：约束换行，避免超出边框。
      let box-w = (nw - 0.03) * ly.width
      for (i, l) in layers.enumerate() {
        let x0 = pad + i * (nw + aw)
        rect((x0, yc - nh / 2), (x0 + nw, yc + nh / 2), radius: lay.info.node-radius,
          fill: if i == n - 1 { inc.deepin-chip } else { white },
          stroke: (paint: inc.deepin-line, thickness: lay.info.node-stroke))
        content((x0 + nw / 2, yc), block(width: box-w, {
          set par(justify: false)
          align(center, grid(
            columns: (auto, auto),
            column-gutter: lay.info.tile-icon-gap,
            align: horizon,
            if l.len() > 2 and l.at(2) != none { deepin-icon(l.at(2), size: typo.sizes.diagram-label * 1.15, color: inc.deepin-blue) } else { none },
            _title(l.at(0)),
          ))
          v(gap-h)
          align(center, _sub(l.at(1)))
        }))
        if i > 0 {
          line((x0 - aw + 0.006, yc), (x0 - 0.006, yc),
            stroke: (paint: inc.deepin-blue, thickness: lay.info.connector),
            mark: (end: ">", fill: inc.deepin-blue, scale: 1.6))
        }
      }
    })
  })
}

// ── 分层栈：默认纵向（数组首个为最底层，层间以向上箭头连接） ────────────────
// direction: "vertical"（默认，自下而上）或 "horizontal"（自左向右）。
#let deepin-stack(layers, direction: "vertical") = {
  if direction == "horizontal" { return _stack-horizontal(layers) }
  let n = layers.len()
  let padx = _geo.pad
  let pady = _geo.stack-vpad
  let row-h = _geo.stack-row-h
  let gap = _geo.stack-gap
  // 画布高度按内容精确计算，避免底部出现额外留白。
  let ch = 2 * pady + n * row-h + (n - 1) * gap
  layout(ly => {
    import "@preview/cetz:0.5.2"
    cetz.canvas(length: ly.width, {
      import cetz.draw: rect, circle, line, content
      rect((0, 0), (1, ch), stroke: none, fill: none)
      for (i, l) in layers.enumerate() {
        let y = pady + i * (row-h + gap)
        rect((padx, y), (1 - padx, y + row-h), radius: lay.info.node-radius,
          fill: if i == n - 1 { inc.deepin-chip } else { white },
          stroke: (paint: if i == n - 1 { inc.deepin-line } else { inc.deepin-line }, thickness: lay.info.node-stroke))
        content((padx + 0.022, y + row-h / 2), anchor: "west", grid(
          columns: (auto, auto), column-gutter: lay.info.tile-icon-gap, align: horizon,
          if l.len() > 2 and l.at(2) != none { deepin-icon(l.at(2), size: typo.sizes.diagram-label * 1.5, color: inc.deepin-blue) } else { none },
          _title(l.at(0)),
        ))
        content((1 - padx - 0.022, y + row-h / 2), anchor: "east", _sub(l.at(1)))
        if i > 0 {
          let x = 0.5
          line((x, y - gap + 0.004), (x, y - 0.004),
            stroke: (paint: inc.deepin-blue, thickness: lay.info.connector),
            mark: (end: ">", fill: inc.deepin-blue, scale: 1.5))
        }
      }
    })
  })
}
