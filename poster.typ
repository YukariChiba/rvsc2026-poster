// ─────────────────────────────────────────────────────────────────────────────
//  deepin · RISC-V 2026 中国峰会海报（中文）
//
//  本文件只放「内容」：内容配置 + 各板块内容，所有版式组件均来自 lib/。
//  字体与字号统一由 lib/fonts.typ（字号档位）与 lib/typography.typ（层级映射）
//  规定，本文件不得自行指定 font / size；页面 / 卡片 / 页脚边距与各类间距统一
//  由 lib/layout.typ 规定，本文件不得自行写 v(…)、inset: … 等距离；需要间距请用
//  #deepin-gap(…)。
//  正文以「信息图」取代密集表格与分点罗列（见 lib/poster/diagrams.typ 与 blocks.typ）。
//  数据来源：deepin-ports SIG 设备支持矩阵 / 周报 / 安装文档、RISC-V Meetup 与
//  武汉 Linux 用户组演讲材料（references/），deepin 官方新闻稿及 RVA23 仓库 RFC #18，
//  并核对公开报道。
//  基于 isc-hei-typst-templates 移植并修改而来。
// ─────────────────────────────────────────────────────────────────────────────

#import "lib/poster.typ": (
  deepin-card, deepin-compare, deepin-figures, deepin-gap, deepin-pipeline, deepin-poster, deepin-stack, deepin-subhead,
  deepin-tiles, deepin-timeline, deepin-wide,
)

// ─────────────────────────────────────────────────────────────────────────────
// 内容配置：本海报专属的数据（替换主题时只改这里）
// ─────────────────────────────────────────────────────────────────────────────

// 选择版式："portrait" 或 "landscape"
#let poster-orientation = "portrait"

// 纸张尺寸：91cm × 122cm（竖版）。Typst 无该精确尺寸，采用等价的建筑纸
// Arch E（36 in × 48 in = 91.44cm × 121.92cm）。也可改为 "a1" 等预定义纸张。
#let poster-paper = "arch-e"

// 项目里程碑（路线图数据）
#let milestones = (
  ("201x–2022", "RISC-V 分支维护与移植"),
  ("2023.10", "更名 ports / 23 主线支持 RISC-V"),
  ("2024.11", "应用商店开始支持 RISC-V"),
  ("2025", "deepin 25 RISC-V 发布预览"),
  ("2026.01", "Next / RVA23 仓库建立"),
  ("2026.08", "本地 AI 适配 / RVA23 镜像发布"),
)

// 署名行：行数与每行要素均由此处决定，形如 (角色, 姓名, 联系方式?)。
#let poster-authors = (
  ("作者", "杨畅", "yangchang@deepin.org"),
  ("所属团队", "deepin-ports SIG", "sig-deepin-ports"),
  ("分论坛", "软件生态"),
  ("社区", "deepin 社区", "deepin.org"),
)

// ─────────────────────────────────────────────────────────────────────────────

#show: deepin-poster.with(
  title: [deepin-ports 在 RISC-V 上的实践与进展],
  subtitle: [多架构适配、持续构建与本地 AI 的 RISC-V 桌面实践],
  overview: deepin-wide(title: "项目概览", subtitle: "deepin-ports SIG 的使命与发展历程", icon: "rectangle-stack")[
    // placard 会把标题区内容居中，故概览正文需显式左对齐。
    #align(left)[
      deepin-ports 是 deepin 社区的特别兴趣小组（SIG），负责 deepin 操作系统在 RISC-V 等架构上的移植、适配与维护。其前身为 2022 年 2 月成立的 deepin-riscv SIG；2023 年 10 月，
      为同时推进 RISC-V 进入 deepin 主线，更名为 deepin-ports SIG。工作范围覆盖软件包
      维护、系统与镜像构建、内核与引导适配、图形驱动适配，以及面向开发者的测试与文档建设。

      #deepin-gap("block")
      #deepin-timeline(milestones, place: "split")
    ]
  ],
  authors: poster-authors,
  poster-id: "海报编号 H10",
  year: "2026",
  school: "deepin 社区",
  programme: "deepin-ports SIG",
  direction: "软件生态",
  summit: [RISC-V 2026\ 中国峰会],
  qr-url: "https://github.com/deepin-community/sig-deepin-ports",
  orientation: poster-orientation,
  paper: poster-paper,
  num-columns: 2,
)

