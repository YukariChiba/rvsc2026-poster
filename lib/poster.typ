// ─────────────────────────────────────────────────────────────────────────────
// deepin 海报框架：公共 API 门面。
//
// 组件按类型拆分到 lib/poster/ 下，本文件只负责汇总并对外导出。
//
// 公共 API：
//   deepin-poster()    — 顶层 show 规则：可配置纸张、页眉、页脚与配色
//   deepin-card()      — 内容卡片（标题前可选 Heroicons 图标）
//   deepin-wide()      — 全宽区块（概览，复用 deepin-card）
//   deepin-subhead()   — 卡片内的子章节标题（品牌蓝小标题 + 短色条）
//   deepin-figure()    — 插图 / 截图（宽度档位 + 描边 + 注释）
//   deepin-figures()   — 多张插图并排（如两张截图一左一右）
//   deepin-logo()      — 内联 logo（统一高度）
//   deepin-icon()      — 行内图标（封装 @preview/heroic，随品牌色着色）
//   flow()             — 横向流程带
//   deepin-note()      — 行内小字注释（字形受控）
//   deepin-term-grid() — 术语 / 清单网格（字形受控）
//   deepin-gap()       — 块间距（度量取自 lib/layout.typ）
//   ── 信息图（blocks.typ）──
//   deepin-pill()      — 药丸标签
//   deepin-tag-row()   — 自动换行的标签行
//   deepin-tile()      — 圆角信息块（左侧强调条）
//   deepin-tiles()     — 信息块网格
//   deepin-stat()      — 统计块（大数值 + 说明）
//   deepin-stats()     — 统计块网格
//   deepin-bars()      — 横向条形图（分类数量对比）
//   deepin-compare()   — 左右对照块（旧 → 新）
//   ── 信息图（diagrams.typ，cetz 绘制）──
//   deepin-timeline()  — 横向时间线（文字可上/下，节点样式可配）
//   deepin-pipeline()  — 横向流水线
//   deepin-stack()     — 分层栈
// ─────────────────────────────────────────────────────────────────────────────

#import "poster/engine.typ": deepin-poster
#import "poster/card.typ": deepin-card
#import "poster/wide.typ": deepin-wide
#import "poster/subhead.typ": deepin-subhead
#import "poster/figure.typ": deepin-figure, deepin-figures, deepin-logo
#import "poster/icon.typ": deepin-icon
#import "poster/flow.typ": flow
#import "poster/inline.typ": deepin-note
#import "poster/term-grid.typ": deepin-term-grid
#import "poster/gap.typ": deepin-gap
#import "poster/blocks.typ": deepin-pill, deepin-tag-row, deepin-tile, deepin-tiles, deepin-stat, deepin-stats, deepin-bars, deepin-compare
#import "poster/diagrams.typ": deepin-timeline, deepin-pipeline, deepin-stack
