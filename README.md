# deepin · RISC-V 2026 中国峰会海报模板

一套面向中文（中英混排）的 **deepin 海报框架**，直接移植并改造自
[`isc-hei-typst-templates`](references/isc-hei-typst-templates) 的海报部分，
由 [Typst](https://typst.app) 排版。主文件 `poster.typ` 只调用 `lib/` 中现成的
轮子，不重复造轮子，写法与上游 `src/poster.typ` 基本一致。

## 快速开始

```bash
typst compile poster.typ            # 生成 poster.pdf（单页 91cm × 122cm）
typst watch poster.typ              # 边改边看
```

> 需要安装中文字体 **思源黑体 / Source Han Sans**（或 Noto Sans CJK）与
> **Fira Code**。若字体缺失，会改而渲染一张提示页。

## 结构：公共样式 vs. 内容

框架只分两层：**`lib/` 是公共样式（与内容无关）**，其余都在根目录。

```
lib/                     # 公共样式（可复用，不含本海报的具体文字与数据）
  includes.typ           # 品牌调色板（deepin 蓝等）
  layout.typ             # 版式度量：页面边距、卡片边距、页脚间距、各类偏移（单一事实来源）
  fonts.typ              # 中文字体栈 + 字号档位预设（size-presets）+ 缺字提示页
  typography.typ         # 各层级 → 字体族 / 字号档位的映射
  decorations.typ        # 标题分隔线的哈希点线
  overflow.typ           # 标题/副标题溢出检测与警告框
  poster.typ             # 公共 API 门面：汇总并导出下面的组件
  poster/                # 海报组件（按类型拆分）
    shared.typ           # 固定界面文案 + 跨组件状态
    styles.typ           # 全局排版样式（图注、表格边框）
    header.typ           # 页眉
    title.typ            # 标题区（标题/副标题/署名行/分隔线）
    footer.typ           # 页脚信息块（二维码、项目/方向/年度）
    background.typ       # 右下角点阵装饰
    card.typ             # deepin-card（标题前可选 Heroicons 图标）
    wide.typ             # deepin-wide（复用 deepin-card）
    subhead.typ          # deepin-subhead（卡片内的子章节标题）
    figure.typ           # deepin-figure / deepin-logo（插图 / 截图 / logo）
    icon.typ             # deepin-icon 行内图标（封装 @preview/heroic）
    flow.typ             # 横向流程带 flow()
    inline.typ           # deepin-note 行内小字注释
    term-grid.typ        # deepin-term-grid 术语/清单网格
    blocks.typ           # 信息图基础块：pill / tag-row / tile(s) / stat(s) / bars / compare
    diagrams.typ         # 信息图（cetz 绘制）：timeline / pipeline / stack
    gap.typ              # deepin-gap 块间距（度量取自 layout.typ）
    engine.typ           # deepin-poster 编排
  assets/                # 主题标志（deepin mark、wordmark、RISC-V）

assets/                  # 内容图片（合作方 logo、实机截图等，随主题替换）

poster.typ               # 主文件：只放内容配置 + 各板块内容
```

> 只为中文服务，因此**没有 `language` 字段、也没有 i18n**：固定界面文案直接写在
> `lib/poster/shared.typ`（主题 chrome），而社区名、项目名、峰会名、方向、链接等**内容
> 数据集中在 `poster.typ` 顶部**。替换主题时只需改 `poster.typ`。

> **字号只在 `lib/fonts.typ` 规定**：全文的「字号阶梯」是一组具名档位
> （`size-presets`：`display` / `hero` / `heading` / `body` / `small` / `note` ……），
> `lib/typography.typ` 只负责把每个「层级」（标题、副标题、卡片标题、正文、图注、页脚……）
> 映射到某个档位，`lib/` 内组件一律引用 `typography.sizes`。**主文档（`poster.typ`）不得
> 自行写 `set text(font: …)` 或 `text(size: …)`**；需要新的层级时先在 `lib/typography.typ`
> 补映射、需要新字号时先在 `lib/fonts.typ` 的 `size-presets` 补档位，再经由 `lib/` 组件使用。
> 要整体放大 / 缩小全文字号，只改 `size-presets` 一处即可。

> **页面 / 卡片 / 页脚边距与各类间距只在 `lib/layout.typ` 规定**：页边距、内边距
> （inset / pad）、组件间距（gutter / gap）、纵向预留与偏移等所有「距离」都在该文件
> 统一声明（`page` / `header` / `title` / `card` / `wide` / `flow` / `term`
> / `footer` / `background` / `table` / `gap` 等分组），`lib/` 内组件一律引用。**主文档
> 不得自行写 `v(…)`、`inset: …`、`margin: …` 等距离**；需要间距时用 `#deepin-gap("…")`
> 选择语义档位，需要新档位时先在 `lib/layout.typ` 的 `gap` 字典补充。

## 版面

- 页眉：左 deepin mark + wordmark；右 RISC-V 标志 + 两行峰会名 + 品牌方块。
- 标题区：主标题、副标题、署名行（行数自定义）。
- **全宽概览**（`deepin-wide`）：项目概览 + 里程碑时间线，铺满整页宽度。
- 两栏板块：其余各板块按内容排布，标题左、**副标题右**，内容随栏高自然流动。
- 正文以**信息图**取代密集表格与分点罗列：时间线 / 流水线 / 分层栈 / 对比块 /
  设备信息块（详见 API 的「信息图」一节；统计块、条形图等同为框架能力，可按需启用）。

## API

在主文件中：

```typst
#import "lib/poster.typ": deepin-poster, deepin-wide, deepin-card, deepin-subhead, deepin-figure, deepin-figures, deepin-icon, flow, deepin-note, deepin-term-grid, deepin-gap
// 信息图（可选）
#import "lib/poster.typ": deepin-pill, deepin-tag-row, deepin-tile, deepin-tiles, deepin-stat, deepin-stats, deepin-bars, deepin-compare, deepin-timeline, deepin-pipeline, deepin-stack
```

### `deepin-poster`

顶层 `show` 规则。`overview` 用于全宽概览区。

```typst
#show: deepin-poster.with(
  title: [海报标题],
  subtitle: [副标题],              // 可选
  overview: deepin-wide(title: "项目概览", subtitle: "…")[ … ], // 可选，全宽
  authors: (                       // 署名行：行数与要素自定义
    ("作者", "作者名", "a@b.c"),   // (角色, 姓名, 联系方式?)；第三项可省略
    ("维护者", "团队名"),
  ),
  poster-id: "RVSC-2026-01",      // 可选
  year: "2026",                   // 可选
  school: "deepin 社区",
  programme: "deepin-ports SIG",
  direction: "系统移植",           // 可选，显示为「方向 · …」
  summit: [RISC-V 2026\ 中国峰会], // 可选，页眉右侧（可两行）
  qr-url: "https://…",            // 可选，左下二维码
  paper: "arch-e",                // 纸张尺寸；91cm × 122cm ≈ Arch E（36×48 in）
  orientation: "portrait",        // 或 "landscape"
  num-columns: 2,
)
```

`authors` 为署名行条目数组，元素形如 `(角色, 姓名, 联系方式)`：**行数由数组长度决定**；
每栏显示为「角色（灰，上行）+ 姓名（粗，下行）」，末项 `联系方式` 省略时该行不显示。

### `deepin-wide(title, subtitle, icon, body)`

全宽区块（用于概览区），标题左、副标题右。**内部复用 `deepin-card`**，仅把描边、内边距等度量换成
`lib/layout.typ` 的 `wide` 分组；因此它与卡片共享同一套标题 / 正文字形与间距，图标能力也一并继承
（概览通常不传 `icon`）。

### `deepin-card(title, subtitle, icon, body)`

分栏卡片，标题左、副标题右，下方一条品牌短色杆。`icon` 可选：给出 Heroicons 图标名即在标题前显示
品牌蓝图标（见下）。

```typst
#deepin-card(title: "RISC-V 支持矩阵", subtitle: "10 个 SoC 家族 · 25+ 设备型号", icon: "cpu-chip")[
  正文内容……
]
```

### `deepin-subhead(title, icon, logo)`

卡片**内部**的子章节标题：品牌蓝小标题（可带 Heroicons 图标），用于在一张 `deepin-card` 里
划分多个小节（如「社区协作与人才培养」下的三个计划）。**不带下方色条**（色条只用于卡片标题）。
`logo` 可选：给出图片路径即在标题行右端显示 logo（高度取 `layout.subhead.logo-height`）。
字形取自 `lib/typography.typ`，间距取自 `lib/layout.typ` 的 `subhead` 分组。

```typst
#deepin-card(title: "社区协作与人才培养", subtitle: "甲辰计划 · 开源之夏", icon: "users")[
  #deepin-subhead("甲辰计划", icon: "gift", logo: "assets/plan-jiachen.png")
  小节正文……
  #deepin-gap("block")
  #deepin-tiles(( … ))

  #deepin-gap("section")
  #deepin-subhead("开源之夏 OSPP 2026", icon: "academic-cap", logo: "assets/plan-ospp.png")
  下一节……
]
```

### `deepin-figure(path, height, caption)` / `deepin-figures(items, columns)` / `deepin-logo(path, height)`

插图组件。`deepin-figure` 按 `height` 等比缩放并居中显示截图 / 插图，带圆角描边与可选图下
注释（`caption`）；`deepin-figures` 把多张插图并排（`columns` 列，元素为路径字符串或
`(path: …, caption: …)` 字典）；`deepin-logo` 用于内联 logo（如卡片内合作方标识），按
`height` 统一缩放。图片路径相对**工程根目录**书写（组件内部会解析为根路径）；尺寸见
`lib/layout.typ` 的 `figure` 分组。

```typst
#deepin-figure("assets/shot-k3-system.jpg", caption: "deepin 25 运行于 SpacemiT K3")
#deepin-figures((
  (path: "assets/shot-k3-system.jpg", caption: "实机系统"),
  (path: "assets/shot-k3-ai.jpg", caption: "本地 AI"),
))
#deepin-logo("assets/plan-ospp.png", height: 1.6cm)
```

### `deepin-icon(name, color, size, solid)`

行内图标，直接复用 Typst 社区的 [`@preview/heroic`](https://typst.app/universe/package/heroic)
（[Heroicons](https://heroicons.com)，MIT）——图标以 SVG 路径内嵌在包中，**不 vendor 任何图标资源**，
也不需要额外字体。`name` 为图标名，`color` 默认 `deepin-blue`，`size` 默认取卡片标题图标档位
（`lib/typography.typ` 的 `card-icon`），`solid` 为 `false`（线描）或 `true`（实心）。

图标随 `color` 着色，因此配色仍以 `lib/includes.typ` 的品牌色为单一事实来源。

```typst
#deepin-icon("cpu-chip")                                   // 默认品牌蓝、线描
#deepin-icon("users", color: rgb("#6b7280"), size: 24pt)   // 自定义颜色 / 尺寸
#deepin-icon("cube", solid: true)                          // 实心风格
```

### `flow(steps)`

横向流程带：`steps` 为 `(标题, 说明)` 数组，元素间以品牌箭头连接。

```typst
#flow((
  ("上游 / 源码", "内核 · 驱动 · 软件包"),
  ("定时构建", "deepin-riscv-kernel"),
))
```

### `deepin-timeline(entries, place, node, pad, spacing)`

横向时间线（由原「里程碑时间线」与「进度节点」合并而来）。`entries` 为条目数组，元素可以是
二元组 `(标题, 说明)`，也可以是字典 `(label: …, desc: …, state: …, place: …)`（后三项可选）。

- `place` —— 文字位置（可逐条用 `place` 覆盖）：`"below"`（默认，标题 + 说明在轴下方）、
  `"above"`（在上方）、`"split"`（标题在上、说明在下）。
- `node` —— 默认节点样式（可逐条用 `state` 覆盖）：`"point"`（空心圆 + 实心点）、
  `"dot"`（实心点）、`"ring"`（空心圆）、`"done"`（实心圆 + 勾）、
  `"active"`（加粗空心圆 + 点）、`"todo"`（灰色空心圆）。
- `pad` —— 节点在整幅宽度内均匀分布时，首尾的留白比例（默认 `0.08`）。
- `spacing` —— **可选长度**：相邻节点的中心距（如 `spacing: 10cm`），用于控制「点之间连线的
  长度」，此时整条时间线按该中心距居中排布；省略则在整幅宽度内均匀分布。

```typst
// 里程碑：标题在上、说明在下，默认节点
#deepin-timeline((("2023", "主线支持 RISC-V"), ("2026", "打通本地 AI")), place: "split")

// 进度节点：文字在下方，逐条指定节点样式
#deepin-timeline((
  (label: "Step 0", desc: "工具链升级",   state: "done"),
  (label: "Step 1", desc: "基础库重构建", state: "active"),
  (label: "Step 2", desc: "桌面组件重构建", state: "todo"),
))

// 固定节点间距（连线长度）：整条轴按 10cm 中心距居中
#deepin-timeline((("填表与审核", "…"), ("使用与反馈", "…"), ("寄回与验收", "…")), spacing: 10cm)
```

### `deepin-note(body)`

行内小字注释，字号/字体取自 `lib/typography.typ`，用于表格单元里对主条目的小字说明。

```typst
[StarFive JH7110\ #deepin-note[VF2 · MilkV Mars]], [4], [5.15 / 6.6 / 6.12], …
```

### `deepin-term-grid(items)`

术语 / 清单网格，两列，每项为「名称（品牌蓝加粗）+ 说明（灰）」，字形取自
`lib/typography.typ`。

```typst
#deepin-term-grid((
  ("ports-profiles", "设备配置与依赖关系"),
  ("ports-kernel", "厂商定制内核包"),
))
```

### `deepin-gap(level)`

块间距。主文档中段落与图示 / 表格 / 列表之间的纵向间距一律用它，避免自行写 `v(…)`。
`level` 为语义档位：`"section"`（区块之间，较大）、`"block"`（段落与图示 / 表格之间）、
`"tight"`（表格等与其后说明之间）；具体 em 值见 `lib/layout.typ` 的 `gap` 字典。

> 卡片体内已关闭 Typst 在块之间隐式加入的间距（默认 `par.spacing` ≈ 1.2em），
> 因此 `#deepin-gap` 的数值**就是**实际间距，不会被隐式间距叠加放大；卡片与卡片
> 之间的间距则由 `lib/layout.typ` 的 `card.gap` 统一给出。
> 时间线 / 分层栈等 cetz 图示的**纵向**留白按字号换算（而非画布宽度），
> 以免全宽画布把留白按宽度放大。

```typst
#flow(( … ))
#deepin-gap("block")
- 说明一
- 说明二
```

### 信息图组件

把原先密集的表格 / 分点罗列提炼为图形；所有信息图都会读取当前可用宽度自适应缩放。
图内字形取自 `lib/typography.typ`，间距 / 圆角 / 线宽取自 `lib/layout.typ` 的 `info` 分组。

- `deepin-compare(before, after, arrow, item-columns)` —— 左右对照块；`item-columns` 可把每栏
  条目分成多列（如 `2`）以压缩纵向空间。
- `deepin-stack(layers, direction)` —— 分层栈；`direction` 为 `"vertical"`（默认，自下而上）
  或 `"horizontal"`（自左向右）。

```typst
// 横向时间线：详见上面的 `deepin-timeline`（可定义文字位置与节点样式）
#deepin-timeline((("2023", "deepin 23 支持 RISC-V"), ("2026", "K3 适配 · 本地 AI")), place: "split")

// 横向流水线：steps = (标题, 说明, 图标?)；图标可省略
#deepin-pipeline((
  ("上游 / 源码", "内核 · 驱动 · 软件包", "cloud-arrow-down"),
  ("定时构建", "deepin-riscv-kernel", "cog-6-tooth"),
))

// 分层栈：layers = (标题, 说明, 图标?)，默认**自下而上**（首个为最底层）
#deepin-stack((
  ("SpacemiT K3", "8×X100 + 8×A100 · ~60 TOPS", "cpu-chip"),
  ("小U同学", "开箱即用的本地大模型", "sparkles"),
))

// 横向分层栈（自左向右），direction: "horizontal"
#deepin-stack((
  ("SpacemiT K3", "8×X100 + 8×A100", "cpu-chip"),
  ("小U同学", "本地运行大模型", "sparkles"),
), direction: "horizontal")
```

```typst
// 信息块网格：items 为命名字典数组；highlight: true 用浅蓝底 + 深蓝强调条突出关键项
// tag：可选，单个标签，显示在标题右侧并右对齐
#deepin-tiles((
  (icon: "cpu-chip", title: "StarFive JH7110", desc: "VF2 · MilkV Mars"),
  (icon: "sparkles", title: "SpacemiT K3", desc: "本地 AI 旗舰", highlight: true,
    tag: (solid: true, label: "RVA23")),
), columns: 2)

// 统计块网格：items = (value, label, icon?, note?)
#deepin-stats((
  (icon: "bolt", value: "≤ 1 月", label: "大版本镜像节奏", note: "内核 / SDK 即推"),
), columns: 3)

// 横向条形图：items = (label, value, highlight?)
#deepin-bars((
  (label: "SpacemiT K1", value: 6),
  (label: "SpacemiT K3", value: 1, highlight: true),
))

// 左右对照块（旧 → 新）
#deepin-compare(
  (title: "RVA20 · 本地主线", items: (("GCC", "12"), ("glibc", "2.38"))),
  (title: "RVA23 · Next 仓库", items: (("GCC", "15 / 16"), ("glibc", "2.42"))),
)

// item-columns: 2 —— 每栏条目分两列排布，压缩纵向空间
#deepin-compare(
  (title: "RVA20 · 本地主线", items: (("GCC", "12"), ("LLVM", "16"), ("glibc", "2.38"), ("binutils", "2.41"))),
  (title: "RVA23 · Next 仓库", items: (("GCC", "15 / 16"), ("LLVM", "21 / 22"), ("glibc", "2.42"), ("binutils", "2.46"))),
  item-columns: 2,
)
```

### `deepin-pill(label, icon, dot, solid)` / `deepin-tag-row(tags)`

药丸标签与可换行的标签行。`deepin-tile` 的 `tag`（单个标签）即以 `deepin-tag-row((tag,))`
渲染。`tags` 的每一项可以是字符串，或 `(icon: …, label: …)` / `(dot: …, label: …)` / `(solid: true, label: …)`。

`deepin-tile(title, desc, icon, tag, highlight)` 为单个圆角信息块（左侧品牌色强调条）；
`tag` 可选、仅一个，显示在标题右侧并右对齐。

## 视觉特性

- **页眉**：左 deepin mark + wordmark；右 RISC-V 标志 + 两行加粗峰会名 + 品牌方块。
- **署名行**：由 `authors` 数组决定行数与每行「角色 / 姓名 / 联系方式」三要素，等宽分布。
- **板块标题**：标题左 + 副标题右（同一行），下方一条**与「图标＋标题」等长**的品牌短色条；标题前可加品牌蓝 Heroicons 图标。
- **子章节标题**：卡片内可用 `deepin-subhead` 划分小节 —— 品牌蓝小标题（不带色条），右端可放 logo。
- **插图 / 截图**：`deepin-figure`（截图、圆角描边、可选注释）与 `deepin-logo`（内联 logo）；
  图片置于 `assets/`，路径相对工程根目录书写。
- **表格**：书版式 —— 表头上下加粗线，其余细线，数值列居中（作为备用；正文已尽量改用信息图）。
- **代码**：Fira Code 等宽字体（含中文回退），保留 Typst 语法高亮。
- **信息图**：`lib/poster/diagrams.typ`（cetz 绘制）的时间线 / 流水线 / 分层栈，
  与 `lib/poster/blocks.typ` 的药丸标签 / 信息块 / 统计块 / 对比块。此外仍保留
  `lib/poster/flow.typ` 的横向流程带（`flow`）。
- **页脚**：二维码 + 项目名 + 方向/年度 + 竖排小药丸；右下角点阵渐变。

## 主题定制

- **品牌色**：`lib/includes.typ` 中的 `deepin-blue`（`#008CFF`）、`deepin-navy`、`deepin-sky`、
  `deepin-panel-border`（卡片 / 面板 / 流程步骤描边）；信息图另有 `deepin-ink` / `deepin-muted` /
  `deepin-chip` / `deepin-track` / `deepin-line`。
- **页面背景**：`lib/includes.typ` 的 `deepin-paper` —— 由数种低饱和浅色组成的线性渐变
  （整体偏白），经 `deepin-poster` 作为纸张底色（`paper-fill`）传入。改这一处即可换底色。
- **Logo**：替换 `lib/assets/` 下的 `deepin_mark.svg`、`deepin_logo.svg`（wordmark）、`riscv_logo.svg`。
- **内容图片**：合作方 logo、实机截图等放在顶层 `assets/`，经 `deepin-figure` / `deepin-logo`
  引用。当前 `assets/plan-board-drift.png` 为**固定尺寸占位图**（开发板漂流计划暂无官方 logo），
  替换同名文件即可；也可用 `deepin-figure` 加入更多截图。
- **图标**：卡片标题前的 `icon` 与 `deepin-icon` 均来自 `@preview/heroic`（Heroicons），
  随品牌蓝着色；图标名见 [heroicons.com](https://heroicons.com)。
- **信息图配色与度量**：`lib/includes.typ` 的信息图色 + `lib/layout.typ` 的 `info` 分组
  （药丸内边距 / 圆角、信息块内边距 / 强调条、cetz 节点圆角 / 描边 / 连接线粗细），
  以及 `lib/typography.typ` 的 `timeline-*` / `diagram-*` / `tile-*` / `stat-*` 字号。
  绘制基于社区包 `@preview/cetz`（LGPL）。
- **固定文案**：`lib/poster/shared.typ` 顶部的 `ui` 字典与 `lib/overflow.typ` 顶部的警告文案。
- **字体栈**：`lib/fonts.typ` 顶部的字体族（含缺字回退）。
- **各层级字体与字号**：字体族由 `lib/typography.typ` 的 `fonts` 字典映射到
  `lib/fonts.typ` 的字体栈；字号由 `lib/typography.typ` 的 `sizes` 字典映射到
  `lib/fonts.typ` 的 `size-presets` 档位。**要整体调整字号，只改 `size-presets`
  一处即可**；不要在主文档里另设 `font` / `size`。
- **页面边距、卡片边距、页脚间距、各类偏移**：`lib/layout.typ` 的分组字典——改这一处即可
  整体调整版式度量。常用项：
  - `layout.page.margin`（默认 `4cm`）：页边到正文、页眉、页脚与背景装饰的统一留白；
  - `layout.page.header-reserve` / `footer-reserve`：标题区 / 页脚信息块上下的额外预留；
  - `layout.card` / `layout.wide` / `layout.flow` / `layout.term` /
    `layout.footer` / `layout.header` / `layout.title` / `layout.divider` / `layout.info`：
    各组件的内边距、间距、圆角与偏移（`layout.info` 为信息图专用）；
  - `layout.gap`：主文档 `#deepin-gap("…")` 使用的块间距档位。
  不要在主文档里另设 `v(…)` / `inset` / `margin`。
- **版式预算**：`lib/layout.typ` 的 `max-title-lines` / `max-subtitle-lines`。

## 说明

本框架为演示用途；海报中的设备、内核版本、性能等数据以
[deepin-ports SIG](https://deepin-community.github.io/sig-deepin-ports/) 公开信息为参考，
请在使用前核对更新。