#deepin-card(title: "RISC-V 支持矩阵", subtitle: "10+ SoC 支持 / 30+ 设备支持", icon: "cpu-chip")[
  已适配的 RISC-V 平台涵盖单板计算机、桌面终端、服务器与虚拟化环境；镜像随附 ports 附加仓库，
  包含适配后的内核、驱动与固件，可通过安装器或直接刷写部署。

  #deepin-gap("block")
  #deepin-tiles(
    (
      (
        icon: "cpu-chip",
        title: "StarFive JH7110",
        desc: "VF2 / MilkV Mars / DC ROMA",
      ),
      (
        icon: "cpu-chip",
        title: "ESWIN EIC7700",
        desc: "Premier P550 / Megrez / Star Pro 64 / SBC",
      ),
      (
        icon: "cpu-chip",
        title: "SOPHON SG204X",
        desc: "SG2042 / SG2044 EVB / MilkV Pioneer",
        tag: (solid: true, label: "主线 ISO"),
      ),
      (
        icon: "cpu-chip",
        title: "T-Head TH1520",
        desc: "XuanTie C910 / Light-A / LicheePi 4A / RuyiBook",
      ),
      (
        icon: "cpu-chip",
        title: "SpacemiT K1 (X60)",
        desc: "MUSE Box/Book/Pi / DC ROMA 2 / LicheePi 3A",
      ),
      (
        icon: "sparkles",
        title: "SpacemiT K3",
        desc: "K3 Pico-ITX",
        highlight: true,
        tag: (solid: true, label: "RVA23"),
      ),
      (
        icon: "server-stack",
        title: "UltraRISC DP1000",
        desc: "A1000 EVB / MilkV Titan",
        tag: (solid: true, label: "主线 ISO"),
      ),
      (
        icon: "command-line",
        title: "QEMU",
        desc: "QEMU 虚拟机",
        tag: (solid: true, label: "主线 ISO"),
      ),
    ),
    columns: 2,
  )
]

#deepin-card(title: "流水线式持续构建与交付", subtitle: "自动化、程序化、可复现的流程", icon: "arrow-path")[
  deepin-ports-kernel 与 deepin-ports-image 提供自动化定时工作流：定期拉取上游内核与驱动源码，
  验证并应用下游补丁，完成软件包构建与镜像打包，随后发布到镜像列表与附加仓库。构建过程模板化、
  产物可复现，并随上游更新持续交付。
  #deepin-gap("block")
  #deepin-pipeline((
    ("上游 / 源码", "内核 · 驱动 · 软件包", "cloud-arrow-down"),
    ("定时构建", "Workflow / 构建系统", "cog-6-tooth"),
    ("镜像打包", "deepin-ports-image", "cube"),
    ("发布与更新", "镜像 + 仓库", "arrow-path"),
  ))
]

#deepin-card(title: "RVA23 与 Next 仓库建设", subtitle: "四架构通用、面向未来", icon: "circle-stack")[
  deepin 25 主线基于 RVA20 基线，核心组件（GCC、glibc 等）版本被生态依赖锁定，
  缺少 RVA23 相关优化，也难以适配新的第三方应用。\
  Next 仓库是基于 deepin 25 之上的附加仓库，面向四大主流架构构建，其中 riscv64 默认启用
  RVA23 全局优化，并回合基础库的相关优化。该仓库同时作为下一代 deepin 大版本的技术验证，
  维护原则：尽量减少下游补丁、跟随上游版本。

  #deepin-gap("block")
  #deepin-compare(
    (
      title: "RVA20 · 本地主线",
      items: (
        ("GCC", "12"),
        ("LLVM", "16"),
        ("glibc", "2.38"),
        ("binutils", "2.41"),
        ("OpenSSL", "3.2"),
        ("mesa", "24"),
        ("linux", "6.6 / 6.12"),
      ),
    ),
    (
      title: "RVA23 · Next 仓库",
      items: (
        ("GCC", "15 / 16"),
        ("LLVM", "21 / 22"),
        ("glibc", "2.42"),
        ("binutils", "2.46"),
        ("OpenSSL", "3.5"),
        ("mesa", "26"),
        ("linux", "6.18 (+7.x)"),
      ),
    ),
    item-columns: 2,
  )
]

#deepin-card(title: "本地 AI：小U同学", subtitle: "打通本地算力到本地 Agent 的全链路", icon: "sparkles")[
  结合 Next 仓库提供的 RVA23 工具链与 SpacemiT 矩阵运算扩展（IME），deepin 在 RISC-V 上打通了
  从工具链、算子库到桌面应用的本地推理链路。\
  deepin-modelhub 作为本地运行时，针对 riscv64 根据当前芯片能力选择最优算子实现。\
  llama.cpp / GGML 在 Next 仓库按全部变体构建，支持 RVV 与 K1/K3 矩阵扩展。\
  用户既可在「小U同学」中下载运行本地模型，也可自行安装 llama.cpp、加载自定义模型。
  #deepin-gap("block")
  #deepin-pipeline(
    (
      ("SpacemiT K3", "RVA23 + AI 核 + 矩阵扩展", "cpu-chip"),
      ("llama.cpp / GGML", "RVV + 矩阵扩展支持", "bolt"),
      ("modelhub", "按芯片能力自动选择算子", "circle-stack"),
      ("小U同学", "本地 AI Agent", "sparkles"),
    ),
  )
]

