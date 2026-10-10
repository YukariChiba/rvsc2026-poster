// Font configuration and the fallback page shown when the deepin fonts are
// absent. Ported from isc-hei-typst-templates (lib/fonts.typ) and adapted to a
// CJK-first font stack.

// Font stacks used by the framework. Chinese text is rendered with Source Han
// Sans (思源黑体), which also covers Latin; the remaining entries are graceful
// fallbacks. Without the CJK fonts installed, compilation silently falls back to
// the trailing system fonts.
#let body-font = ("Source Han Sans", "Noto Sans CJK SC", "Libertinus Serif")
#let sans-font = ("Source Han Sans", "Noto Sans CJK SC", "Inria Sans", "Libertinus Serif")
#let raw-font = ("Fira Code", "Source Han Sans", "Noto Sans CJK SC")
#let math-font = ("Asana Math", "Fira Math")

// ─────────────────────────────────────────────────────────────────────────────
// 字号预设（type scale）
//
// 海报的整条「字号阶梯」集中在此：由大到小的一组具名档位（preset）。
// lib/typography.typ 只负责把「层级」映射到这里的档位，组件再引用
// lib/typography.typ；因此要整体放大 / 缩小全文，只需调整本字典的值，
// 不必改动任何组件或主文档。
//
// 约定：
//   • 绝对档位用 pt，构成与字号无关的版面骨架（大标题、正文、页脚……）；
//   • 相对档位用 em，随父级字号自动缩放（行内注释、图注等）。
// ─────────────────────────────────────────────────────────────────────────────
#let size-presets = (
  // ── 绝对值（pt）：由大到小 ────────────────────────────────────────────────
  display:  84pt,   // 主标题
  hero:     56pt,   // 副标题
  heading:  48pt,   // 卡片标题 · 署名姓名 · 卡片图标
  subhead:  36pt,   // 页眉峰会名
  lead:     32pt,   // 从属信息 · 署名角色 · 页脚主值
  body:     28pt,   // 正文 · 卡片副标题 · 时间线主文字 · 统计
  medium:   24pt,   // 信息块标题
  small:    26pt,   // 图内说明 · 药丸 · 页脚次值 · 流程标题
  xsmall:   22pt,   // 术语名称
  xxsmall:  20pt,   // 说明小字 · 图内次级文字
  micro:    14pt,   // 页脚竖排小药丸

  // ── 相对值（em）：随父级字号缩放 ─────────────────────────────────────────
  note:     0.72em, // 行内小字注释
  caption:  1em, // 图 / 表题注
)

// Detect whether the deepin fonts are available using glyph-metric comparison.
// Source Han Sans (sans-serif) has markedly different capital widths from
// Libertinus Serif (always bundled in Typst). Equal widths means every font name
// fell back to Libertinus Serif, i.e. the fonts are not installed.
// Must be called from within a `context` block (uses measure()).
#let deepin-fonts-available() = {
  let _p   = "MMMMMMMMMM"
  let _sans = measure(text(font: ("Source Han Sans", "Noto Sans CJK SC"), size: 12pt, _p)).width
  let _lib  = measure(text(font: ("Libertinus Serif",), size: 12pt, _p)).width
  _sans != _lib
}

// Warning page rendered instead of the full document when the deepin fonts are
// absent. Deliberately uses only Libertinus Serif (always bundled in Typst) so
// the page itself renders correctly even without the custom fonts.
#let _missing-fonts-page(paper: "a4") = {
  // Wider margins on the large poster paper keep the warning box a sensible width.
  let margin = if paper == "a4" { (x: 3cm, y: 3cm) } else { (x: 18cm, y: 18cm) }
  set page(paper: paper, margin: margin, header: none, footer: none, numbering: none)
  set text(font: ("Libertinus Serif",), size: 11pt, fill: black)

  let accent = rgb("#008CFF")

  align(center + horizon,
    rect(
      width: 100%,
      stroke: (left: 5pt + accent, rest: 0.8pt + luma(200)),
      radius: 4pt,
      inset: (x: 2em, y: 1.8em),
      {
        align(center,
          text(size: 1.8em, weight: "bold", fill: accent)[⚠ deepin Poster — Fonts Not Installed]
        )
        v(1em)
        line(length: 100%, stroke: 0.5pt + luma(220))
        v(1em)

        [The CJK fonts required by this poster are *not installed* on this system.
        This document cannot be rendered with the correct typography.]
        v(1.2em)

        [*Install one of the following font families:*]
        v(0.3em)
        list(
          [*Source Han Sans CN* (思源黑体) — body and headings],
          [*Fira Code* — source code listings],
        )
        v(1.2em)

        text(style: "italic", size: 0.9em, fill: luma(100))[
          After installing the fonts, recompile the document.
        ]
      }
    )
  )
}
