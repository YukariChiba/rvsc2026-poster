// ─────────────────────────────────────────────────────────────────────────────
// deepin-poster()：顶层 show 规则。
//
// 组合页眉 / 标题区 / 页脚 / 背景点阵，并交给 @preview/placard 排版分栏正文。
// 具体组件实现见 lib/poster/ 下的同名文件；本文件只负责编排。
//
// 参数（均为内容数据，由主文件传入）：
//   title              — 主标题
//   subtitle           — 副标题（可选）
//   overview           — 全宽概览区内容（可选）
//   authors            — 署名行条目数组，形如 ((角色, 姓名[, 联系方式]), …)；
//                        行数由数组长度决定，联系方式可省略
//   poster-id          — 海报编号（可选，显示在署名行右侧）
//   year               — 年度（可选，显示在左下信息块）
//   school             — 社区 / 机构名
//   programme          — 项目 / SIG 名
//   direction          — 工作方向（可选，显示为「方向 · …」）
//   summit             — 页眉右侧的峰会名称（可选）
//   qr-url             — 左下二维码链接（可选，none 则不绘制）
//   paper              — 纸张尺寸（Typst 预定义纸张名，默认 "a1"）。
//                        如 "arch-e"（36×48 in ≈ 91.44×121.92 cm）。
//   orientation        — "portrait"（默认）或 "landscape"
//   num-columns        — 卡片栏数（默认 2）
// ─────────────────────────────────────────────────────────────────────────────

#import "@preview/placard:0.1.0": placard as _placard
#import "../includes.typ" as inc
#import "styles.typ": caption-supplement, table-stroke
#import "../layout.typ" as layout
#import "../fonts.typ": _missing-fonts-page, deepin-fonts-available
#import "../typography.typ" as typo
#import "header.typ": poster-header
#import "title.typ": authors-row, poster-divider, seed-string, title-block
#import "footer.typ": info-block
#import "background.typ": dot-grid
#import "../overflow.typ" as overflow

#let deepin-poster(
  title: [海报标题],
  subtitle: none,
  overview: none,
  authors: (),
  poster-id: none,
  year: none,
  school: none,
  programme: none,
  direction: none,
  summit: none,
  qr-url: none,
  paper: "a1",
  orientation: "portrait",
  num-columns: 2,
  body,
) = {
  // 缺少字体时改为渲染提示页（沿用海报的纸张尺寸）。
  context if not deepin-fonts-available() { _missing-fonts-page(paper: paper) } else {
    // 可复现的 PDF：避免把当前时间写入 /CreationDate、/ModDate。
    set document(date: none)

    // ── 全局排版样式 ────────────────────────────────────────────────────────
    set figure(numbering: "1", supplement: caption-supplement)
    show raw: set text(font: typo.fonts.raw)
    show figure.caption: set text(size: typo.sizes.caption, fill: luma(90))
    set table(stroke: table-stroke, inset: layout.table.inset)

    // ── 标题区 / 页脚区的纵向预留（页边留白 + 页眉 / 页脚信息块高度） ────────
    let top-reserve = layout.page.margin + layout.page.header-reserve
    let bottom-reserve = layout.page.margin + layout.page.footer-reserve

    // ── 背景点阵（右下角） ──────────────────────────────────────────────────
    set page(background: place(bottom + right, pad(right: layout.page.margin, bottom: layout.page.margin, dot-grid())))

    // ── 页眉 ────────────────────────────────────────────────────────────────
    set page(header: pad(top: layout.page.margin, bottom: layout.page.header-gap, poster-header(summit: summit)))

    // ── 前景层：左下信息块 + 标题溢出警告 ──────────────────────────────────
    let info = info-block(
      programme: programme,
      school: school,
      direction: direction,
      year: year,
      qr-url: qr-url,
    )
    set page(foreground: {
      place(bottom + left, pad(left: layout.page.margin, bottom: layout.page.margin, info))
      // 页脚分隔线：横贯正文宽度，置于页脚信息块之上（内容区下缘）。
      // 用填充矩形而非 line()：后者会被上面的整宽 line show 规则一并丢弃。
      place(bottom + left, dy: -bottom-reserve, pad(x: layout.page.margin, rect(width: 100%, height: layout.page.rule-thickness, fill: inc.deepin-blue)))
      context {
        let issues = overflow.title-overflow-issues(title, subtitle: subtitle)
        if issues.len() > 0 {
          place(top + center, dy: layout.page.warn-offset, overflow.overflow-warning-box(issues, font: typo.fonts.body, width: 78%, scale: 3))
        }
      }
    })

    // ── 标题区 ──────────────────────────────────────────────────────────────
    let full-title = title-block(
      title,
      subtitle: subtitle,
      authors: authors-row(authors),
      divider: poster-divider(seed-string(poster-id) + if authors.len() > 0 { seed-string(authors.first().at(1)) } else { "" }),
      overview: overview,
    )

    // ── 丢弃 placard 的整宽分隔线（标题线 + 页脚线） ────────────────────────
    // 标题分隔线由标题区的哈希点线绘制；页脚分隔线改在页脚信息块上方自行绘制。
    show line: it => if it.length == 100% { none } else { it }

    // ── 交给 placard ────────────────────────────────────────────────────────
    _placard(
      title: full-title,
      authors: (),
      paper: paper,
      flipped: orientation == "landscape",
      num-columns: num-columns,
      // 上边距 = 标题块预留空间；下边距 = 页脚信息块预留空间。
      margin: (top: top-reserve, bottom: bottom-reserve, x: layout.page.margin),
      colors: (
        accent: inc.deepin-blue,
        heading: inc.deepin-blue,
        paper-fill: inc.deepin-paper,
        card-border: rgb("#cfe4ff"),
      ),
      fonts: (
        title: typo.fonts.title,
        authors: typo.fonts.author,
        body: typo.fonts.body,
        headings: typo.fonts.card-title,
        card: typo.fonts.body,
        footer: typo.fonts.footer,
      ),
      sizes: (title: typo.sizes.title, authors: typo.sizes.author, card: typo.sizes.body, body: typo.sizes.body),
      footer: (
        content: [],
        logo: none,
        logo-placement: right,
        text-placement: left,
      ),
      body,
    )
  } // else (fonts available)
}