#deepin-card()[
  #deepin-figures((
    (path: "assets/shot-k3-system.jpg", caption: "deepin 25 运行于 SpacemiT K3（riscv64）"),
    (path: "assets/shot-k3-ai.jpg", caption: "小U同学在 8 个 A100 核上运行本地模型"),
  ))
]

#deepin-card(title: "良好维护的附加仓库", subtitle: "最小化原则、良好维护", icon: "cube")[
  #deepin-tiles(
    (
      (icon: "cog-8-tooth", title: "next", desc: "deepin Next 仓库", highlight: true),
      (icon: "square-3-stack-3d", title: "ports-profiles", desc: "设备配置，设备特定包的依赖关系"),
      (icon: "paint-brush", title: "ports-imggpu", desc: "Imagination GPU 驱动与固件"),
      (icon: "cpu-chip", title: "ports-kernel", desc: "厂商定制内核包"),
      (icon: "wrench-screwdriver", title: "ports-board-*", desc: "设备特定驱动与 patch"),
      (icon: "squares-2x2", title: "ports-apps", desc: "electron / chromium 等额外应用"),
    ),
    columns: 3,
  )

  #deepin-gap("block")
  随着 deepin 主线已支持 RISC-V，附加仓库只保留主线难以承接的软件包，例如需要大版本升级的基础库、
  闭源驱动与固件、厂商定制内核，以及临时性的紧急修复。维护原则是尽量减小包数量、持续将其主线化，并保证闭源组件可控、可打包。
]

#deepin-card(title: "内核与镜像维护策略", subtitle: "双线并行、周期可控、管理有序", icon: "shield-check")[
  内核部分：跟随上游或厂商 BSP 的仅追加下游补丁与配置；
  deepin 主线接受厂商 PR / patch 并在生命周期内持续维护。两者的交付方式、
  交付位置与维护责任各不相同。

  #deepin-gap("block")
  #deepin-compare(
    (
      title: "上游 / 厂商内核",
      items: (
        ("内核来源", "厂商 BSP 或上游高版本"),
        ("patch 策略", "仅追加下游 patch 和 config"),
        ("交付", "进 deepin-ports 内核仓库"),
        ("维护", "deepin-ports SIG"),
      ),
    ),
    (
      title: "deepin 主线内核",
      items: (
        ("内核来源", "上游 6.6 / 6.18 等 LTS 版本"),
        ("patch 策略", "接受厂商 PR / patch"),
        ("交付", "进 deepin 主仓库"),
        ("维护", "deepin 社区内核组"),
      ),
    ),
  )

  #deepin-gap("block")
  大版本镜像跟随主线发布，内核更新则视上游变更与修复情况推送，保证及时与可控。
  
  #deepin-gap("block")
  #deepin-tiles(
    (
      (
        icon: "arrow-path",
        title: "镜像更新策略",
        desc: "大版本镜像跟随主线发布，间隔不晚于 1 个月；小版本与日常更新通过仓库在线升级，无需重新刷写",
      ),
      (icon: "bolt", title: "内核更新策略", desc: "内核大版本更新在收到上游变更后尽快构建并推送仓库；小版本更新在包含重要修复或较大改动时推送"),
    ),
    columns: 2,
  )
]

#deepin-card(title: "社区协作与人才培养", subtitle: "建设更好的社区环境", icon: "users")[
  // ── 一、甲辰计划 ───────────────────────────────────────────────────────────
  #deepin-subhead("甲辰计划", icon: "gift", logo: "assets/plan-jiachen.png")
  甲辰计划由 PLCT 实验室发起，与 deepin 社区联合培养 RISC-V 操作系统开发方向的实习生。工作内容包括：验证 deepin RISC-V 现状，巩固与扩展
  自动化构建和测试环境，打包与修包以保证常用软件可用，适配主流 RISC-V 设备，并参与高校联络与技术沙龙组织。

  #deepin-gap("section")
  // ── 二、开源之夏 ───────────────────────────────────────────────────────────
  #deepin-subhead("开源之夏 OSPP", icon: "academic-cap", logo: "assets/plan-ospp.png")
  开源之夏（OSPP）由中国科学院软件研究所「开源软件供应链点亮计划」发起，是面向高校学生的
  暑期开源活动。deepin-ports SIG 在 2025 / 2026 年度均有参与并设置课题，指导学生在真实项目中
  从上游源码、打包构建到镜像交付，完整理解 RISC-V 的适配链路。

  #deepin-gap("section")
  // ── 三、开发板漂流计划 ─────────────────────────────────────────────────────
  #deepin-subhead("开发板漂流计划", icon: "rocket-launch", logo: "lib/assets/deepin_mark.svg")
  为解决 deepin-ports 镜像与设备组合繁多、测试难以充分覆盖的问题，社区发起「开发板漂流计划」：开发者申请借用开发板用于项目开发，并以测试报告、教程或代码贡献等
  公开产出延长使用期限。该计划与甲辰计划的开发板漂流互为平行，
  覆盖多架构的开发板与整机。
]
