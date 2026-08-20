# 声屿（SoundIsle）------AI 全自动开发总任务书 / MASTER_PLAN

**规范版本：26.0**\
**状态：ARCHITECTURE-CHALLENGE CONVERGED（累计280轮，完成反架构/反过度设计/最小复杂度攻击）**\
**最后审查：产品 / HarmonyOS / ArkTS / 音频 / API / QA / 安全 / DevOps / 普通用户 / 重度用户 / 发烧友 / 多模型风格红队联合审查**

# 声屿（SoundIsle）GitHub 仓库执行信息

-   中文名：**声屿**
-   英文名：**SoundIsle**
-   GitHub 仓库：`xyz9810010/SoundIsle`
-   仓库地址：`https://github.com/xyz9810010/SoundIsle`
-   默认开发分支：`main`
-   开源许可证：**Apache License 2.0**
-   产品定位：**为 HarmonyOS 打造的原生私人音乐播放器**
-   核心质量基准：正式版核心 NAS
    音乐体验不得低于音流（StreamMusic），并重点强化
    OpenSubsonic、HarmonyOS 原生体验、多线路、离线和多服务器。

## AI 接手仓库后的第一条命令原则

本文件是整个项目的最高级开发任务书。AI
获得仓库工作区后，不要只阅读本文件然后输出计划，必须立即开始执行。

### 文档优先级

实现时若文档发生冲突，按以下顺序裁决：

```text
1. 用户最新明确要求
2. 安全 / 数据完整性 / HarmonyOS 当前真实平台约束
3. MASTER_PLAN.md
4. ADR 中已批准且仍有效的决策
5. CURRENT_MILESTONE.md
6. ACCEPTANCE_CRITERIA.md
7. ARCHITECTURE.md / AUDIO_ARCHITECTURE.md / API_OPEN_SUBSONIC.md
8. DATA_MODEL.md / DATABASE_SCHEMA.md / ERROR_MODEL.md / UI_SPEC.md
9. TASKS.md
10. AI 自己的偏好
```

任何低优先级文件不得悄悄推翻高优先级规范。发现冲突时，先记录到 ADR 或 PROJECT_STATUS，再修正文档。

首次接手时必须按顺序：

1.  读取 `MASTER_PLAN.md` 全文。
2.  检查仓库文件树和 Git 状态。
3.  读取现有
    `README.md`、`LICENSE`、`ARCHITECTURE.md`、`ROADMAP.md`、`PROJECT_STATUS.md`（存在则读取）。
4.  检查当前 HarmonyOS 工程、SDK、构建配置和依赖。
5.  运行当前可执行的构建和测试，建立真实基线。
6.  不存在工程时，按照本任务书创建正式 HarmonyOS ArkTS/ArkUI 工程。
7.  创建或维护
    `ARCHITECTURE.md`、`ROADMAP.md`、`PROJECT_STATUS.md`、`docs/server-capabilities.md`
    和 `docs/adr/`。
8.  从当前最早未完成 Phase 开始实施。
9.  每完成一个独立功能：检查代码 → 构建 → 测试 → 修复 → 更新状态文档 →
    Git commit → 自动进入下一项。
10. 除非遇到必须由用户提供的真实账号、证书、设备操作或不可推断的产品决策，否则不得停下来要求用户继续下指令。

## GitHub / Git 执行规则

-   `main`
    必须保持可构建/可恢复。小型原子修改可直接提交；涉及播放器、数据库迁移、认证、下载、Provider
    大改等高风险任务，优先创建短生命周期功能分支并通过自检/PR 后合并。
-   禁止 force push 覆盖用户历史。
-   禁止删除不理解的用户代码。
-   修改前先检查 `git status` 和现有变更，不得覆盖用户未提交工作。
-   每个 commit 必须单一目的、可构建、描述清晰。
-   推荐 Conventional
    Commits：`feat:`、`fix:`、`refactor:`、`test:`、`docs:`、`build:`、`chore:`。
-   不提交密码、Token、API Key、私钥、签名文件或真实服务器凭证。
-   创建 `.gitignore` 并覆盖 HarmonyOS/DevEco
    Studio、本地缓存、构建产物、密钥和系统临时文件。
-   每个 Phase 完成后在 `PROJECT_STATUS.md`
    写明验收结果、测试结果和仍存在的限制。
-   未通过验收的功能不得标记为完成。
-   如果 GitHub Actions 具备可用的 HarmonyOS/DevEco
    构建环境，则执行完整构建；否则 CI
    至少执行仓库可运行的静态检查、单元测试、文档/配置校验，并把
    HarmonyOS 真机构建作为独立 Release Gate，禁止伪造 CI 构建成功。
-   Release 前生成 changelog，并使用语义化版本号。

## Apache-2.0 许可证规则

本项目许可证固定为 **Apache License 2.0**。

AI 必须：

-   保留仓库根目录 `LICENSE`。
-   不得擅自切换 GPL、AGPL 或其他许可证。
-   引入依赖前检查许可证兼容性。
-   对需要 NOTICE/署名的第三方依赖正确保留声明。
-   在 `THIRD_PARTY_NOTICES.md` 中维护需要披露的第三方组件。
-   不复制音流（StreamMusic）的闭源代码、资源、图标或其他受版权保护实现；只允许把其公开功能表现作为产品对标参考。
-   UI 和品牌必须使用声屿自己的设计和资产。

------------------------------------------------------------------------

## 0. 你的身份

你现在是本项目的：

-   产品经理
-   HarmonyOS 架构师
-   ArkTS 开发工程师
-   UI/UX 工程师
-   音频播放工程师
-   API 集成工程师
-   数据库工程师
-   测试工程师
-   性能优化工程师
-   Bug 修复工程师

你的任务不是提供示例代码，而是**持续完成整个可运行项目**。

除非遇到无法通过代码、官方文档、现有项目文件或测试自行判断的信息，否则不要停止工作等待用户逐步确认。

------------------------------------------------------------------------

## 1. 项目目标

### 1.1 项目名称

-   中文名：**声屿**
-   英文名：**SoundIsle**
-   项目仓库名：`SoundIsle`
-   产品定位：**声屿（SoundIsle）------为 HarmonyOS
    打造的原生私人音乐播放器。**

后续代码、项目目录、README、开发文档、UI、版本说明等统一使用 **声屿 /
SoundIsle**，不得继续使用 HarmonyMusic 作为正式项目名称。

开发一款 HarmonyOS 原生私人音乐播放器。

### 1.2 成功标准

"自动完成"不等于一次生成全部代码，也不等于未经验证就宣布成功。

SoundIsle 采用 **证据驱动完成（Evidence-Based Completion）**：

``` text
实现
→ 编译
→ 自动测试
→ 可执行场景验证
→ 真机验证（需要时）
→ 记录证据
→ 才能 DONE
```

AI 应最大化自主执行，但任何依赖真实 HarmonyOS
设备、真实服务器版本或发布签名的事项，在未实际验证前必须明确标记为待验证。

项目定位：

> HarmonyOS 原生自托管音乐客户端。

核心使用场景：

用户已经部署自己的音乐服务器，例如：

-   Navidrome
-   OpenSubsonic / Subsonic Server
-   Jellyfin
-   Emby
-   Synology AudioStation
-   Plex

用户在 HarmonyOS 手机、平板等设备安装本 App
后，可以连接自己的音乐服务器并完成完整的音乐管理和播放。

最终正式版本的核心体验不得明显低于音流 StreamMusic。

但本项目不是音流的复制品。

必须充分利用 HarmonyOS 原生能力，并在以下方面争取超过普通跨平台客户端：

-   HarmonyOS 原生 UI
-   后台播放
-   系统媒体控制
-   多设备体验
-   NAS 内外网切换
-   OpenSubsonic 深度支持
-   多服务器
-   下载与离线
-   歌词
-   播放稳定性

------------------------------------------------------------------------

## 1A. 产品经理最终定义

### 1A.1 SoundIsle 到底是什么

**声屿（SoundIsle）首先是一款 HarmonyOS 原生音乐播放器客户端。**

它不是：

-   音乐服务器
-   Navidrome 替代品
-   音乐文件管理服务器
-   全量音乐库同步工具
-   云端账号平台

它的职责是：

``` text
连接用户已有音乐服务
→ 通过 API 浏览音乐
→ 获取播放源
→ 稳定播放
→ 提供优秀的 HarmonyOS 本地播放器体验
```

### 1A.2 数据所有权

必须始终遵守：

> **服务器负责"有什么音乐"，SoundIsle 本地负责"用户怎么听这些音乐"。**

#### Remote / Server Authority

以下数据以远程音乐服务 API 为权威来源：

``` text
歌曲
专辑
艺术家
音乐类型
服务器歌单
服务器收藏/评分（如果用户选择同步）
封面原始数据
服务器歌词
媒体播放源
服务器转码能力
服务器音乐库结构
```

SoundIsle 对这些内容采用：

``` text
API First
+
按需获取
+
必要缓存
```

默认禁止为了浏览音乐而强制全量同步整个服务器音乐库。

#### Local / Client Authority

以下数据默认保存在客户端本地：

``` text
服务器配置
客户端设置
播放队列
当前播放状态
断点播放位置
播放历史
搜索历史
本地收藏
本地歌单
下载记录
下载文件
歌词显示设置
歌词偏移
线路偏好
音质偏好
缓存索引
客户端诊断设置
```

密码、Token、API Key
等敏感凭证必须进入系统安全存储，不得作为普通业务字段明文保存。

### 1A.3 可选服务器写回

SoundIsle 可以调用服务器 API 写回：

``` text
Star / Favorite
Rating
Server Playlist
Scrobble
Play Queue（服务器支持且用户需要时）
```

但这些属于 **Server Integration**，不是 SoundIsle 本地状态成立的前提。

对于可同步功能，产品层必须明确区分：

``` text
本地收藏
服务器收藏

本地歌单
服务器歌单
```

不得让用户误以为本地数据已经上传服务器。

### 1A.4 API 驱动原则

音乐库默认数据流：

``` text
UI
↓
Repository
↓
Provider
↓
Remote API
↓
统一领域模型
↓
UI
```

缓存仅用于：

``` text
提高启动速度
弱网体验
减少重复请求
离线展示必要信息
```

缓存不得成为远程音乐库的第二权威数据库。

### 1A.5 播放源不得永久绑定 Song

`Song` 不得长期保存一个假定永久有效的最终播放 URL。

播放必须：

``` text
Song
↓
PlaybackResolver
↓
根据当前服务器 / 线路 / 音质 / 转码策略
↓
实时生成 AudioSource
↓
Player
```

`AudioSource` 可包含：

``` text
url
headers
codec
bitrate
transcodeMode
routeId
expiresAt
```

------------------------------------------------------------------------

## 1B. 本地客户端功能基线

### 必须本地完成（P0）

1.  **服务器管理**
    -   添加/编辑/删除服务器
    -   多服务器配置
    -   内网/公网/备用线路
    -   测试连接
    -   安全凭证引用
2.  **播放器状态**
    -   当前歌曲
    -   当前进度
    -   播放队列
    -   队列位置
    -   播放模式
    -   App 重启恢复
3.  **本地播放历史**
    -   最近播放
    -   播放次数
    -   最后播放时间
    -   实际播放时长
    -   继续播放
4.  **本地设置**
    -   外观
    -   播放
    -   音质
    -   歌词
    -   网络
    -   下载
    -   缓存
5.  **下载与离线**
    -   下载任务
    -   下载文件
    -   失败重试
    -   断点续传（服务器支持时）
    -   离线播放
    -   下载与缓存严格隔离
6.  **缓存**
    -   封面缓存
    -   歌词缓存
    -   Metadata 缓存
    -   临时音频缓存
    -   缓存容量管理

### 推荐本地完成（P1）

``` text
本地收藏
本地歌单
搜索历史
本地统计
歌词偏移
最近服务器/线路状态
```

### 不做成客户端核心数据库

默认不长期全量镜像：

``` text
完整歌曲库
完整专辑库
完整艺术家库
服务器所有 Metadata
永久播放 URL
服务器数据库副本
```

------------------------------------------------------------------------

## 1C. 客户端架构基线

正式架构固定为：

``` text
Presentation
├── Pages
├── Components
├── ViewModels
└── UI State

Domain
├── UseCases
├── Models
├── Repository Contracts
└── Player Contracts

Data
├── Repositories
├── Remote DataSources
├── Local DataSources
└── Cache

Providers
├── OpenSubsonic
├── Jellyfin
├── Emby
├── AudioStation
└── Plex

Playback
├── PlayerService
├── PlayerController
├── PlayerStateStore
├── QueueManager
├── PlaybackResolver
└── System Media Integration

Infrastructure
├── NetworkClient
├── Database
├── SecureStorage
├── TaskScheduler
├── Logger
└── FeatureFlags
```

### 模块依赖硬规则

``` text
UI → Domain
Domain → Contracts only
Data → Domain Contracts
Provider → Data/Domain Contracts
Playback → Player Contracts + PlaybackResolver
Infrastructure → 被上层通过接口使用
```

禁止：

``` text
UI 直接调用 Provider
UI 直接操作数据库
UI 直接持有 AVPlayer
Player 直接依赖具体 NavidromeProvider
Provider 反向依赖 UI
数据库反向依赖 Repository
```

### PlayerStateStore

全 App 必须只有一个播放器真实状态源。

至少包含：

``` text
lifecycleState
currentSong
queue
currentIndex
position
duration
buffering
playMode
audioSource
route
error
```

Mini Player、完整播放页、AVSession/系统媒体控制都从同一状态源派生。

### 播放器状态机

至少明确：

``` text
Idle
Preparing
Ready
Playing
Paused
Buffering
Seeking
Completed
Error
Released
```

页面生命周期不得决定播放器生命周期：

``` text
PlayerPage destroyed
≠
PlayerService destroyed
```

### 本地优先显示策略

对于已经有缓存的浏览页面：

``` text
读取可用缓存
→ 快速显示
→ 后台请求服务器
→ 更新 UI
```

但必须保证远程 API 仍然是服务器音乐数据的权威来源。

------------------------------------------------------------------------

## 1D. 产品优先级与范围控制

### P0：声屿能成为真正播放器的最低条件

``` text
Navidrome / OpenSubsonic 登录
音乐库浏览
歌曲/专辑/艺术家
搜索
封面
稳定播放
播放队列
播放模式
进度恢复
Mini Player
完整播放页
后台播放
AVSession / 系统媒体控制
歌词
下载
离线播放
服务器线路切换
安全凭证
本地设置
本地播放历史
错误恢复
```

### P1：正式 V1 产品能力

``` text
本地收藏/歌单
服务器收藏/歌单同步
评分
Scrobble
ReplayGain
可验证的 Gapless 最佳实现
Jellyfin
Emby
AudioStation
Plex
多服务器基础体验
```

### P2：增强能力

``` text
跨服务器统一搜索
跨服务器歌曲去重
自动选源
WebDAV
逐字歌词
复杂动态主题
更多 HarmonyOS 分布式能力
```

**P0 未稳定前，AI 不得主动把 P2 插入关键路径。**

------------------------------------------------------------------------

## 1E. 项目里程碑

### M0 --- 工程基线

出口条件：

``` text
工程可构建
基础导航可运行
日志/错误/网络/数据库/安全存储骨架完成
核心文档建立
```

### M1 --- Navidrome 连接成功

出口条件：

``` text
真实 Navidrome 登录成功
Capability 探测完成
服务器配置安全保存
能获取真实音乐库数据
```

### M2 --- 第一条完整播放链路

出口条件：

``` text
浏览音乐
→ 选择歌曲
→ 获取 AudioSource
→ AVPlayer 播放
→ 暂停/Seek/上下首
→ 队列工作
```

这是项目第一个关键可用版本。

### M3 --- 日用播放器

出口条件：

``` text
后台播放
系统媒体控制
状态恢复
歌词
搜索
播放历史
弱网错误处理
基础缓存
```

达到"可以每天拿来听歌"的水平。

### M4 --- 离线与高级播放

出口条件：

``` text
下载
离线
转码
线路切换
ReplayGain
Gapless/降级方案
```

### M5 --- 多服务端

出口条件：

``` text
Jellyfin
Emby
AudioStation
Plex
```

每个 Provider 必须分别验收，不能因为代码存在就算兼容。

### M6 --- V1 RC

出口条件：

``` text
P0/P1 计划项完成
P0 Bug = 0
P1 Bug = 0
真机关键矩阵完成
升级测试完成
安全/隐私/许可证检查完成
Release 构建可复现
```

------------------------------------------------------------------------

## 1F. 当前关键路径

SoundIsle 第一关键路径固定为：

``` text
HarmonyOS 工程
→ OpenSubsonic Provider
→ Navidrome 真服务器
→ 统一 Song/Album/Artist
→ PlaybackResolver
→ PlayerService
→ PlayerStateStore
→ AVPlayer
→ 后台播放
→ AVSession
→ 真机稳定性
```

任何不直接服务这条链路的 P1/P2 工作，都不得阻塞它。

------------------------------------------------------------------------

## 1G. Scope Freeze

进入一个 Milestone 后：

-   当前 Milestone 范围冻结。
-   新想法进入 Backlog。
-   只有 P0/P1 缺陷、安全问题、数据丢失风险可以插队。
-   AI 不得因为发现"可以顺便做"而扩展范围。
-   进入下一 Milestone 前必须完成当前出口检查。

------------------------------------------------------------------------

## 1H. Definition of Ready

任务进入开发前至少满足：

``` text
需求目的明确
输入/输出明确
所属模块明确
依赖明确
API 来源明确（涉及外部 API 时）
验收条件明确
测试方式明确
```

不满足时先补任务定义，不允许靠猜测写正式实现。

------------------------------------------------------------------------

## 1I. Definition of Done

任务状态统一：

``` text
NOT_STARTED
READY
IN_PROGRESS
IMPLEMENTED
AUTO_TESTED
DEVICE_TEST_REQUIRED
DEVICE_TESTED
BLOCKED
FAILED
DONE
```

`IMPLEMENTED` 绝不等于 `DONE`。

------------------------------------------------------------------------

## 1J. 项目管理文件

仓库必须维护：

``` text
MASTER_PLAN.md
PRODUCT_REQUIREMENTS.md
ARCHITECTURE.md
ROADMAP.md
CURRENT_MILESTONE.md
PROJECT_STATUS.md
TASKS.md
RISK_REGISTER.md
UI_SPEC.md
BUILDING.md
CHANGELOG.md
PRIVACY.md
THIRD_PARTY_NOTICES.md
docs/SECURITY.md
docs/test-matrix.md
docs/requirements-traceability.md
docs/server-capabilities.md
docs/adr/
```

### AI 日常读取顺序

不要每次把 3000+ 行 MASTER_PLAN 当任务列表。

日常执行优先：

``` text
CURRENT_MILESTONE.md
→ PROJECT_STATUS.md
→ TASKS.md
→ ARCHITECTURE.md
→ 需要时再查 MASTER_PLAN.md
```

------------------------------------------------------------------------

## 1K. 风险管理

创建 `RISK_REGISTER.md`。

至少跟踪：

``` text
HarmonyOS 后台播放限制
AVSession 行为差异
Gapless 平台能力
音频格式兼容性
服务器转码差异
Navidrome/OpenSubsonic 版本差异
Jellyfin/Emby/Plex API 差异
AudioStation DSM 版本差异
真机测试资源
应用签名/发布
数据库升级
用户下载数据完整性
```

每个风险记录：

``` text
概率
影响
负责人
缓解方案
触发条件
当前状态
```

------------------------------------------------------------------------

## 1L. 功能降级/止损规则

项目不得无限消耗时间追求平台暂时做不到的效果。

例如：

-   Gapless 如果公开 API 无法做到
    sample-accurate，采用最佳实现并明确限制。
-   某 Provider 因缺真实测试环境，只能标记 `IMPLEMENTED_UNVERIFIED`。
-   某高级功能阻塞 P0 时移入后续 Milestone。
-   任何"完美"目标不得压过稳定播放、数据安全和后台可靠性。

------------------------------------------------------------------------

## 1M. 用户数据保护承诺

从首个公开 Beta 开始：

> **升级导致服务器配置、下载记录、本地歌单、本地收藏、播放历史或用户设置无故丢失，按
> P0/P1 严重问题处理。**

缓存可以重建；用户主动创建的数据不能被当成缓存清理。

------------------------------------------------------------------------

## 1N. 音流对标方式

建立：

``` text
COMPETITOR_BENCHMARK.md
```

逐项记录：

``` text
功能
音流是否具备
SoundIsle 是否具备
SoundIsle 状态
测试证据
差距
是否计划超越
```

"至少不比音流差"必须通过对标表验证，不能只作为宣传语。

------------------------------------------------------------------------

## 1O. 高级 UI/UX 产品设计基线

### 1O.1 设计目标

SoundIsle 的 UI 不复制音流。音流用于功能完整度对标；SoundIsle
使用自己的品牌、信息架构和 HarmonyOS 原生交互。

设计目标按优先级：

``` text
一眼知道当前在听什么
→ 两步以内找到并播放音乐
→ 网络慢/断网时仍然可理解、可操作
→ 常用操作单手可达
→ 技术配置只在需要时出现
→ 手机 / 平板 / 折叠屏自然适配
```

视觉关键词：

``` text
安静
沉浸
清晰
音乐感
轻量
原生
```

禁止为了"高级感"牺牲可读性、点击区域和操作效率。

### 1O.2 一级信息架构

手机端默认四个一级入口：

``` text
首页
音乐库
搜索
我的
```

全局 Mini Player 位于底部导航上方；有播放队列时保持可见。

"服务器"不是普通用户每天使用的一级入口，放入"我的 → 音乐服务"。

#### 首页

首页负责"马上开始听"，不负责展示所有功能。

优先内容：

``` text
继续播放
最近播放
最近添加
常听
收藏
随机推荐/随机专辑（服务器支持时）
```

允许用户后续自定义首页模块，但 V1 不把首页做成复杂仪表盘。

#### 音乐库

固定核心分类：

``` text
歌曲
专辑
艺术家
歌单
类型/流派
已下载
```

服务器能力不足时隐藏对应项，不显示不可用的空入口。

#### 搜索

搜索页同时承担：

``` text
服务器音乐搜索
最近搜索
搜索历史清除
按歌曲/专辑/艺术家分类结果
```

多服务器搜索属于后续能力，不阻塞第一版。

#### 我的

包含：

``` text
音乐服务
下载管理
本地收藏/歌单
播放历史
设置
关于 SoundIsle
```

### 1O.3 首次启动

首次打开不能先展示复杂设置。

流程：

``` text
欢迎页
↓
添加音乐服务
↓
选择服务类型
↓
填写服务器地址
↓
账号认证
↓
测试连接
↓
能力探测
↓
连接成功
↓
进入首页
```

支持的服务选择页可以展示：

``` text
Navidrome / OpenSubsonic
Jellyfin
Emby
Audio Station
Plex
```

V1 首发若某 Provider
尚未验证，不得伪装成可用入口；可以显示"即将支持"或暂不展示。

Navidrome 作为第一黄金路径，应放在首要位置。

### 1O.4 添加 Navidrome

默认只要求普通用户理解三个字段：

``` text
服务器地址
用户名
密码
```

高级选项折叠：

``` text
自定义名称
内网地址
备用线路
认证方式
转码/音质
TLS 高级设置
```

点击"连接"后必须显示明确阶段：

``` text
正在连接服务器
正在验证账号
正在读取服务器能力
连接成功
```

错误必须转换成人能理解的结果：

``` text
无法访问服务器
账号或密码错误
证书验证失败
请求超时
服务器 API 不兼容
```

每种错误给出下一步操作，不直接把技术异常堆给普通用户。

### 1O.5 首页状态

首页必须支持：

``` text
首次加载
缓存内容 + 后台刷新
正常内容
服务器离线
完全无缓存
部分模块失败
```

服务器暂时不可用但本地有数据时：

``` text
继续显示缓存首页
+
顶部轻量离线提示
+
允许进入下载内容
```

不得因为一个首页模块请求失败导致整页不可用。

### 1O.6 Mini Player

Mini Player 是核心全局组件。

至少展示：

``` text
封面
歌曲名
艺术家
播放/暂停
```

点击主体进入完整播放器。

支持自然手势时可增加：

``` text
左右滑切歌
上滑打开播放页/队列
```

但手势必须有按钮替代方案，不能成为唯一操作路径。

Mini Player、完整播放页和系统媒体控制必须读取同一个 `PlayerStateStore`。

### 1O.7 完整播放页

默认结构：

``` text
顶部：返回 / 播放来源或队列入口
主体：大封面
歌曲名
艺术家
收藏
进度条
时间
上一首 / 播放暂停 / 下一首
播放模式
更多
底部：歌词 / 队列 / 音频信息等入口
```

核心播放按钮优先级最高。

不要在主播放页长期展示：

``` text
服务器 URL
Provider 类型
Codec 技术字段
线路 ID
复杂调试数据
```

这些放入"音频信息/详情"。

### 1O.8 歌词体验

歌词页支持：

``` text
纯文本歌词
LRC 时间轴
当前行高亮
点击歌词跳转
歌词偏移
翻译（存在时）
```

歌词状态：

``` text
加载中
有歌词
无歌词
请求失败
离线缓存歌词
```

无歌词时不要出现空白大屏，应提供明确说明及重新获取入口。

### 1O.9 播放队列

队列必须让用户明确理解"接下来播放什么"。

支持：

``` text
当前歌曲定位
拖动排序
删除单曲
清空队列
播放下一首
添加到队列末尾
```

队列修改立即反馈，并持久化到本地。

### 1O.10 专辑 / 艺术家 / 歌单

专辑页：

``` text
封面
专辑名
艺术家
年份/必要 Metadata
播放
随机播放
歌曲列表
收藏/更多
```

艺术家页：

``` text
艺术家信息
热门/全部歌曲（API 支持时）
专辑
```

歌单页：

``` text
名称
歌曲数量
播放
随机
歌曲列表
本地/服务器来源标识（必要时）
```

本地歌单与服务器歌单在用户执行编辑/同步操作时必须能区分来源。

### 1O.11 下载与离线

下载入口不能隐藏得过深。

歌曲、专辑、歌单可提供下载操作。

下载管理页区分：

``` text
正在下载
等待
已下载
失败
```

必须展示：

``` text
进度
文件大小（可获得时）
音质
失败原因
重试
删除
```

离线时：

``` text
已下载内容正常播放
未下载内容明确显示不可用
```

不得点击后长时间转圈才告诉用户没有网络。

### 1O.12 服务器切换

如果只有一个服务器，不要在首页长期占据显眼空间。

多服务器时，在"我的 → 音乐服务"管理，并允许从必要位置快速切换当前服务。

切换服务器时：

``` text
保留本地用户数据
切换 Remote Context
刷新音乐库 UI
不得误删另一个服务器下载
```

不同服务器的媒体对象必须通过 `MediaKey` 隔离。

### 1O.13 设置页

设置按用户语言组织，而不是按代码模块组织：

``` text
播放
音质
歌词
下载
外观
网络
音乐服务
存储与缓存
隐私与安全
关于
```

危险操作单独分组：

``` text
清除缓存
删除下载
移除服务器
清除本地历史
```

"清除缓存"绝不能删除用户下载、本地歌单、本地收藏和服务器配置。

### 1O.14 设计系统

创建 `UI_SPEC.md` 并定义 Design Tokens：

``` text
Color
Typography
Spacing
Radius
Elevation
Icon Size
Touch Target
Motion
```

页面禁止自行发明颜色和间距。

优先使用 HarmonyOS 系统字体、系统组件行为和动态字体能力。

必须支持：

``` text
浅色
深色
跟随系统
```

品牌强调色可以由 SoundIsle 定义，但必须满足文字/图标可读性。

### 1O.15 可访问性

最低要求：

``` text
重要按钮具有可访问名称
文字支持系统字体缩放
核心操作不能只靠颜色表达
触控区域足够
进度/下载状态有文字或语义
封面加载失败有替代视觉
```

减少动态效果设置开启时，应减少非必要动画。

### 1O.16 响应式布局

手机：

``` text
单栏
底部导航
Mini Player
```

大屏/平板：

``` text
Navigation Rail / 双栏
列表 + 详情
播放器可利用更宽空间
```

折叠屏展开后不得简单把手机页面横向拉宽。

响应式断点必须在 `UI_SPEC.md` 根据 HarmonyOS 实际设备能力定义。

### 1O.17 横屏

横屏播放器优先采用：

``` text
左侧封面
右侧歌曲信息 / 控制 / 歌词
```

而不是把竖屏界面旋转后简单压缩。

### 1O.18 页面状态规范

所有远程数据页面统一支持：

``` text
Loading
Content
Empty
Refreshing
OfflineWithCache
OfflineNoCache
PartialError
FatalError
```

UI 不得直接处理原始 HTTP 错误码。

错误先经过：

``` text
Provider/Network Error
↓
Domain Error
↓
User-facing State
```

### 1O.19 反馈规范

播放、收藏、下载等高频动作：

``` text
立即视觉反馈
→ 后台执行
→ 失败则回滚并解释
```

破坏性操作：

``` text
删除下载
清空队列
移除服务器
清除历史
```

根据后果使用确认或可撤销机制。

禁止每个普通操作都弹确认框。

### 1O.20 动画

动画只服务三个目的：

``` text
说明层级变化
说明播放状态
帮助用户理解操作结果
```

禁止大量无意义弹跳、旋转和持续 GPU 动画。

播放页封面动画、歌词滚动必须以长期播放功耗为约束。

### 1O.21 性能感知设计

首屏体验优先级：

``` text
导航框架立即出现
→ 本地缓存内容
→ 封面渐进加载
→ 后台刷新 Remote Data
```

不得为了等高清封面阻塞文字和列表。

长列表必须考虑虚拟化/懒加载和图片解码压力。

### 1O.22 UI 验收清单

任何核心页面标记 DONE 前至少检查：

``` text
浅色模式
深色模式
无数据
慢网络
断网
API 错误
超长歌曲名
超长艺术家名
无封面
无歌词
大字体
返回导航
Mini Player 共存
```

核心播放器另外检查：

``` text
暂停
Seek
切歌
Buffering
后台返回前台
队列变化
系统媒体控制同步
```

### 1O.23 UI 设计冻结

M1 结束前冻结：

``` text
一级导航
添加服务器流程
首页结构
Mini Player
完整播放页骨架
音乐库结构
```

M2 以后重大导航调整必须记录到 ADR/产品变更，不允许 AI
在开发过程中自行反复重构整体 UI。

### 1O.24 产品文案原则

面向用户优先使用：

``` text
音乐服务
服务器地址
连接
下载
离线
音质
播放队列
```

避免把：

``` text
Provider
Repository
Capability
Endpoint
Transcode API
HTTP 401
```

直接作为普通界面语言。

技术信息只出现在高级设置、诊断或错误详情。

### 1O.25 品牌规则

正式品牌：

``` text
中文：声屿
英文：SoundIsle
```

品牌视觉应围绕"声音 / 岛屿 / 水波 / 音乐空间"的概念独立设计。

不得复制音流、Navidrome、Jellyfin、Plex 等项目的 Logo 或视觉资产作为
SoundIsle 自身品牌。

第三方服务入口如需显示其品牌标识，必须遵守对应品牌/商标使用规则；无法确认授权时优先使用文字和通用服务图标。

## 1P. 资深音乐播放器 / 音频工程审批基线

### 1P.1 音频模块的最高原则

SoundIsle
首先是播放器，因此播放链路的优先级高于推荐、主题、跨服务器去重等增强功能。

任何版本都必须优先保证：

``` text
能播
→ 播得对
→ 控制状态一致
→ 后台稳定
→ 切歌稳定
→ 弱网可恢复
→ 长时间播放稳定
→ 再做高级音效
```

禁止为了 Gapless、Crossfade、可视化等高级功能破坏基础播放稳定性。

### 1P.2 播放引擎抽象

业务层不得直接依赖具体播放器实现。

定义统一：

``` text
PlaybackEngine
```

至少提供：

``` text
prepare
play
pause
stop
seek
setVolume
setSpeed（支持时）
release
getPosition
getDuration
```

以及状态/事件：

``` text
prepared
playing
paused
buffering
seekComplete
completed
error
positionChanged
outputDeviceChanged
interrupt
```

第一实现优先评估 HarmonyOS `AVPlayer` 作为格式化音频播放引擎。

如果未来为了真正的高级无缝播放、DSP 或 PCM 级控制需要
`AudioRenderer/OHAudio`，必须作为独立 Engine/高级播放路径评估，不能让
UI、Provider、QueueManager 感知底层变化。

### 1P.3 播放状态机

`PlayerStateStore` 必须以播放引擎真实事件驱动。

标准状态：

``` text
Idle
ResolvingSource
Preparing
Ready
Playing
Paused
Buffering
Seeking
Completed
Recovering
Error
Released
```

禁止：

``` text
用户点击播放
→ UI 直接假定 Playing
```

正确方式：

``` text
用户意图
→ PlayerController
→ PlaybackEngine
→ 引擎真实状态
→ PlayerStateStore
→ UI / AVSession
```

允许短暂 optimistic UI，但必须由真实状态校正。

### 1P.4 PlaybackResolver

播放前统一经过：

``` text
PlaybackResolver
```

输入：

``` text
MediaKey
当前 Server
当前 Route
网络类型
音质策略
转码策略
设备/引擎能力
```

输出：

``` text
AudioSource {
  uri/url
  headers
  mimeType
  codec
  container
  bitrate
  sampleRate
  bitDepth
  channels
  contentLength
  transcoded
  routeId
  expiresAt
}
```

播放 URL 失效后重新 Resolve，不得把旧 URL 当永久资源。

### 1P.5 原始音质与转码决策

默认策略：

``` text
设备/系统支持原始媒体
AND
用户当前网络策略允许
→ Original

否则
→ 请求服务器转码
```

转码决策至少考虑：

``` text
Wi-Fi / 移动网络
用户最大码率
服务器 Capability
媒体格式
播放器实际支持
线路带宽
用户是否强制 Original
```

禁止仅根据文件扩展名判断"系统一定能播"。

### 1P.6 格式能力探测

项目维护：

``` text
docs/audio-capabilities.md
```

记录经过实际验证的：

``` text
container
codec
sample rate
bit depth
channels
AVPlayer support
tested device/API
fallback
```

目标覆盖：

``` text
MP3
AAC/M4A
FLAC
ALAC
OGG/Vorbis
Opus
WAV/PCM
```

但"文件类型被 HarmonyOS 识别"不等于"当前 AVPlayer +
当前容器/编码组合已经实测可播放"。

未经实际验证的格式必须标记 `UNVERIFIED`。

### 1P.7 音频焦点 / 打断

必须处理系统音频打断提示，包括：

``` text
PAUSE
RESUME
DUCK
UNDUCK
STOP
```

恢复规则必须区分：

``` text
用户主动暂停
系统打断暂停
```

只有因为系统打断而暂停，并且系统允许恢复时，才允许自动恢复。

如果用户已经主动暂停，系统 RESUME 不得擅自播放。

### 1P.8 输出设备变化

监听：

``` text
有线耳机拔出
蓝牙耳机断开
蓝牙设备切换
输出设备变化
```

当输出意外切回扬声器时，默认采用安全策略：

``` text
暂停播放
```

避免用户拔耳机后音乐突然外放。

正常的用户主动设备切换可以继续播放。

### 1P.9 AVSession

AVSession 是 Player 状态的系统投影，不是第二套播放器状态。

数据流固定：

``` text
PlayerStateStore
↓
AVSession Adapter
↓
HarmonyOS 播控中心
```

系统命令：

``` text
AVSession
↓
PlayerController
↓
PlaybackEngine
```

禁止：

``` text
AVSession 自己修改队列
AVSession 自己保存播放进度
UI 和 AVSession 各维护一份播放状态
```

至少同步：

``` text
title
artist
album
cover
duration
position
playback state
loop mode
favorite（适用时）
previous/current/next identity
```

### 1P.10 后台播放

后台播放必须作为 P0 真机能力。

必须按 HarmonyOS 当前规范接入：

``` text
AVSession
+
后台运行权限
+
audioPlayback 后台模式
+
音频长时后台任务
```

开始真正播放时启动必要后台能力；播放完全停止并不再需要保持媒体会话时及时释放。

必须测试：

``` text
Home 键
锁屏
息屏
长时间后台
从系统播控恢复
App UI 被回收后的恢复路径
```

### 1P.11 冷启动与恢复

冷启动分两种：

#### 用户正常打开 SoundIsle

``` text
恢复本地队列/歌曲/位置
→ 默认不擅自发声
→ UI 显示可继续播放状态
```

#### 用户从系统播控中心明确点击播放

``` text
恢复必要播放上下文
→ Resolve AudioSource
→ 恢复播放
```

是否自动恢复到精确位置必须遵循当前媒体可 Seek 能力。

### 1P.12 Seek

Seek 必须处理：

``` text
用户连续拖动
快速多次 Seek
Seek 尚未完成又发起新 Seek
远程媒体 Range 能力
转码流 Seek 能力
```

UI 拖动时显示用户目标位置；引擎确认后再回归真实 Position。

不得让定时 position update 与用户拖动互相抢进度条。

### 1P.13 快速切歌竞态

必须防止：

``` text
A 正在 prepare
用户点 B
用户又点 C
A 回调晚到
→ 错把 A 显示/播放
```

每次播放请求建立：

``` text
playRequestId / generation
```

旧请求回调必须被忽略或取消。

适用于：

``` text
Resolve URL
封面
歌词
Prepare
Metadata
```

### 1P.14 队列语义

QueueManager 是唯一队列权威。

必须定义：

``` text
Play Now
Play Next
Add to Queue
Replace Queue
Remove
Move
Clear
```

随机播放不得简单每次 `random()`。

必须维护：

``` text
shuffle order
play history
current position in shuffle order
```

保证：

``` text
上一首 = 真正上一首
```

### 1P.15 下一首预解析 / 预加载

至少做到：

``` text
提前 Resolve 下一首 AudioSource
提前加载 Metadata/封面
```

是否预缓冲媒体必须根据 HarmonyOS
当前播放能力、网络、流量策略和内存/功耗评估。

移动网络默认不得因为"预加载"产生不可控额外流量。

### 1P.16 播放错误恢复状态机

播放错误进入：

``` text
Recovering
```

按错误类型有限恢复：

``` text
播放 URL 失效
→ Refresh Source

当前线路失败
→ Switch Route

原始格式不支持
→ Try Transcode

短暂网络失败
→ bounded retry

认证失效
→ refresh/re-auth if possible

仍失败
→ Fatal PlaybackError
```

必须设置：

``` text
最大尝试次数
退避
同一错误去重
```

禁止无限自动循环。

### 1P.17 网络切换

处理：

``` text
Wi-Fi → 蜂窝
蜂窝 → Wi-Fi
断网
重新联网
```

如果当前播放器已有足够 Buffer，不要为了网络事件立刻强制中断。

真正需要重新建立媒体请求时：

``` text
记录 position
→ 选择新 route/quality
→ Resolve 新 AudioSource
→ prepare
→ seek 回原位置
→ 按原播放意图恢复
```

允许存在少量恢复误差，但必须测试并记录。

### 1P.18 Buffering

必须区分：

``` text
Preparing
Buffering
Paused
```

Buffering 时 UI 显示缓冲状态，但播放意图仍可保持为"用户希望播放"。

长时间 Buffering 触发恢复策略，而不是永久转圈。

### 1P.19 Gapless

Gapless 分为三个等级：

``` text
G0：普通切歌
G1：感知间隙尽量小
G2：Sample-Accurate Gapless
```

V1 必须首先验证 HarmonyOS 当前公开播放链能可靠达到哪个等级。

如果 `AVPlayer` 无法保证 G2：

-   不得宣传"完美无缝播放"。
-   可以实现 G1。
-   可以评估 PCM 解码 + AudioRenderer/OHAudio 的高级路径。
-   高级路径不得牺牲后台、功耗、格式覆盖和稳定性。

测试必须使用真正连续专辑/测试音频，不允许只凭主观"听起来差不多"。

### 1P.20 Crossfade

Crossfade 与 Gapless 是不同功能。

Crossfade 需要：

``` text
当前源淡出
下一源淡入
时间重叠
```

如果底层需要双播放器/双音频流，必须评估：

``` text
焦点
功耗
资源占用
后台
不同采样率
转码延迟
```

连续专辑启用 Gapless 时默认不使用
Crossfade，除非产品后续明确提供用户覆盖设置。

### 1P.21 ReplayGain

支持前必须验证播放链能安全调整 Gain。

至少解析/支持规划：

``` text
Track Gain
Album Gain
Peak
Preamp
```

防止增益导致削波。

如果只能通过粗粒度播放器 Volume 实现而无法满足正确 ReplayGain
语义，则先标记实验性或暂不发布，不允许做一个"看起来有开关"的伪实现。

### 1P.22 音量

默认使用系统媒体音量作为用户主要音量控制。

App 内部音量仅用于必要场景：

``` text
Duck
Crossfade
ReplayGain/DSP（正确实现后）
```

不得创建一套与系统媒体音量冲突的永久"SoundIsle 音量"。

### 1P.23 Scrobble

Scrobble 由播放状态驱动，而不是页面驱动。

必须防止：

``` text
打开详情页算播放
Prepare 算播放
Seek 重复计数
暂停/恢复重复计数
线路恢复重复计数
```

记录：

``` text
session/play instance id
actual listened duration
startedAt
reportedNowPlaying
reportedPlayed
```

服务器提交失败不得阻塞播放。

### 1P.24 本地播放历史

播放历史也由播放引擎事件产生。

建议规则可配置，但至少避免：

``` text
点一下立即退出
→ 被统计成完整播放
```

保存实际听取时长，未来常听统计基于真实播放行为。

### 1P.25 下载播放优先

同一 `MediaKey` 如果存在完整、校验通过的本地下载：

``` text
本地下载
优先于
远程 Stream
```

但必须确认下载对应的版本/音质仍有效。

本地文件损坏时自动回退远程播放（有网络时）。

### 1P.26 缓存音频

临时 Audio Cache 与 Download 完全不同。

Audio Cache：

``` text
可淘汰
可限制容量
可按 LRU/策略清理
```

Download：

``` text
用户资产
未经用户明确操作不得自动删除
```

### 1P.27 音频信息

播放详情可提供"音频信息"入口，显示：

``` text
Original / Transcoded
codec
bitrate
sample rate
bit depth
channels
source server
当前线路
```

这些是高级信息，不占据主播放页。

### 1P.28 功耗

音乐播放器是长时应用。

必须重点避免：

``` text
屏幕关闭后高频 UI Timer
每秒数据库写入 position
持续高频网络探测
无意义封面动画
过度预缓存
播放器未使用却不 release
```

播放位置可以在内存高频更新，本地持久化采用合理节流，例如关键生命周期事件 +
周期 checkpoint，而不是每个 tick 写数据库。

### 1P.29 长时间稳定性

正式 RC 必须安排：

``` text
2h 连续播放
8h/过夜长时播放（条件允许）
多次自动切歌
后台息屏
Wi-Fi 波动
蓝牙
暂停/恢复
```

检查：

``` text
内存增长
句柄/播放器泄漏
CPU
异常唤醒
队列漂移
AVSession 状态
播放位置
```

### 1P.30 音频测试素材

仓库不得提交无授权商业音乐作为测试资源。

建立合法测试素材策略：

``` text
自生成音频
公有领域
明确允许测试/再分发的素材
```

测试集应包含：

``` text
短音频
长音频
VBR
不同采样率
不同位深
连续专辑边界
损坏文件
超大封面
无 Metadata
Unicode Metadata
```

### 1P.31 真机音频矩阵

建立 `docs/audio-test-matrix.md`。

至少记录：

``` text
设备型号
HarmonyOS/API
输出：扬声器/有线/蓝牙
网络：Wi-Fi/蜂窝/离线
格式
Original/Transcoded
后台
锁屏
AVSession
Seek
切歌
结果
```

没有真机证据的音频能力不得标记 `DEVICE_TESTED`。

### 1P.32 播放遥测/诊断

默认不上传用户播放数据。

本地诊断可记录脱敏事件：

``` text
play request
resolve source result
prepare duration
buffering start/end
seek
route switch
transcode fallback
playback error category
AVSession command
interrupt
output device change
```

禁止记录：

``` text
密码
Token
Authorization
完整带凭证 URL
```

用户导出诊断日志时可以帮助定位"为什么这首歌播不了"。

### 1P.33 音频 Release Gate

V1 发布前，至少必须确认：

``` text
基础播放稳定
暂停/恢复正确
Seek 正确
上下首正确
随机/循环正确
队列持久化正确
后台播放真机通过
锁屏/播控中心同步真机通过
耳机/蓝牙控制关键场景通过
音频打断恢复符合用户意图
断网错误可理解
重新联网可恢复
不支持格式可以转码或明确报错
下载歌曲可离线播放
长时间播放无明显资源泄漏
```

Gapless、ReplayGain、Crossfade
若未达到发布质量，可以明确降级为实验性/P2，但不得阻塞基础播放器 V1。

### 1P.34 音频工程审批结论

**结论：批准进入实现，但播放引擎必须遵循"基础稳定优先，高级音频能力证据化"的原则。**

SoundIsle 不以"支持多少音频名词"衡量播放器质量，而以：

``` text
用户点击一首歌
→ 快速开始
→ 正确持续播放
→ 系统控制一致
→ 网络变化可恢复
→ 长时间可靠
```

作为第一质量标准。

## 1Q. Navidrome / OpenSubsonic API 架构审批基线

### 1Q.1 第一服务端原则

SoundIsle 的第一条、最严格兼容链路固定为：

``` text
SoundIsle
→ OpenSubsonic / Subsonic API
→ Navidrome
```

Navidrome 是首个真实验收服务器。其他 Provider
不得降低这条链路的实现质量。

### 1Q.2 协议优先级

实现优先级：

``` text
OpenSubsonic
→ 标准 Subsonic REST API 兼容
→ Navidrome 已知扩展/行为差异
```

禁止依赖 Navidrome Web UI
的私有内部接口作为核心播放方案。只有正式文档、稳定公共接口或经过明确隔离的兼容扩展才能进入
Provider。

### 1Q.3 连接握手

添加服务器后必须执行真实握手：

``` text
Normalize Base URL
→ ping
→ 确认协议版本 / server type / serverVersion
→ 探测 OpenSubsonic
→ getOpenSubsonicExtensions（可用时）
→ getMusicFolders
→ 生成 ServerCapabilities Snapshot
```

Capability Snapshot 至少记录：

``` text
serverType
serverVersion
protocolVersion
openSubsonic
extensions + versions
musicFolders
authenticationMode
lastCheckedAt
```

能力不能只根据"服务器名字叫 Navidrome"硬编码。

### 1Q.4 认证策略

认证实现必须支持能力协商：

``` text
OpenSubsonic API Key（服务器/用户配置支持时）
OR
Subsonic token + random salt
```

传统密码参数只用于必要兼容/测试，不作为默认安全方案。

每次 token 认证使用新的随机 salt。

禁止：

``` text
URL 日志输出完整 apiKey/token/password
同时发送相互冲突的认证参数
把明文密码写入普通数据库
```

反向代理/外部认证属于高级兼容场景，必须独立处理，不污染普通 Navidrome
登录流程。

### 1Q.5 请求基础参数

OpenSubsonic/Subsonic 请求统一由客户端层添加：

``` text
v
c=SoundIsle
f=json
authentication
```

业务代码不得每个 endpoint 自己拼认证参数。

### 1Q.6 ID 规则

所有远程 ID 一律作为：

``` text
string
```

禁止：

``` text
parseInt(song.id)
Number(album.id)
```

统一媒体标识：

``` text
MediaKey {
  providerId
  serverId
  mediaType
  remoteId: string
}
```

### 1Q.7 音乐库模型

Navidrome 默认使用 ID3/标签组织接口：

``` text
getArtists
getArtist
getAlbum
getSong
getAlbumList2
getGenres
search3
```

不得把：

``` text
getIndexes
getMusicDirectory
```

作为 Navidrome 默认音乐库架构基础，因为 Navidrome 的目录浏览是模拟结构。

### 1Q.8 多 Music Folder / Library

必须支持：

``` text
getMusicFolders
```

ServerProfile 保存用户可访问 Music Folders。

第一版 UI 可以默认：

``` text
全部可访问音乐库
```

但数据层必须保留 Music Folder/Library 维度，为后续筛选做准备。

### 1Q.9 分页

所有可能的大集合必须分页/增量加载：

``` text
songs
albums
artists
search results
playlists
```

禁止：

``` text
App 启动
→ 下载完整音乐库
```

分页状态统一：

``` text
initial
loadingMore
hasMore
error
```

### 1Q.10 搜索

优先：

``` text
search3
```

Provider 将结果映射为：

``` text
songs
albums
artists
```

不能假定所有 Subsonic 兼容服务器都支持 Navidrome 特有搜索行为。

### 1Q.11 首页 API 映射

首页优先复用服务器能力：

``` text
最近添加 → getAlbumList2 newest
随机 → getRandomSongs / random album strategy
收藏 → getStarred2
常听 → server capability / local history strategy
```

服务器无法提供的"最近播放/继续播放"优先使用 SoundIsle 本地播放历史。

### 1Q.12 播放

播放统一使用：

``` text
stream
```

由 PlaybackResolver 生成请求。

至少支持：

``` text
original
maxBitRate
format / transcode parameters（服务器支持时）
timeOffset / transcodeOffset extension（存在时）
```

具体参数必须根据实际 Capability 和 OpenSubsonic
版本启用，禁止对所有服务器无条件发送扩展参数。

### 1Q.13 下载

下载能力与 Stream 分离。

用户主动下载时优先使用服务器正式下载能力；下载完成后保存：

``` text
MediaKey
source server
quality
codec/container（可知时）
file path
file size
checksum/hash（可实现时）
completedAt
```

### 1Q.14 封面

封面统一通过 Provider 生成可请求资源。

必须支持：

``` text
getCoverArt
尺寸参数（服务器支持时）
Memory Cache
Disk Cache
```

Cache Key 至少包含：

``` text
serverId
coverArtId
requestedSize
```

避免不同服务器相同 ID 互相覆盖。

### 1Q.15 歌词

歌词 Provider 分层：

``` text
Server Lyrics
→ OpenSubsonic structured lyrics（服务器支持时）
→ legacy getLyrics
→ optional third-party lyrics provider
```

服务器歌词优先于第三方匹配。

统一输出领域模型：

``` text
Lyrics {
  plainText
  lines/timestamps
  language
  translated
  source
}
```

### 1Q.16 收藏与评分

远程：

``` text
star
unstar
setRating
```

本地收藏仍是独立 SoundIsle 数据。

UI 必须知道当前操作目标是：

``` text
Local Favorite
Server Favorite
```

不能悄悄把本地收藏变成服务器写操作。

### 1Q.17 歌单

服务器歌单：

``` text
getPlaylists
getPlaylist
createPlaylist
updatePlaylist
deletePlaylist
```

本地歌单独立保存。

任何服务器写操作必须：

``` text
用户动作
→ optimistic state（适用时）
→ API
→ success confirm
OR
→ rollback + user-facing error
```

### 1Q.18 Scrobble

Navidrome 的"播放"统计不能只依赖 stream 请求。

Scrobble 必须由真实播放状态驱动：

``` text
Now Playing
→ scrobble submission=false（适用时）

达到播放判定
→ scrobble submission=true
```

避免 Seek、恢复、线路切换造成重复提交。

### 1Q.19 Play Queue

服务器支持：

``` text
getPlayQueue
savePlayQueue
```

但 SoundIsle 的本地 QueueManager 仍是客户端播放队列权威。

服务器 Queue 同步属于：

``` text
可选跨设备功能
```

不得让服务器队列覆盖尚未确认的本地队列。

### 1Q.20 Bookmarks

Bookmarks 可用于：

``` text
长音频
有声内容
断点
```

普通音乐播放位置仍优先由 SoundIsle 本地维护。

### 1Q.21 响应解析

Provider 必须接受：

``` text
未知字段
新增字段
字段缺失
可选字段为 null
```

禁止因为服务器增加 OpenSubsonic 字段导致整个 JSON 解码失败。

领域模型只暴露 SoundIsle 需要的稳定字段；原始 DTO 与 Domain Model 分离。

### 1Q.22 API Error Mapping

Subsonic/OpenSubsonic 错误统一映射：

``` text
AuthenticationError
PermissionError
NotFound
UnsupportedCapability
ServerError
NetworkError
TlsError
Timeout
InvalidResponse
RateLimited（适用时）
Unknown
```

UI 不直接读取 Subsonic error code。

### 1Q.23 Capability-Driven UI

UI 是否显示功能必须来自：

``` text
ServerCapabilities
```

例如：

``` text
服务器不支持 structured lyrics
→ 不调用

服务器没有 downloadRole
→ 禁止服务器下载入口

服务器不支持某 extension
→ 使用 fallback
```

禁止：

``` text
if serverName == "Navidrome" then enableEverything
```

### 1Q.24 DTO / Domain 分离

结构：

``` text
OpenSubsonic DTO
↓
Mapper
↓
SoundIsle Domain Model
```

不得让：

``` text
SubsonicChild
SubsonicAlbumID3
```

直接泄漏到 UI。

### 1Q.25 API Fixtures

建立：

``` text
tests/fixtures/opensubsonic/
```

保存脱敏响应：

``` text
ping
artists
artist
album
song
search
starred
playlist
lyrics
extensions
errors
```

Fixtures 必须：

``` text
删除用户名
删除服务器域名
删除 token/apiKey
删除私人音乐路径
使用虚构 Metadata 或可合法使用数据
```

### 1Q.26 Contract Tests

OpenSubsonicProvider 至少测试：

``` text
正常响应
空集合
未知字段
缺少可选字段
字符串 ID
错误响应
认证失败
服务器旧版本
OpenSubsonic extension 存在/不存在
分页
Unicode Metadata
```

### 1Q.27 真实 Navidrome 测试

必须建立真实 Navidrome Integration Test Checklist：

``` text
login
ping
libraries
artists
albums
songs
search
stream original
stream transcode
cover
lyrics
favorite
rating
playlist
download
scrobble
queue（启用时）
```

记录：

``` text
Navidrome version
OpenSubsonic extensions
test date
result
known quirks
```

### 1Q.28 兼容性策略

Navidrome 当前兼容 Subsonic API 1.16.1，但存在自己的行为差异。因此：

``` text
OpenSubsonic Spec
+
Navidrome Compatibility Documentation
+
真实服务器测试
```

三者共同决定实现。

禁止只根据某一个第三方客户端的行为反推 API。

### 1Q.29 Provider Versioning

Provider 内部必须能根据：

``` text
protocolVersion
serverVersion
extensions
```

选择兼容路径。

兼容 workaround 必须集中管理并注释来源，禁止散落：

``` text
if (...)
if (...)
Navidrome special case
```

到各页面。

### 1Q.30 请求取消

页面退出、搜索词改变、快速切换专辑时取消不再需要的 API 请求。

播放相关请求采用更严格 generation/requestId，防止旧请求覆盖新状态。

### 1Q.31 缓存失效

Remote Metadata Cache 不是永久数据。

至少支持：

``` text
TTL
manual refresh
server switch invalidation
schema version invalidation
```

收藏/歌单等刚刚发生写操作的数据，应立即更新/失效相关缓存。

### 1Q.32 API 安全

服务器默认优先 HTTPS。

允许用户连接自己明确配置的 HTTP 局域网服务器，但 UI 必须清楚提示：

``` text
连接未加密
```

TLS 证书错误不得默认静默忽略。

重定向到不同 Host 时不得无条件携带认证信息。

### 1Q.33 第一阶段禁止事项

M1/M2 阶段禁止为了"兼容更多"做：

``` text
Navidrome 内部 Web API 逆向依赖
全量音乐库同步
服务器数据库镜像
页面直接拼 REST URL
Provider DTO 直接进入 UI
把密码/token写日志
把 ID 当数字
```

### 1Q.34 API 审批结论

**批准。**

OpenSubsonic/Navidrome 第一实现的成功标准不是"接口数量很多"，而是：

``` text
连接可靠
→ 能力识别正确
→ 大音乐库不需要全量同步
→ Metadata 映射稳定
→ Stream/Transcode 正确
→ 用户写操作不重复
→ 服务端升级后客户端具备兼容余量
```

Navidrome 是 SoundIsle 的第一黄金服务器，M1/M2 必须以真实 Navidrome
环境完成集成验证。

## 1R. QA / 测试负责人审批基线

### 1R.1 测试最高原则

SoundIsle
的测试目标不是"提高用例数量"，而是证明播放器在真实用户路径上可靠。

优先级：

``` text
真实 Navidrome 黄金链路
→ 播放稳定性
→ 用户本地数据安全
→ 后台/系统播控
→ 下载/离线
→ 弱网与恢复
→ UI 状态
→ 多 Provider
```

任何自动测试通过都不能替代必须真机验证的媒体/系统能力。

### 1R.2 测试金字塔

``` text
Local Unit Tests
    ↓
Repository / Mapper / Provider Contract Tests
    ↓
Integration Tests
    ↓
Instrument / UI Tests
    ↓
Real Device Scenario Tests
    ↓
Release Acceptance
```

Local Test 优先覆盖纯 ArkTS 业务逻辑；依赖系统
API、媒体能力和设备行为的测试进入 Instrument/真机层。

### 1R.3 P0 黄金路径

每个 Release Candidate 必须完整跑通：

``` text
首次启动
→ 添加 Navidrome
→ 登录
→ 获取音乐库
→ 搜索歌曲
→ 打开专辑
→ 播放
→ Seek
→ 上/下一首
→ 后台
→ 锁屏/系统播控
→ 回到 App
→ 歌词
→ 下载
→ 断网
→ 播放下载歌曲
→ 重启 App
→ 恢复本地状态
```

任何一步失败，RC 不得通过。

### 1R.4 自动测试最低覆盖范围

必须自动测试：

``` text
DTO → Domain Mapper
MediaKey
Capability parsing
Auth parameter generation
Pagination
Cache key
Queue operations
Shuffle history
Playback state reducer
Playback request generation
PlaybackResolver decisions
Error mapping
Retry policy
Local favorites
Local playlists
History rules
Settings persistence
Database migrations
Download state machine
Scrobble deduplication
```

### 1R.5 Provider Contract Test

OpenSubsonicProvider 使用脱敏 Fixtures 覆盖：

``` text
正常
空集合
null/缺字段
未知字段
Unicode
超长 Metadata
错误码
认证失败
旧协议
扩展存在/不存在
分页
非法 JSON
网络超时映射
```

未来 Jellyfin/Emby/Plex/AudioStation 使用同样模式。

### 1R.6 Integration Test

真实服务器测试不得只依赖 Mock。

Navidrome Integration 环境记录：

``` text
server version
protocol version
extensions
authentication
test library characteristics
test date
```

集成测试不能提交真实用户密码、Token、私人音乐路径。

### 1R.7 真机强制测试

以下能力默认必须真机：

``` text
AVPlayer 真实播放
后台播放
息屏
AVSession
锁屏播控
蓝牙控制
有线耳机拔出
音频打断
长时间播放
Wi-Fi/蜂窝切换
功耗
部分格式兼容性
```

模拟器结果不得升级为 `DEVICE_TESTED`。

### 1R.8 UI 状态测试

核心 Remote 页面必须验证：

``` text
Loading
Content
Empty
Refreshing
OfflineWithCache
OfflineNoCache
PartialError
FatalError
```

额外验证：

``` text
超长标题
Unicode/CJK
无封面
损坏封面
无歌词
超长歌单
大字体
深色
浅色
```

### 1R.9 播放竞态测试

必须专门构造：

``` text
连续点击 A → B → C
Prepare 时 Seek
Prepare 时切歌
Buffering 时切歌
下载完成瞬间播放
URL 过期后恢复
切线路时用户又切歌
App 后台时队列结束
```

验收：旧请求不得覆盖当前播放请求。

### 1R.10 弱网与故障注入

测试：

``` text
高延迟
丢包/断网
连接超时
读取超时
服务器 5xx
认证失效
TLS 错误
返回非法 JSON
播放 URL 失效
服务器突然关闭
网络恢复
```

必须验证错误信息、有限重试和恢复路径，而不只是"不会崩"。

### 1R.11 数据安全回归

每个 RC 必测：

``` text
fresh install
升级 N-1 → N
升级中断
数据库 migration
清缓存
删除下载
移除服务器
App 强制停止
App 数据恢复路径
```

重点保护：

``` text
服务器配置
本地收藏
本地歌单
播放历史
下载记录
用户设置
```

### 1R.12 缓存与下载隔离测试

明确证明：

``` text
清除缓存
≠
删除 Downloads
```

以及：

``` text
缓存淘汰
≠
删除本地歌单/收藏/历史
```

这是 Release Gate。

### 1R.13 大库测试

准备可控的大型测试数据集/模拟响应，至少验证：

``` text
1k
10k
50k+
```

级别的歌曲/专辑相关分页与列表逻辑。

目标不是一次载入全部，而是证明：

``` text
不会全量同步
不会 UI 卡死
分页不会重复/漏项
缓存不会无限增长
```

### 1R.14 下载测试

覆盖：

``` text
单曲
专辑批量
队列
暂停
恢复
失败重试
断网
重启 App
空间不足
文件损坏
重复下载
删除
离线播放
```

### 1R.15 Scrobble 测试

验证：

``` text
短点播不误记
达到阈值正确提交
暂停恢复不重复
Seek 不重复
线路恢复不重复
App 后台不重复
服务器失败不阻塞播放
```

### 1R.16 覆盖率

覆盖率是风险指标，不是 KPI。

优先要求高覆盖：

``` text
Domain
Mapper
Queue
Playback state
Resolver
Migration
Download state
Auth
Error mapping
```

UI/系统媒体层不能为了追求数字写低价值测试。

每次 RC 输出覆盖率报告并解释核心未覆盖区域。

### 1R.17 缺陷严重级别

``` text
P0
数据丢失 / 安全漏洞 / 无法启动 / 大面积无法播放

P1
后台播放失败 / 队列严重错误 / 下载损坏 /
认证关键故障 / 主要流程不可用

P2
有可靠替代路径的功能缺陷

P3
轻微 UI / 文案 / 边缘体验
```

Release：

``` text
P0 = 0
P1 = 0
```

### 1R.18 缺陷必须可复现

Bug 记录至少包含：

``` text
版本
commit SHA
设备
HarmonyOS/API
服务器类型/版本
网络
前置条件
步骤
实际结果
期望结果
日志/截图（适用时）
```

播放 Bug 额外记录：

``` text
codec/container
Original/Transcoded
route
player state
```

### 1R.19 Flaky Test

自动测试不允许通过"重跑直到绿"解决。

Flaky 测试必须：

``` text
记录
定位
修复
```

确需隔离时：

``` text
标记 quarantine
指定原因
指定恢复条件
```

不得永久忽略。

### 1R.20 CI 门禁

每次合并至少执行环境可支持的：

``` text
静态检查
Local Tests
Provider Contract Tests
Migration Tests
配置/文档校验
Debug build
```

如果 CI 无 HarmonyOS 完整构建环境，必须明确标记，而不是伪造 Build Gate。

### 1R.21 Instrument / 黑盒覆盖

在可用环境中建立 Instrument Test；关键 RC 可利用 DevEco Studio
的设备测试与黑盒覆盖能力检查真实交互路径。

覆盖率数据只能辅助发现未走到的代码，不能替代功能断言。

### 1R.22 AppAnalyzer

RC 阶段使用 DevEco Studio AppAnalyzer/场景化体检检查：

``` text
冷启动
页面滑动
页面转场
内存
CPU
后台
功耗
多设备
```

发现明显回归必须进入缺陷列表。

### 1R.23 性能回归

建立 Baseline，而不是随意写一个"必须 100ms"。

记录：

``` text
cold start
home first content
search response perception
large list scroll
player prepare duration
memory during playback
2h memory delta
background CPU
cover cache hit rate
```

同设备/同测试条件比较版本回归。

### 1R.24 测试账号与测试音乐库

建立专用测试 Navidrome 环境。

不得使用真实私人音乐库作为自动化唯一测试源。

测试库包含合法素材：

``` text
不同格式
不同采样率
Unicode
无封面
大封面
无歌词
同步歌词
短歌
长歌
连续专辑
损坏媒体
```

### 1R.25 多设备矩阵

`docs/test-matrix.md` 记录：

``` text
设备
屏幕形态
HarmonyOS/API
测试类型
结果
```

最低关注：

``` text
普通手机
大屏/折叠或平板（正式支持时）
至少一个目标最低 API 环境
当前主力 API 环境
```

### 1R.26 测试状态

统一：

``` text
NOT_STARTED
READY
IN_PROGRESS
IMPLEMENTED
AUTO_TESTED
INTEGRATION_TESTED
DEVICE_TEST_REQUIRED
DEVICE_TESTED
FAILED
BLOCKED
DONE
```

任何 AI 不能自行把：

``` text
AUTO_TESTED
```

改成：

``` text
DEVICE_TESTED
```

除非实际运行在设备上并保留证据。

### 1R.27 Release Test Report

每个 RC 生成：

``` text
docs/releases/<version>-test-report.md
```

至少包含：

``` text
commit SHA
build environment
server versions
device matrix
golden path
automated test summary
coverage
audio matrix
upgrade tests
performance baseline
open P2/P3
known limitations
```

### 1R.28 Stop-Ship 条件

以下任何一项存在即禁止发布：

``` text
P0/P1 未解决
用户数据可能无故丢失
凭证泄漏
基础播放不稳定
后台播放关键场景失败
下载文件可能被清缓存误删
数据库升级不可验证
RC 无法从干净工作区复现构建
```

### 1R.29 QA 审批结论

**批准，但 V1 完成必须由测试证据定义。**

SoundIsle 的质量判断固定为：

``` text
代码存在
≠
功能完成

自动测试通过
≠
真机通过

一次播放成功
≠
播放器稳定

AI 说完成
≠
Release 可发布
```

只有需求、实现、自动测试、集成测试、必要真机测试和 Release Gate
形成证据链，功能才可以进入 DONE。

## 1S. 多角色架构委员会联合终审

本节由以下角色共同审查并相互质询：

``` text
软件项目经理
HarmonyOS 客户端架构师
ArkTS 架构师
音频专项专家
业务逻辑架构师
OpenSubsonic / Navidrome API 架构师
UI/UX 负责人
QA / 测试负责人
安全 / 隐私负责人
DevOps / Release 负责人
```

本节不是增加更多功能，而是解决不同角色之间可能出现的冲突，并确定
SoundIsle 的最终实施边界。

### 1S.1 联合结论

所有角色一致确认：

> SoundIsle 是一个 **API 驱动、Local-First User State、Playback-Centric
> 的 HarmonyOS 原生音乐播放器客户端**。

核心边界：

``` text
服务器
负责音乐内容和远程 Metadata

SoundIsle
负责播放、浏览、缓存、下载和本地用户体验状态
```

禁止把项目逐渐演变成：

``` text
音乐服务器
全量音乐数据库镜像
重型双向同步系统
跨平台大一统客户端框架
```

------------------------------------------------------------------------

## 1S.2 项目经理 × 客户端架构师：范围冲突结论

### 争议

客户端架构可以无限扩展，例如：

``` text
复杂 Sync Engine
跨服务器全量索引
全局媒体去重
WebDAV 文件库
MusicBrainz 数据增强
```

但这些会扩大交付风险。

### 决议

V1 架构必须允许未来扩展，但 **不得提前实现未进入当前里程碑的复杂系统**。

原则：

``` text
架构预留
≠
现在实现
```

例如：

``` text
定义 MediaKey
✓

实现全服务器去重引擎
V1 不需要
```

``` text
Provider 接口可扩展
✓

同时实现十种 Provider
✗
```

------------------------------------------------------------------------

## 1S.3 HarmonyOS 架构师 × 音频专家：后台播放最终方案

HarmonyOS 当前媒体后台播放不是普通页面持续运行即可。

最终架构必须围绕：

``` text
AVPlayer
+
AVSession
+
Background Tasks
+
Audio interruption handling
```

HarmonyOS 官方当前规则明确要求音乐类后台播放接入
AVSession，并申请对应长时后台任务；否则应用后台可能被静音和冻结。

因此：

``` text
后台播放
锁屏播放
系统播控
```

全部属于 P0，而不是后期增强。

播放器生命周期必须独立于页面生命周期。

------------------------------------------------------------------------

## 1S.4 ArkTS 架构师 × HarmonyOS 架构师：状态管理

禁止把所有业务状态放进：

``` text
AppStorage
PersistentStorage
```

ArkTS UI 状态工具只负责 **UI / Presentation State**。

统一原则：

``` text
页面临时 UI 状态
→ Component State / Local UI State

跨页面 UI 状态
→ Application-level Presentation Store

业务持久数据
→ Repository + ArkData

播放器真实状态
→ PlayerStateStore

敏感凭证
→ Secure Storage
```

不得让 AppStorage 变成业务数据库。

### PlayerStateStore

PlayerStateStore 是业务运行状态 Store，不等同于 ArkUI 的简单 UI State。

它负责：

``` text
Player lifecycle
current media
queue
position
duration
buffering
play mode
play intent
source
route
error
```

ArkUI 只订阅它的可展示 State。

------------------------------------------------------------------------

## 1S.5 ArkTS 架构师：并发模型

ArkTS 对并发和 Sendable/TaskPool 有自己的约束。

不得照搬 Node.js / Web TypeScript 项目的并发习惯。

CPU 密集任务，例如未来存在：

``` text
大型 Metadata 解析
音频指纹
大量文件扫描
图片计算
```

才考虑 TaskPool / Worker。

普通：

``` text
HTTP
数据库
播放器命令
UI State
```

优先使用平台异步 API。

禁止：

``` text
为了“架构高级”
→ 所有操作都扔 Worker
```

跨线程对象必须遵守 ArkTS Sendable / 线程安全约束。

------------------------------------------------------------------------

## 1S.6 ArkTS 架构师：语言约束

正式代码遵循 ArkTS 当前编译器约束。

不得假设所有 TypeScript 动态写法都可以直接使用。

重点要求：

``` text
强类型
避免 any
避免动态增删对象字段
避免复杂运行时反射
明确 nullable
明确 DTO 类型
明确 Domain 类型
```

API 响应：

``` text
JSON
→ DTO Validation / Defensive Parse
→ Mapper
→ Domain
```

不得：

``` text
JSON as Song
```

直接强转后使用。

------------------------------------------------------------------------

## 1S.7 业务逻辑架构师：核心业务域

SoundIsle 只保留以下核心业务域：

``` text
Server
Library
Playback
Queue
History
Favorite
Playlist
Lyrics
Download
Settings
Cache
```

其中：

### Server / Library

负责：

``` text
从 API 获取音乐
统一远程模型
```

### Playback / Queue

负责：

``` text
用户正在怎么听
```

### History / Favorite / Playlist

负责：

``` text
用户自己的本地行为
```

### Download / Cache

负责：

``` text
离线资产
临时数据
```

不得把一个 `MusicRepository` 做成包含全部业务的"万能仓库"。

------------------------------------------------------------------------

## 1S.8 业务逻辑：UseCase 是否需要

委员会讨论结论：

**不强制每一个按钮都创建一个 UseCase Class。**

错误示例：

``` text
PlaySongUseCase
PauseSongUseCase
SetVolumeUseCase
OpenAlbumUseCase
CloseAlbumUseCase
...
```

这会制造大量无意义样板代码。

只有存在：

``` text
跨 Repository
复杂规则
业务编排
可独立测试的核心决策
```

时才建立 UseCase / Domain Service。

例如：

``` text
ResolvePlaybackSource
BuildHomeFeed
SwitchServerRoute
CreateLocalPlaylist
DownloadAlbum
```

简单 CRUD 可以：

``` text
ViewModel
→ Repository Contract
```

保持架构清晰而不过度设计。

------------------------------------------------------------------------

## 1S.9 Repository 规则

按业务责任建立：

``` text
ServerRepository
LibraryRepository
HistoryRepository
FavoriteRepository
PlaylistRepository
LyricsRepository
DownloadRepository
SettingsRepository
```

Player 不属于 Repository。

Playback 使用：

``` text
PlayerController
PlaybackResolver
QueueManager
```

避免：

``` text
PlayerRepository
```

成为混杂 API、数据库和播放器的巨型类。

------------------------------------------------------------------------

## 1S.10 本地数据库最终划分

### Preferences

用于：

``` text
主题
字体
播放偏好
音质偏好
简单开关
最后使用服务器 ID
```

### RDB

用于：

``` text
ServerProfile 非敏感字段
PlayHistory
LocalFavorites
LocalPlaylists
PlaylistItems
Downloads
Queue snapshot
SearchHistory
Metadata cache index
Lyrics cache index
Pending server write（少量必要场景）
```

### Secure Storage

用于：

``` text
password
token
apiKey
敏感 Header
```

### File Storage

用于：

``` text
downloads/
cache/images/
cache/lyrics/
cache/audio/
diagnostics/
```

------------------------------------------------------------------------

## 1S.11 API 架构师 × 业务逻辑：远程收藏争议

Navidrome 支持 Star、Rating、Playlist、Scrobble。

但 SoundIsle 又有本地用户数据。

最终产品定义：

``` text
本地收藏
永远可以独立存在

服务器收藏
是可选远程操作
```

V1 UI 必须清楚区分。

推荐默认：

``` text
收藏按钮 → 本地收藏
```

服务器同步可作为设置：

``` text
同步收藏到当前服务器
```

如果产品后续决定默认同步，必须通过产品变更确认，而不是由 Provider
自动决定。

------------------------------------------------------------------------

## 1S.12 播放专家 × API 架构师：播放 URL

一致结论：

``` text
Song
不能拥有永久 streamUrl
```

必须：

``` text
MediaKey
→ PlaybackResolver
→ Provider
→ Route
→ Quality
→ AudioSource
```

原因：

``` text
URL 可过期
认证可变化
线路可切换
音质可变化
转码参数可变化
```

------------------------------------------------------------------------

## 1S.13 播放专家 × 业务逻辑：队列权威

本地 `QueueManager` 是唯一实时播放队列权威。

Navidrome `getPlayQueue/savePlayQueue` 仅属于：

``` text
可选远程同步
```

不得：

``` text
App 正在播放
→ 后台 API 返回旧 Queue
→ 覆盖本地 Queue
```

------------------------------------------------------------------------

## 1S.14 播放专家 × UI/UX：Optimistic State 边界

以下可采用轻量 Optimistic UI：

``` text
收藏
加入本地歌单
队列操作
```

播放状态不能完全 Optimistic。

例如：

``` text
点击 Play
```

可以立即显示"准备播放"，但必须等待播放器真实事件才进入：

``` text
Playing
```

否则容易出现：

``` text
按钮显示暂停
实际没有声音
```

------------------------------------------------------------------------

## 1S.15 HarmonyOS × ArkTS：播放器状态来源

HarmonyOS `AVPlayer` 有自己的真实播放器状态。

SoundIsle Domain State 可以比 AVPlayer 状态更丰富：

``` text
ResolvingSource
Recovering
Buffering
Seeking
```

因此不能简单：

``` text
PlayerState = AVPlayer.state
```

正确结构：

``` text
AVPlayer events
+
PlaybackResolver state
+
Queue state
+
User intent
↓
Player State Reducer
↓
PlayerStateStore
```

------------------------------------------------------------------------

## 1S.16 播放专家：Gapless 最终裁定

委员会一致否决：

> V1 必须实现"绝对完美 Gapless"才能发布。

最终规则：

``` text
基础播放稳定 = P0

Best-effort Gapless = P1

Sample-accurate Gapless
只有实际技术验证可行后才承诺
```

当前架构必须允许未来替换/增加高级 PlaybackEngine，但不能为了追求
Sample-Accurate Gapless 一开始重写整个音频栈。

------------------------------------------------------------------------

## 1S.17 UI × 项目经理：页面数量控制

V1 不应该出现大量技术页面。

一级页面固定：

``` text
Home
Library
Search
My
Player
```

二级核心：

``` text
Album
Artist
Playlist
Downloads
History
Music Services
Settings
```

调试：

``` text
Server Capability
Audio Debug
Network Debug
```

全部隐藏进：

``` text
Developer Options
```

不能污染普通 UI。

------------------------------------------------------------------------

## 1S.18 QA × 项目经理：V1 验收重新聚焦

委员会统一认为之前 V1 一次要求六个服务器都达到日用标准风险过高。

修订为：

### V1.0 Release Gate

必须：

``` text
Navidrome/OpenSubsonic
达到完整日用标准
```

其他 Provider：

``` text
Jellyfin
Emby
AudioStation
Plex
```

允许满足以下任一：

``` text
READY
BETA
IMPLEMENTED_UNVERIFIED
```

但必须在 UI / Release Notes 明确状态。

**不能因为 Plex 没测试完而永远阻止一个已经非常成熟的 Navidrome
客户端发布。**

建议版本路线：

``` text
1.0
Navidrome / OpenSubsonic First-Class

1.1+
逐步把其他 Provider 提升至 First-Class
```

这是本次终审最重要的范围修正之一。

------------------------------------------------------------------------

## 1S.19 项目经理：V1 第一黄金用户

V1 的黄金用户定义：

``` text
有 HarmonyOS 手机
+
已经有 Navidrome
+
希望在手机稳定听自己的音乐
```

第一阶段一切产品决策优先满足这个用户。

------------------------------------------------------------------------

## 1S.20 QA × 音频专家：真实设备不可替代

AI 可以自动：

``` text
写代码
构建
Local Test
Contract Test
Integration Test
静态分析
```

但以下无法通过纯代码证明：

``` text
锁屏是否真的稳定
蓝牙按钮是否正确
后台数小时是否被系统冻结
实际耳机拔出行为
真实手机功耗
不同设备音频兼容性
```

因此 AI 在无设备时必须：

``` text
实现完成
→ AUTO_TESTED
→ DEVICE_TEST_REQUIRED
```

不得写 DONE。

------------------------------------------------------------------------

## 1S.21 安全 × API：HTTP 局域网

私人 NAS 用户大量存在：

``` text
http://192.168.x.x
```

因此 SoundIsle 不禁止 HTTP LAN。

产品策略：

``` text
HTTPS
推荐

HTTP 私有局域网
允许 + 明确未加密提示

HTTP 公网地址
强警告
```

不得因为安全规则导致普通 NAS 用户无法使用。

------------------------------------------------------------------------

## 1S.22 缓存一致性

缓存策略最终简化：

``` text
Remote content
→ Cache

User data
→ Persistent Local Data
```

缓存失败：

``` text
可以重新请求
```

本地用户数据失败：

``` text
必须明确错误
不能静默丢失
```

这两类错误严重程度不同。

------------------------------------------------------------------------

## 1S.23 TaskScheduler 的边界

TaskScheduler 只管理真正需要统一调度的工作：

``` text
下载
缓存清理
服务器健康检查
必要同步
延迟重试
```

禁止普通：

``` text
打开专辑
搜索
点击播放
```

都绕 TaskScheduler。

否则会让架构变复杂。

------------------------------------------------------------------------

## 1S.24 EventBus 最终规则

默认：

``` text
不要建立全局万能 EventBus
```

跨模块协作优先：

``` text
明确接口
Observable State
Repository
PlayerStateStore
```

只有真正系统级事件可以通过集中 Event Hub：

``` text
NetworkChanged
AuthExpired
StorageLow
```

------------------------------------------------------------------------

## 1S.25 错误处理层级

统一：

``` text
Platform / HTTP Error
↓
Infrastructure Error
↓
Domain Error
↓
Presentation State
↓
用户可理解文案
```

禁止 UI：

``` text
catch(error)
Text(error.message)
```

直接把内部异常展示给用户。

------------------------------------------------------------------------

## 1S.26 ArkTS 文件/模块复杂度控制

禁止出现：

``` text
3000 行 ViewModel
万能 Utils
万能 Common
万能 MusicManager
```

模块应按职责拆分。

但也禁止为了"Clean Architecture"产生数百个只有 5 行代码的类。

标准：

``` text
职责清晰
可测试
可替换
够用
```

而不是类越多越专业。

------------------------------------------------------------------------

## 1S.27 依赖注入

V1 不强制引入大型 DI Framework。

推荐：

``` text
Composition Root
+
Constructor Injection
+
Interface Contracts
```

必要单例：

``` text
PlayerService
PlayerStateStore
Database
SecureStorage
```

由应用 Composition Root 管理生命周期。

禁止页面自己到处：

``` text
new Repository()
new Provider()
new Player()
```

------------------------------------------------------------------------

## 1S.28 日志体系

日志至少分：

``` text
APP
NETWORK
PROVIDER
PLAYER
DOWNLOAD
DATABASE
SYSTEM
```

支持 correlation/request id。

播放一次请求应能串联：

``` text
PlayIntent
→ Resolve
→ HTTP
→ Prepare
→ Playing
→ Error/Complete
```

从而真正定位"为什么没播放"。

------------------------------------------------------------------------

## 1S.29 DevOps × ArkTS：构建可复现

必须锁定并记录：

``` text
DevEco Studio
HarmonyOS SDK/API
Hvigor
ohpm dependencies
Node runtime（构建链实际需要时）
```

不得仅写：

``` text
最新版
```

AI 接手时先检查环境是否符合 `BUILDING.md`。

------------------------------------------------------------------------

## 1S.30 文档去重规则

委员会发现 MASTER_PLAN 已经很长。

从 V8 开始：

``` text
MASTER_PLAN
只保留原则 / Gate / 核心定义

ARCHITECTURE
保存客户端详细架构

AUDIO_ARCHITECTURE
保存播放器详细状态机

API_OPEN_SUBSONIC
保存 API 详细映射

UI_SPEC
保存页面/设计系统

TEST_PLAN
保存测试细节
```

后续不再无限往 MASTER_PLAN 堆实现细节。

V8 是总规范冻结节点。

------------------------------------------------------------------------

## 1S.31 需要拆出的正式文档

AI 初始化仓库时应生成：

``` text
MASTER_PLAN.md
PRODUCT_REQUIREMENTS.md
ARCHITECTURE.md
AUDIO_ARCHITECTURE.md
API_OPEN_SUBSONIC.md
UI_SPEC.md
TEST_PLAN.md
ROADMAP.md
CURRENT_MILESTONE.md
TASKS.md
PROJECT_STATUS.md
RISK_REGISTER.md
BUILDING.md
```

MASTER_PLAN 中的相应详细内容可以迁移出去，但不能丢失约束。

------------------------------------------------------------------------

## 1S.32 架构委员会最终评分

``` text
产品边界        9.5 / 10
HarmonyOS 架构  9.3 / 10
ArkTS 架构      9.2 / 10
播放架构        9.4 / 10
API 架构        9.4 / 10
业务逻辑        9.2 / 10
UI/UX          9.0 / 10
测试体系        9.4 / 10
AI 自动执行性    9.3 / 10
```

剩余风险主要不是文档设计，而是：

``` text
HarmonyOS 真机行为
真实 Navidrome 兼容测试
高级 Gapless 技术可行性
实际长时后台功耗
其他 Provider 的真实服务器测试资源
```

这些无法继续靠写规范消除，必须进入实现和真实验证阶段。

### 1S.33 最终批准结论

**APPROVED FOR IMPLEMENTATION**

委员会一致批准 SoundIsle 按以下顺序正式开工：

``` text
M0
HarmonyOS / ArkTS 工程基线

M1
真实 Navidrome / OpenSubsonic

M2
第一条完整播放链

M3
后台 / AVSession / 日用体验

M4
下载 / 离线 / 高级播放

M5+
其他 Provider
```

在 M2 完成以前，不启动非必要 P2 功能。

## 1T. 普通用户参与产品委员会复审

### 1T.1 本轮新增参与者

在原架构委员会基础上，加入真实产品视角的普通用户角色：

``` text
U1 只想连接 Navidrome 后听歌的普通用户
U2 不懂 Subsonic / API / 转码概念的用户
U3 音乐库很多、每天高频听歌的用户
U4 经常使用蓝牙耳机 / 车载 / 锁屏控制的用户
U5 经常在 Wi-Fi / 移动网络之间切换的用户
U6 希望下载音乐后离线听的用户
U7 家里 NAS 只提供 HTTP 局域网地址的用户
U8 年龄偏大或不喜欢复杂设置的用户
```

普通用户拥有产品否决权：

> 技术上正确但普通用户难以理解、难以完成或容易误操作的方案，不得直接进入正式产品。

------------------------------------------------------------------------

## 1T.2 普通用户第一句话测试

普通用户第一次看到 SoundIsle，必须能在很短时间内理解：

> **"这是用来连接我自己的音乐服务器并听歌的播放器。"**

首次欢迎页不得出现：

``` text
Provider
OpenSubsonic Extension
Repository
Capability
Endpoint
AVSession
Transcode Pipeline
```

这些属于内部技术语言。

允许出现：

``` text
连接你的音乐服务
播放自己的音乐
支持 Navidrome
```

------------------------------------------------------------------------

## 1T.3 首次使用成功标准

普通 Navidrome 用户首次安装后的黄金路径：

``` text
打开 SoundIsle
↓
选择 Navidrome
↓
输入服务器地址
↓
输入用户名
↓
输入密码
↓
点击连接
↓
成功
↓
看到自己的音乐
↓
点一首歌
↓
开始播放
```

目标：

``` text
无需阅读教程
无需理解 API
无需手工选择认证协议
无需设置转码
无需设置 Music Folder
无需配置播放器引擎
```

高级能力全部自动探测。

------------------------------------------------------------------------

## 1T.4 服务器地址输入必须"宽容"

普通用户可能输入：

``` text
music.example.com
https://music.example.com/
http://192.168.1.10:4533
192.168.1.10:4533
```

客户端应在安全范围内帮助规范化，而不是因为缺一个 `/` 或协议就直接失败。

如果无法确定，应给出可理解提示。

不得要求用户自己拼：

``` text
/rest
/rest/ping
/api
```

------------------------------------------------------------------------

## 1T.5 "连接失败"必须告诉用户下一步

禁止只显示：

``` text
Error 401
SocketException
TLS handshake failed
ECONNREFUSED
```

普通用户错误提示采用：

``` text
发生了什么
+
可能原因
+
下一步按钮
```

例如：

``` text
无法连接到音乐服务器

请确认：
• 服务器地址是否正确
• Navidrome 是否正在运行
• 当前手机是否能访问这个地址

[重新连接] [编辑地址]
```

高级错误详情折叠显示，便于用户截图给开发者。

------------------------------------------------------------------------

## 1T.6 登录后不要让用户继续"配置"

连接成功后直接进入音乐体验。

禁止强制继续：

``` text
选择 API Version
选择 Extension
选择 Codec
选择转码格式
选择数据库同步方式
```

SoundIsle 自动选择安全、兼容的默认值。

高级用户可以在设置里修改。

------------------------------------------------------------------------

## 1T.7 首页必须解决"我现在听什么"

普通用户否决"首页技术化"。

首页第一屏优先：

``` text
继续播放
最近播放
最近添加
收藏
常听
```

不优先：

``` text
服务器状态
API 延迟
Music Folder
Codec
缓存命中率
Provider Capability
```

服务器异常只以轻量状态提示出现。

------------------------------------------------------------------------

## 1T.8 立即播放

用户点击歌曲：

``` text
第一意图 = 播放
```

不弹：

``` text
选择播放方式
选择音质
选择线路
选择转码
```

除非默认策略失败或用户主动开启"每次询问"。

系统自动：

``` text
选线路
→ 选 Original/Transcode
→ 播放
```

------------------------------------------------------------------------

## 1T.9 "音质"用普通语言

设置中的音质优先：

``` text
原始音质
高音质
标准
省流量
```

高级页面才显示：

``` text
320 kbps
256 kbps
AAC
Opus
FLAC
```

默认推荐：

``` text
Wi-Fi：原始音质
移动网络：高音质/用户首次可选择
下载：原始音质
```

但不得偷偷产生超出用户预期的大量移动数据。

------------------------------------------------------------------------

## 1T.10 移动数据保护

第一次使用移动网络播放高码率/原始音质时，应有一次清晰提示。

例如：

``` text
当前正在使用移动网络。
原始音质可能消耗较多流量。

[继续原始音质]
[改为高音质]
```

之后尊重用户选择，不反复打扰。

下载默认遵守用户设置：

``` text
仅 Wi-Fi
或
允许移动网络
```

------------------------------------------------------------------------

## 1T.11 本地收藏与服务器收藏：普通用户否决"双爱心"

委员会原方案允许区分：

``` text
本地收藏
服务器收藏
```

普通用户反馈：

> 两套收藏同时直接暴露，会让人不知道应该点哪一个。

因此修订：

### 默认产品体验

界面只显示一个：

``` text
♡ 收藏
```

其语义：

``` text
SoundIsle 本地收藏立即生效
```

如果用户开启：

``` text
同步收藏到服务器
```

则后台同时尝试服务器 Star。

同步失败：

``` text
本地收藏仍然保留
+
显示轻量“服务器同步失败”
```

高级详情里可以查看：

``` text
本地：已收藏
服务器：已同步 / 未同步 / 不支持
```

这样用户永远不会因为服务器写失败丢失自己的收藏。

------------------------------------------------------------------------

## 1T.12 歌单也避免双系统混乱

创建歌单时默认：

``` text
创建 SoundIsle 歌单
```

如果服务器支持，可以提供：

``` text
同步到服务器
```

或者在高级操作中：

``` text
创建服务器歌单
```

普通用户不应该在每次创建歌单时先回答：

``` text
Local or Remote?
```

------------------------------------------------------------------------

## 1T.13 "我的"页面重新排序

普通用户最常用内容放前面：

``` text
下载
收藏
歌单
播放历史
音乐服务
设置
```

而不是先看到服务器技术信息。

如果只有一个服务器：

``` text
音乐服务
```

显示简单名称和连接状态即可。

------------------------------------------------------------------------

## 1T.14 Mini Player 普通用户测试

Mini Player 必须做到：

``` text
一眼看出正在播放什么
一键暂停/继续
点击进入播放器
```

不得塞入：

``` text
音质
服务器
线路
Codec
下载状态
多个小按钮
```

避免误触。

------------------------------------------------------------------------

## 1T.15 播放页"核心按钮不能藏"

核心控制：

``` text
上一首
播放/暂停
下一首
进度
队列
播放模式
```

必须明显。

以下功能可以进入更多菜单：

``` text
音频信息
服务器信息
线路
重新解析播放源
调试
```

------------------------------------------------------------------------

## 1T.16 返回行为必须可预测

普通用户重点关注：

``` text
从播放器返回
→ 音乐继续播放

从专辑返回
→ 回到刚才的列表位置

从搜索结果进入歌曲再返回
→ 搜索词和结果仍在
```

禁止因为页面销毁导致用户上下文丢失。

------------------------------------------------------------------------

## 1T.17 App 重启后的用户预期

普通用户杀掉 App 再打开：

``` text
应该看到上次听的歌
队列还在
进度大致还在
```

但：

``` text
不应该突然自动发出声音
```

除非用户从系统播控明确点击播放。

------------------------------------------------------------------------

## 1T.18 无网络时不要"像坏掉了"

断网后：

如果有下载：

``` text
首页/我的明确提供“已下载”
```

如果有缓存：

``` text
继续展示可浏览内容
```

不可播放的在线歌曲：

``` text
明确显示“需要网络”
```

不要让用户点击后无限转圈。

------------------------------------------------------------------------

## 1T.19 下载必须让人放心

下载歌曲后，用户最关心：

``` text
下载成功了吗？
占了多少空间？
没网能不能播？
清缓存会不会删掉？
```

产品必须明确回答。

下载管理提供：

``` text
已下载
正在下载
失败
存储占用
```

"清除缓存"页面必须明确写：

> **不会删除你主动下载的音乐。**

------------------------------------------------------------------------

## 1T.20 删除行为

普通用户最怕误删。

### 清缓存

不需要高强度警告，因为可恢复，但必须说明不会删下载。

### 删除下载

明确告诉用户：

``` text
只删除手机上的离线文件
不会删除服务器里的歌曲
```

### 移除服务器

必须说明：

``` text
不会删除服务器数据
```

并告知会影响哪些本地关联数据。

------------------------------------------------------------------------

## 1T.21 服务器不可用时保留本地资产

移除/暂时断开服务器后：

``` text
本地收藏
本地歌单
播放历史
已下载文件
```

默认不能静默删除。

如果某些数据将变成"无法在线解析"，UI 应说明。

------------------------------------------------------------------------

## 1T.22 搜索体验

搜索框进入页面后应立即可输入。

支持：

``` text
最近搜索
清除历史
歌曲
专辑
艺术家
```

无结果时：

``` text
没有找到“xxx”
```

并给简单建议。

禁止无结果时只显示空白。

------------------------------------------------------------------------

## 1T.23 大音乐库用户

对于几万首音乐：

``` text
快速首屏
分页
保持滚动位置
快速搜索
```

比"漂亮的复杂动画"优先。

用户滚动专辑列表后进入详情再返回，必须尽量回到原位置。

------------------------------------------------------------------------

## 1T.24 老年/非技术用户

核心流程：

``` text
字号放大后仍可操作
按钮有文字或明确图标
错误不用技术术语
主要操作点击区域足够
```

播放不能依赖：

``` text
只有手势
只有长按
只有颜色
```

------------------------------------------------------------------------

## 1T.25 蓝牙 / 车载用户

用户预期：

``` text
耳机播放键能控制
车载上一首/下一首能工作
锁屏信息正确
来电/语音打断后行为合理
蓝牙断开不会突然扬声器外放
```

这些全部纳入 P0 真机验收，而不是"高级兼容"。

------------------------------------------------------------------------

## 1T.26 不打扰原则

SoundIsle 不应该频繁：

``` text
Toast
弹窗
确认
权限请求
升级提示
```

权限在真正需要时请求，并解释用途。

例如：

``` text
第一次真正需要后台播放/系统媒体能力时
```

按照 HarmonyOS 实际权限模型正确处理。

------------------------------------------------------------------------

## 1T.27 首次设置不超过必要步骤

普通用户否决"首次启动向导十几页"。

首次只完成：

``` text
连接服务器
```

其他：

``` text
主题
音质
下载策略
歌词样式
同步收藏
```

使用默认值，之后在设置中修改。

------------------------------------------------------------------------

## 1T.28 默认值委员会

默认值必须让"不改设置的人"也能长期正常使用。

推荐原则：

``` text
主题：跟随系统
自动播放：关闭
重启自动发声：关闭
Wi-Fi 音质：原始
移动网络：保护流量的合理默认
下载网络：Wi-Fi 优先
缓存：自动管理
收藏：本地可靠保存
服务器同步：可选
错误日志上传：关闭
```

具体移动网络默认码率在真实测试后冻结。

------------------------------------------------------------------------

## 1T.29 用户隐私

普通用户不应该需要注册 SoundIsle 云账号才能播放自己的 Navidrome。

V1 原则：

``` text
无 SoundIsle 强制账号
无强制云同步
无默认遥测上传
```

如未来加入诊断上传：

``` text
用户主动选择
+
明确说明内容
+
脱敏
```

------------------------------------------------------------------------

## 1T.30 更新不能破坏"昨天还能听"

普通用户不会理解数据库 Migration。

他们只关心：

``` text
更新后服务器还在
下载还在
收藏还在
歌单还在
历史还在
设置还在
```

因此用户数据升级保护继续保持 Release Gate。

------------------------------------------------------------------------

## 1T.31 普通用户可见的服务器状态

状态只需要：

``` text
已连接
正在连接
离线
需要重新登录
```

高级诊断才显示：

``` text
latency
protocol
extension
serverVersion
```

------------------------------------------------------------------------

## 1T.32 空状态必须能继续行动

例如：

### 没有收藏

``` text
还没有收藏的音乐
听到喜欢的歌曲时点一下 ♡

[去音乐库]
```

### 没有下载

``` text
还没有下载音乐
下载后即使没有网络也能播放

[去音乐库]
```

### 没有服务器

``` text
连接你的音乐服务开始听歌

[添加音乐服务]
```

------------------------------------------------------------------------

## 1T.33 用户可撤销操作

适合撤销而不是弹确认的操作：

``` text
从队列移除
取消收藏
部分列表操作
```

例如：

``` text
已从队列移除    [撤销]
```

降低弹窗数量。

------------------------------------------------------------------------

## 1T.34 "高级设置"隔离

以下内容统一放高级设置：

``` text
Transcode format
Max bitrate exact value
Route preference
TLS details
API capability
Server extensions
Audio diagnostics
Cache internals
Developer options
```

默认用户不需要看到。

------------------------------------------------------------------------

## 1T.35 用户帮助

不制作厚重说明书作为使用前提。

App 内提供短帮助：

``` text
怎么连接 Navidrome？
为什么无法连接？
为什么这首歌被转码？
怎么下载音乐？
下载和缓存有什么区别？
```

每篇只解决一个问题。

------------------------------------------------------------------------

## 1T.36 用户体验验收任务

从 M2 开始，每个里程碑增加：

``` text
USER_ACCEPTANCE_REQUIRED
```

最低人工任务：

``` text
不给测试者解释架构
只告诉他：
“这是连接 Navidrome 听歌的软件。”

观察他能否：
1. 添加服务器
2. 找到一首歌
3. 播放
4. 找到队列
5. 收藏
6. 下载
7. 找到离线歌曲
```

测试者如果频繁问：

``` text
“这个是什么意思？”
“下一步点哪里？”
“这个会不会把服务器歌曲删掉？”
```

即使功能没有 Bug，也必须记录 UX 缺陷。

------------------------------------------------------------------------

## 1T.37 用户成功指标

V1 不以 DAU 等商业指标作为开发 Gate。

首要产品指标：

``` text
连接成功率
首次播放成功率
点击播放到出声时间
播放错误率
后台异常中断率
下载成功率
崩溃率
用户数据丢失 = 0
```

如果没有遥测上传，则这些指标通过测试环境、本地诊断和用户反馈评估。

------------------------------------------------------------------------

## 1T.38 普通用户提出的十个"必须简单"

最终冻结：

``` text
1. 添加 Navidrome 要简单
2. 点歌就播放
3. 返回页面不能停歌
4. 锁屏还能控制
5. 蓝牙要正常
6. 下载后没网能听
7. 清缓存不能删下载
8. App 重启队列不能没了
9. 报错要看得懂
10. 不懂技术也不用进高级设置
```

这十条优先级高于大多数 P2 功能。

------------------------------------------------------------------------

## 1T.39 对原架构委员会的修订

本轮普通用户参与后，正式修改以下产品决策：

``` text
原：本地收藏 / 服务器收藏在 UI 中明确双入口
改：默认一个收藏入口，本地立即保存，服务器同步可选

原：本地歌单 / 服务器歌单强调双体系
改：普通流程默认 SoundIsle 歌单，服务器操作放同步/高级路径

原：服务器配置可以展示大量 Capability
改：普通页面只显示简单连接状态，Capability 进入高级诊断

原：音质设置偏技术参数
改：普通设置先使用“原始/高/标准/省流量”，精确参数进入高级设置

原：产品成功主要由工程 Gate 定义
改：增加 USER_ACCEPTANCE_REQUIRED，人能顺利用才算完成
```

------------------------------------------------------------------------

## 1T.40 用户委员会最终结论

**APPROVED WITH USER EXPERIENCE GATES**

普通用户一致认为：

> SoundIsle
> 可以功能很多，但使用时应该让人感觉它只是一个非常简单、可靠的音乐播放器。

产品最终体验目标冻结为：

``` text
第一次
5 分钟内连接并开始播放

以后
打开就能听

出问题
看得懂怎么解决

离线
知道哪些还能听

高级能力
需要时才出现
```

技术复杂度必须由 SoundIsle 自己承担，而不是转嫁给用户。

## 1U. 多维度 / 多用户 / 多角色联合产品复审

### 1U.1 评审方法升级

从 V10 开始，SoundIsle 的产品决策不得只从"功能是否存在"判断。

每个重要功能至少从六个维度复审：

``` text
用户价值
易用性
技术可行性
稳定性
数据安全
长期维护成本
```

涉及播放的功能再增加：

``` text
音频质量
后台行为
网络适应性
功耗
设备兼容性
```

涉及服务器的功能再增加：

``` text
协议兼容
服务器版本差异
失败降级
隐私
```

### 1U.2 用户角色矩阵

正式建立 Persona Matrix。

#### A. 普通用户

目标：

``` text
连接服务器
找到音乐
点击播放
```

最怕：

``` text
设置复杂
错误看不懂
按钮太多
```

#### B. 重度音乐用户

目标：

``` text
大量音乐快速浏览
专辑连续播放
稳定队列
高频搜索
收藏/歌单管理
```

最怕：

``` text
大库卡顿
队列混乱
返回丢位置
```

#### C. 音质 / 发烧用户

关注：

``` text
Original
Codec
Bitrate
Sample Rate
Bit Depth
ReplayGain
Gapless
Transcode
```

原则：

> 普通 UI 保持简单，但高级用户必须能看到真实音频信息和控制策略。

不得为了"简单"删除专业能力，只能把专业能力放到合适层级。

#### D. NAS / 自托管用户

关注：

``` text
Navidrome
内网地址
公网地址
反向代理
HTTPS
HTTP LAN
多线路
自签名证书问题
```

要求：

``` text
技术能力完整
但默认流程不技术化
```

#### E. 离线用户

关注：

``` text
下载可靠
断网可听
下载不会被缓存清理
```

#### F. 移动网络用户

关注：

``` text
流量
弱网
网络切换
转码
```

#### G. 蓝牙 / 车载用户

关注：

``` text
耳机按钮
车载控制
锁屏
来电打断
蓝牙断开
```

#### H. 大音乐库用户

关注：

``` text
10k / 50k+ songs
分页
搜索
滚动性能
缓存
```

#### I. 非技术 / 年长用户

关注：

``` text
大字体
明确文案
简单路径
可预测行为
```

#### J. 多服务器用户

关注：

``` text
多个 Navidrome / 其他 Provider
服务器切换
数据隔离
下载归属
```

#### K. 隐私敏感用户

关注：

``` text
无强制账号
无默认遥测
凭证安全
本地数据可控
```

#### L. 开发者 / 问题排查用户

关注：

``` text
诊断日志
Capability
音频信息
服务器版本
错误详情
```

这些能力进入 Developer / Advanced，不进入普通流程。

------------------------------------------------------------------------

## 1U.3 重度音乐用户评审：队列

重度用户认为队列是播放器核心，而不是附属弹窗。

队列必须可靠支持：

``` text
立即播放
下一首播放
添加到队列
拖动排序
删除
清空
恢复
随机顺序
```

高级但高价值：

``` text
保存当前队列为歌单
查看播放来源
快速跳到当前歌曲
```

V1 可以分阶段实现，但数据结构必须支持。

------------------------------------------------------------------------

## 1U.4 发烧友评审：无损不能只是 Logo

如果 UI 显示：

``` text
Lossless
Hi-Res
Original
```

必须来自真实播放源信息。

禁止：

``` text
源文件是 FLAC
→ 无条件显示“当前无损”
```

因为实际播放可能已经被服务器转码。

真实显示应基于当前 `AudioSource`：

``` text
Original / Transcoded
Codec
Bitrate
Sample Rate
Bit Depth
Channels
```

无法获得的数据不猜测。

------------------------------------------------------------------------

## 1U.5 发烧友评审：音质详情

完整播放器提供可选：

``` text
音频信息
```

普通用户看到简化标签：

``` text
原始音质
高音质
```

高级用户展开后看到：

``` text
FLAC
24-bit
96 kHz
2 ch
2.8 Mbps
Original
Navidrome
```

转码时明确：

``` text
AAC 256 kbps
Transcoded from FLAC
```

------------------------------------------------------------------------

## 1U.6 发烧友 × 音频专家：Gapless

专辑用户最在意连续专辑：

``` text
Live
Classical
Concept Album
DJ Mix
```

因此 Gapless 保留高优先级。

但继续遵守：

``` text
不虚假宣传 Sample-Accurate
```

必须使用真实连续测试素材验证。

如果平台只能做到 Best Effort：

``` text
产品文案明确
```

------------------------------------------------------------------------

## 1U.7 ReplayGain 用户体验

普通用户设置可以：

``` text
音量均衡
```

高级设置：

``` text
关闭
Track Gain
Album Gain
Preamp
防削波
```

实现未达到正确音频语义前，不显示正式开关。

------------------------------------------------------------------------

## 1U.8 专辑型用户

Album 页面必须尊重"听专辑"的用户。

提供：

``` text
按曲序播放
从某一首开始继续按专辑顺序
随机播放
加入队列
下载专辑
收藏
```

Disc Number / Track Number 必须正确排序。

不能只按歌曲名称排序。

------------------------------------------------------------------------

## 1U.9 古典音乐用户

数据模型不得只假设：

``` text
Artist + Album + Song
```

应为未来兼容：

``` text
Album Artist
Composer
Disc Number
Track Number
Year
Genre
```

预留字段。

V1 UI 不要求复杂古典音乐数据库，但不得在 Mapper 中把这些信息永久丢弃。

------------------------------------------------------------------------

## 1U.10 多语言音乐库

必须正确处理：

``` text
中文
英文
日文
韩文
Emoji
混合字符
```

排序、搜索和 UI 截断不能导致崩溃。

不得假设 Metadata 为 ASCII。

------------------------------------------------------------------------

## 1U.11 NAS 用户：双线路

允许 ServerProfile 存：

``` text
Primary URL
LAN URL
Alternative URL
```

默认自动选择策略：

``` text
可用
+
安全
+
响应合理
```

高级用户可以固定线路。

线路切换不得改变：

``` text
serverId
MediaKey
本地收藏归属
下载归属
```

------------------------------------------------------------------------

## 1U.12 自签名证书争议

安全负责人：

``` text
不能默认忽略 TLS 错误
```

NAS 用户：

``` text
部分家庭环境确实存在自签名证书
```

最终决议：

``` text
默认严格 TLS
```

高级设置未来可以提供经过明确风险说明的受控方案，但不得实现：

``` text
全局 Trust All Certificates
```

------------------------------------------------------------------------

## 1U.13 多服务器用户：数据命名空间

所有用户数据必须明确是否：

``` text
Global
Server Scoped
Media Scoped
```

例如：

``` text
Theme
→ Global

ServerProfile
→ Server Scoped

Favorite(MediaKey)
→ Media Scoped

Download(MediaKey)
→ Media Scoped
```

避免服务器 A 的 `songId=1` 与服务器 B 冲突。

------------------------------------------------------------------------

## 1U.14 多服务器用户：统一首页

V1：

``` text
一个 Active Server
```

首页展示当前服务器内容。

不急于做：

``` text
所有服务器混合首页
```

因为会引入：

``` text
去重
搜索聚合
来源选择
延迟差异
```

后续再做。

------------------------------------------------------------------------

## 1U.15 隐私用户评审

默认：

``` text
无 SoundIsle 账号
无广告 SDK
无行为追踪 SDK
无默认云同步
无默认诊断上传
```

如果未来加入任何网络服务：

``` text
明确目的
明确数据
用户选择
```

------------------------------------------------------------------------

## 1U.16 电量敏感用户

长时间播放时：

``` text
屏幕关闭
→ UI 动画停止
→ 不必要 Timer 降频/停止
→ 网络健康检查降频
```

不能为了"实时"每秒：

``` text
写数据库
刷新封面
请求服务器
```

------------------------------------------------------------------------

## 1U.17 低存储用户

提供：

``` text
缓存占用
下载占用
清缓存
管理下载
```

存储空间不足时：

``` text
下载前/过程中提示
```

禁止自动删除用户下载来腾空间。

------------------------------------------------------------------------

## 1U.18 网络差用户

弱网时优先：

``` text
继续已有 Buffer
```

而不是网络状态一变化就重新播放。

长时间无法恢复时：

``` text
尝试重新连接
→ 必要时切线路
→ 必要时转码
→ 明确失败
```

------------------------------------------------------------------------

## 1U.19 车载安全视角

车载/驾驶场景不设计复杂"驾驶模式"作为 V1
阻塞项，但核心控制必须适合外部设备：

``` text
Play/Pause
Previous
Next
Metadata
```

手机 UI 不鼓励驾驶中复杂操作。

------------------------------------------------------------------------

## 1U.20 无障碍用户

除大字体外，增加：

``` text
屏幕阅读语义
按钮状态语义
播放/暂停状态可读
收藏状态可读
下载进度可读
```

不能只用图标视觉表达状态。

------------------------------------------------------------------------

## 1U.21 新手与专家双层界面

最终采用：

``` text
Simple by Default
Powerful when Expanded
```

普通层：

``` text
播放
收藏
下载
歌单
歌词
音质
```

高级层：

``` text
Codec
Bitrate
Transcode
Route
ReplayGain
Server Capability
Diagnostics
```

不是删掉高级功能，而是分层。

------------------------------------------------------------------------

## 1U.22 客服 / 维护视角

用户报告：

``` text
“这首歌播不了”
```

App 应允许导出脱敏诊断包。

内容可以包括：

``` text
App version
HarmonyOS version
Server type/version
Capability summary
Audio format
Transcode status
Playback state transitions
Error category
```

必须删除：

``` text
password
token
apiKey
authorization
私人完整 URL 参数
```

------------------------------------------------------------------------

## 1U.23 开源维护者视角

Provider 接口必须让社区未来可以相对独立贡献：

``` text
JellyfinProvider
PlexProvider
...
```

贡献者不应该为了增加 Provider 修改 Player UI 核心。

要求：

``` text
Provider Contract
Fixtures
Contract Tests
Capability Definition
```

------------------------------------------------------------------------

## 1U.24 安全视角

重点威胁模型：

``` text
凭证泄漏
日志泄漏
恶意/被攻陷服务器返回异常数据
恶意重定向
下载路径问题
不可信 Metadata
超大图片
异常 JSON
```

所有 Remote Data 均视为不可信输入。

------------------------------------------------------------------------

## 1U.25 QA 视角：Persona 场景测试

TEST_PLAN 必须按 Persona 增加场景：

``` text
普通用户首次连接
发烧友 Original/Transcode
NAS HTTP LAN
弱网用户
离线用户
蓝牙用户
大库用户
大字体用户
多服务器用户
```

不能只有"功能按钮测试"。

------------------------------------------------------------------------

## 1U.26 产品经理：功能价值评分

新增功能进入 Roadmap 前评分：

``` text
User Value      0-5
User Reach      0-5
Core Fit        0-5
Complexity      0-5
Risk            0-5
Maintenance     0-5
```

优先：

``` text
高价值
高覆盖
符合播放器核心
复杂度可控
```

例如：

``` text
后台稳定
> 动态背景特效

下载可靠
> 可视化频谱

队列可靠
> 社交分享模板
```

------------------------------------------------------------------------

## 1U.27 "功能很多"不等于"不比音流差"

竞品对标改为四层：

``` text
Feature Exists
Feature Works
Feature Is Reliable
Feature Is Pleasant
```

只有：

``` text
Reliable
或
Pleasant
```

才算真正达到对标水平。

一个有按钮但经常失败的功能不计入完成。

------------------------------------------------------------------------

## 1U.28 体验债务

除 Technical Debt 外建立：

``` text
UX Debt
```

例如：

``` text
错误提示暂时技术化
某页面返回丢滚动位置
下载状态不够清晰
设置名称难懂
```

进入 `PROJECT_STATUS.md`，不能因为"没有代码 Bug"永久忽略。

------------------------------------------------------------------------

## 1U.29 性能预算视角

每个功能要考虑：

``` text
启动
内存
CPU
网络
存储
电量
```

尤其禁止：

``` text
为了首页漂亮
→ 一次请求几十个模块
→ 同时解码大量高清封面
```

首页采用渐进加载。

------------------------------------------------------------------------

## 1U.30 失败设计

每个功能设计时必须回答：

``` text
成功时怎样？
加载时怎样？
没数据怎样？
失败时怎样？
断网怎样？
重试怎样？
```

没有 Failure UX 的功能定义不完整。

------------------------------------------------------------------------

## 1U.31 数据生命周期

每类数据必须标记：

``` text
Authority
Persistence
TTL
Deletion Rule
Backup Importance
```

例如：

``` text
Remote Album Metadata
Authority: Server
Persistence: Cache
TTL: Yes
Deletion: Auto
Backup: No

Local Playlist
Authority: Local
Persistence: Durable
TTL: No
Deletion: User only
Backup Importance: High
```

------------------------------------------------------------------------

## 1U.32 "删服务器"跨角色最终决议

移除 ServerProfile 时默认：

``` text
删除凭证
删除该服务器 Remote Cache
停止相关网络任务
```

但：

``` text
Local Playlist
Favorite
History
Download
```

不得直接静默删除。

产品必须询问或保留为可恢复/孤立数据，并明确告诉用户影响。

------------------------------------------------------------------------

## 1U.33 极端用户行为

测试：

``` text
连续狂点播放
连续切服务器
连续 Seek
快速前后台
网络反复开关
下载中杀 App
播放中移除服务器
缓存清理同时播放
```

系统必须：

``` text
不崩
不串状态
不丢用户数据
```

------------------------------------------------------------------------

## 1U.34 版本升级用户

每次重大升级必须从用户角度回答：

``` text
我的服务器还在吗？
我的下载还在吗？
我的歌单还在吗？
我的收藏还在吗？
我的设置变了吗？
```

Release Notes 用用户语言说明变化。

------------------------------------------------------------------------

## 1U.35 产品成功的四层模型

SoundIsle V1 成功不是：

``` text
Build 成功
```

而是：

``` text
L1 Functional
能用

L2 Reliable
稳定

L3 Understandable
不用学

L4 Delightful
愿意长期用
```

V1 发布最低要求：

``` text
P0 功能达到 L2
核心黄金路径达到 L3
播放器关键体验争取 L4
```

------------------------------------------------------------------------

## 1U.36 多角色冲突裁决原则

当角色意见冲突：

### 安全 vs 便利

``` text
安全底线不可破
→ 在底线内优化便利
```

### 发烧友 vs 普通用户

``` text
功能保留
→ UI 分层
```

### 架构完美 vs 交付

``` text
满足扩展性
→ 不提前实现
```

### 功能数量 vs 稳定

``` text
稳定优先
```

### 云端同步 vs 本地可靠

``` text
本地用户数据优先不丢
```

### 自动化 vs 真机现实

``` text
自动化尽可能多
→ 真机不可替代的明确留 Gate
```

------------------------------------------------------------------------

## 1U.37 最终产品北极星

所有角色共同冻结 SoundIsle 的产品北极星：

> **让拥有自己音乐服务器的人，在 HarmonyOS
> 上以最少配置、最稳定的方式听自己的音乐；普通用户觉得简单，重度用户觉得高效，发烧友能看到真实音频能力，自托管用户拥有足够控制权。**

后续任何新功能都必须回答：

``` text
它是否让这个目标变得更好？
```

如果答案不明确：

``` text
进入 Backlog
```

而不是立即开发。

------------------------------------------------------------------------

## 1U.38 V10 联合结论

经过：

``` text
普通用户
重度用户
发烧用户
NAS 用户
离线用户
移动网络用户
蓝牙/车载用户
大库用户
非技术用户
多服务器用户
隐私用户
开发者

+

项目经理
HarmonyOS 架构师
ArkTS 架构师
音频专家
业务架构师
API 架构师
UI/UX
QA
安全
DevOps
开源维护
```

交叉审查后：

**APPROVED FOR DOCUMENT SPLIT AND M0 IMPLEMENTATION**

从此阶段开始不再通过无限增加 MASTER_PLAN 内容提高质量。

下一阶段质量提升方式改为：

``` text
拆文档
→ 建任务
→ 实现
→ 测试
→ 用户验证
→ 发现问题
→ ADR / Backlog 修正
```

真实实现和真实用户反馈将成为下一阶段主要证据。

## 1V. 15 轮循环评审最终收敛

本节记录 SoundIsle 围绕"完整播放链"进行的 15
轮连续循环评审。目标不是让所有角色都满意，而是在普通用户、重度用户、发烧友、NAS
用户、HarmonyOS、ArkTS、音频、API、QA、安全和项目交付之间取得可实现的最优平衡。

统一状态：

``` text
KEEP       坚持
CHANGE     推翻旧方案并修改
COMPROMISE 有条件妥协
DEFER      延后
REJECT     否决
VERIFY     必须真实验证
```

### Round 1 --- 理想播放链

形成初始方案：

``` text
点击歌曲
→ 建立播放上下文
→ Resolve 播放源
→ Prepare
→ Playing
→ Queue / Seek / Background / AVSession
→ 弱网恢复
→ 状态持久化
```

结论：播放器独立于页面；PlaybackResolver 与 QueueManager
保留；旧异步请求不得覆盖新请求；蓝牙意外断开暂停；App
重启恢复队列但不自动出声；Gapless 不得拖死 V1。

### Round 2 --- 反方架构攻击

推翻"专辑点第 N 首后只保留 N→末尾"，改为完整专辑进入
Queue，`currentIndex` 指向用户点击位置。

推翻"下载永远优先"，改为离线时优先下载；在线时由 PlaybackPolicy
判断下载版本是否满足当前音质策略。

推翻"NetworkChanged 立即重新选源"，改为只有当前媒体请求真正失败时才重新
Resolve。

把大量 PlaybackContext 类型简化为：

``` text
QueueSeed + Origin
```

### Round 3 --- 极端竞态攻击

新增并冻结：

``` text
PlaybackGeneration
Cancellation / Stale Result Guard
PendingSeek
UserPlaybackIntent
PlaybackInhibitor
Engine Command Serialization
```

拒绝自研复杂 Actor Framework、事件溯源播放器和巨型全局 Redux。

### Round 4 --- 弱网 / 断网 / LAN-WAN / URL 失效

最终恢复链：

``` text
继续消费已有 Buffer
→ 等真实读取失败
→ 记录 position
→ Resolve 新 Route
→ 按当前 NetworkPolicy 决定 Original/Transcode
→ Prepare
→ Seek
→ 按 UserPlaybackIntent 恢复
```

硬规则：

``` text
网络变化本身不打断现有播放
Route 切换不改变 MediaKey
恢复时重新 Resolve URL
有限重试
禁止无限重试
禁止播放前强制测速
```

移动数据：

``` text
Auto
→ 只有需要重新建流时才按新网络策略调整音质

Always Original
→ 不自动降质

Data Saver
→ 恢复时优先转码
```

### Round 5 --- 后台 / 锁屏 / 蓝牙 / 车载 / 打断

坚持：

``` text
AVSession 是系统投影
PlayerStateStore 是唯一播放状态源
后台播放属于 P0
蓝牙意外断开暂停
用户主动暂停优先于系统自动恢复
```

自动恢复只有在：

``` text
UserPlaybackIntent == PLAY
AND 系统允许恢复
AND 无阻塞 PlaybackInhibitor
```

车载仅保证 Play/Pause/Prev/Next/Metadata；专用驾驶 UI 延后。

### Round 6 --- 普通用户复审

否决：

``` text
播放前询问线路
播放前询问 Codec
播放前询问转码
默认展示技术错误
```

用户点歌只需看到：

``` text
正在准备
正在播放
正在缓冲
正在重新连接
播放失败
```

高级信息进入折叠详情。

### Round 7 --- 重度音乐用户复审

坚持：

``` text
完整队列
Play Next
Add to Queue
拖动排序
Queue Persistence
Shuffle History
返回列表位置
```

"保存当前队列为歌单"保留为高价值能力，但不阻塞 V1。

拒绝 V1 实现动态无限远程 Queue；搜索"播放全部"只使用当前已加载结果。

### Round 8 --- 发烧友 / Gapless / ReplayGain

保留真实 AudioSource 信息和 Original/Transcoded 区分。

Gapless：

``` text
P0 基础切歌稳定
P1 Best-effort Gapless
VERIFY Sample-Accurate Gapless
```

未验证不得宣传"完美无缝"。

ReplayGain 必须正确支持
Gain/Peak/Preamp/防削波后才能正式开放；否则延后。

Crossfade 延后到基础播放稳定之后，且默认不与连续专辑 Gapless 混用。

### Round 9 --- Navidrome / OpenSubsonic

Navidrome / OpenSubsonic 固定为 V1 First-Class。

坚持：

``` text
ID 为 string
DTO → Mapper → Domain
ID3 音乐库接口优先
stream URL 实时 Resolve
Remote Metadata 以服务器为权威
本地用户状态以客户端为权威
```

收藏最终采用一个按钮：

``` text
本地立即保存
→ 服务器同步可选
```

本地 QueueManager 永远是实时队列权威；服务器 PlayQueue 仅可选同步。

### Round 10 --- HarmonyOS / ArkTS 可行性反审

第一播放实现：

``` text
AVPlayer
+ AVSession
+ Background Tasks
+ 音频打断处理
```

ArkTS 坚持强类型、DTO/Domain 分离、Composition Root、Constructor
Injection。

否决：

``` text
AppStorage 当业务数据库
所有任务都进 Worker/TaskPool
页面自行 new Player/Repository/Provider
```

### Round 11 --- 大音乐库 / 性能 / 功耗

测试规模：

``` text
1k
10k
50k+
```

坚持 API First + Pagination、Lazy Rendering、封面尺寸优化和缓存分层。

否决启动全量同步和首页一次并发几十个模块。

播放位置在内存中高频更新，但本地持久化采用节流
checkpoint；禁止每秒写数据库。

真实 Baseline 追踪 Tap-to-Audio、Cold Start、2h Memory Delta、后台
CPU/功耗，不拍脑袋写绝对性能数字。

### Round 12 --- 下载 / 离线 / 本地数据恢复

严格区分：

``` text
Cache = 可删除、可重建
Download = 用户资产
```

Release Gate：

``` text
清缓存不能删除下载
清缓存不能删除本地收藏/歌单/历史
下载完成要验证文件
离线能播放已下载
下载状态可跨 App 重启恢复
```

移除服务器默认删除凭证、Remote Cache
和相关任务，但不静默删除本地收藏、歌单、历史、下载。

### Round 13 --- 安全 / 隐私 / 升级

坚持凭证安全存储、日志脱敏、无强制 SoundIsle
账号、无默认遥测上传、默认严格 TLS。

妥协：

``` text
HTTP 私有 LAN
→ 允许 + 明确未加密提示

HTTP 公网
→ 强警告
```

否决 Trust All Certificates 和跨 Host 重定向无条件携带认证。

Beta 后用户数据 Migration 属于 Release Gate。

### Round 14 --- QA 红队

组合攻击：

``` text
播放 A
→ 快速 B/C
→ Preparing 时 Seek
→ 网络切换
→ 蓝牙断开
→ 后台
→ URL 失效
→ 下载任务完成
→ App 被系统回收
```

必须保证：

``` text
不崩
不串歌
不误自动播放
不丢队列
不丢本地用户数据
不无限恢复
```

新增 Stop-Ship：

``` text
旧播放请求覆盖当前媒体
播放器状态与声音长期不一致
意外扬声器外放
后台核心场景失败
下载/缓存边界错误
```

### Round 15 --- 全角色最终妥协

#### KEEP

``` text
Navidrome/OpenSubsonic First-Class
Playback-centric
播放器独立于页面
PlayerStateStore 单一状态源
QueueManager 本地权威
PlaybackResolver
UserPlaybackIntent
PlaybackGeneration + Cancellation
后台/锁屏/蓝牙 P0
本地用户数据可靠
下载与缓存隔离
凭证安全
错误可理解
```

#### COMPROMISE

``` text
Wi-Fi 默认 Original，但不做播放前测速
移动网络按 Policy，不因网络变化强制打断
搜索播放全部仅使用当前已加载结果
高级音频功能保留，但证据化后开放
一个收藏入口，本地优先，服务器同步可选
简单 UI + 高级设置分层
```

#### CHANGE

``` text
下载永远优先
→ 满足 PlaybackPolicy 才优先

专辑从点击位置截断 Queue
→ 完整上下文 Queue + currentIndex

PauseReason 作为恢复权威
→ UserPlaybackIntent + PlaybackInhibitor

NetworkChanged 立即重建流
→ 真实失败后才恢复
```

#### DEFER

``` text
Sample-Accurate Gapless（未验证前）
Crossfade
复杂多服务器统一首页
跨服务器自动去重
动态无限远程 Queue
WebDAV
专用驾驶模式
复杂 DSP
```

#### REJECT

``` text
全量音乐库镜像
巨型 Sync Engine
万能 EventBus
巨型 MusicManager
所有操作一个 UseCase Class
所有任务进 Worker
播放前测速
每次播放询问技术参数
Trust All Certificates
未验证的 Hi-Res / Lossless / Perfect Gapless 宣传
```

#### VERIFY

``` text
HarmonyOS 真机后台
AVSession/锁屏
蓝牙/车载控制
长时间播放
Gapless 实际等级
ReplayGain 正确性
格式兼容矩阵
Tap-to-Audio
移动网络恢复体验
功耗
```

### 1V.1 最终播放链

``` text
用户点击歌曲
↓
构建 QueueSeed + Origin
↓
UserPlaybackIntent = PLAY
↓
生成新的 PlaybackGeneration
↓
PlaybackResolver
  ├─ 检查可用本地下载
  ├─ 应用 Quality Policy
  ├─ 选择 Server Route
  └─ 获取 AudioSource
↓
PlaybackEngine Prepare
↓
PlayerStateStore
↓
Playing
↓
ArkUI + AVSession
```

异常恢复：

``` text
Buffering / Error
↓
PlaybackRecovery
↓
继续已有 Buffer（可行时）
↓
刷新 AudioSource
↓
切 Route
↓
必要时 Transcode
↓
恢复 Position
↓
仅在 UserPlaybackIntent 仍为 PLAY 时继续
```

### 1V.2 最终架构收敛

``` text
Presentation
├── Pages
├── Components
├── ViewModels
└── UI State

Domain
├── Media Models
├── Repository Contracts
├── Playback Policy
└── 少量真正有业务价值的 UseCases

Data
├── Repositories
├── Local DataSources
├── Remote DataSources
└── Cache

Providers
└── OpenSubsonicProvider (V1 first-class)

Playback
├── PlayerController
├── PlayerStateStore
├── QueueManager
├── PlaybackResolver
├── PlaybackRecovery
├── PlaybackEngine
└── AVSession Adapter

Infrastructure
├── NetworkClient
├── ArkData/RDB
├── Preferences
├── SecureStorage
├── FileStorage
├── Logger
└── TaskScheduler
```

### 1V.3 发布范围

``` text
V1.0
Navidrome / OpenSubsonic First-Class

1.1+
Jellyfin / Emby / AudioStation / Plex
逐个提升为 First-Class
```

其他 Provider 未真实验证时允许标记 BETA /
IMPLEMENTED_UNVERIFIED，不得阻塞成熟 Navidrome 版本发布。

### 1V.4 最终结论

**CONVERGED / APPROVED FOR M0**

继续靠文档推演已经无法显著降低主要风险。剩余问题必须由真实代码、真实
Navidrome、HarmonyOS 真机、长时间播放和真实用户测试解决。


## 1W. V13 深度红队循环补强

V13 在 V12 的基础上追加 15 轮模拟多模型风格红队审查，累计形成 25 轮循环。重点不再重复播放链，而是攻击长期维护、数据生命周期、下载、缓存、迁移、Provider 扩展、安全、可访问性、国际化和发布工程。

### Cycle 11 — Provider 扩展性攻击
问题：不同 Provider 可能逐渐把 UI 和 Player 绑死。

修正：
- 新增 `PROVIDER_CONTRACT.md`。
- Provider 必须只通过统一 Domain/Capability 合同暴露功能。
- UI 不允许 `if provider == Navidrome` 处理核心逻辑。
- Provider 专属 workaround 必须隔离。

### Cycle 12 — 下载状态机攻击
问题：原文只有下载原则，没有完整状态和并发/恢复策略。

修正：
- 新增 `DOWNLOAD_ARCHITECTURE.md`。
- 明确 QUEUED / RUNNING / PAUSED / VERIFYING / COMPLETED / FAILED / CANCELED。
- 临时文件与最终文件分离。
- App 重启后任务可恢复。
- 存储不足时禁止自动删除用户下载。

### Cycle 13 — 缓存淘汰攻击
问题：Cache“可删除”过于宽泛，可能导致正在播放资源被回收。

修正：
- 新增 `CACHE_POLICY.md`。
- 缓存类型、TTL、LRU、pinning、播放中保护、容量上限分开定义。

### Cycle 14 — 数据迁移/回滚攻击
问题：Migration 有要求，但没有失败/中断后的恢复策略。

修正：
- 新增 `MIGRATION_STRATEGY.md`。
- Migration 必须具备事务边界、版本检查、失败保留旧数据、禁止静默 drop。
- 升级前后验证关键数据数量。

### Cycle 15 — 设置系统攻击
问题：设置分散，未来容易出现旧版本字段失效、默认值漂移。

修正：
- 新增 `SETTINGS_MODEL.md`。
- 设置必须有 key、类型、默认值、作用域、迁移策略。
- 播放/网络/下载设置的默认值集中定义。

### Cycle 16 — SSRF / 路径攻击
问题：私人 NAS 客户端允许 LAN，常规“禁止私网地址”的 SSRF 方案不适用。

修正：
- 新增 `SECURITY.md`。
- 用户主动配置的服务器地址允许 LAN。
- 第三方歌词/Metadata Provider 不得继承服务器认证。
- 下载路径禁止目录穿越。
- 跨 Host 重定向剥离敏感 Header。

### Cycle 17 — 日志/诊断攻击
问题：日志类别有了，但缺少可导出诊断包结构。

修正：
- 新增 `OBSERVABILITY.md`。
- 本地事件、correlation ID、脱敏字段、导出包内容、默认不上报全部明确。

### Cycle 18 — i18n / 文案攻击
问题：项目面向中文用户，但 Metadata 与错误信息可能多语言。

修正：
- 新增 `I18N_ACCESSIBILITY.md`。
- UI 文案不得硬编码在业务逻辑。
- Unicode/RTL/大字体/屏幕阅读器都进入设计约束。
- Metadata 保留原始字符。

### Cycle 19 — 本地数据“孤儿化”攻击
问题：服务器被删除或远程媒体消失后，本地收藏/歌单/历史会成为孤立数据。

修正：
- 明确 Orphaned Media 语义。
- 本地数据保留快照用于展示。
- 允许用户清理孤立项，但默认不静默删除。

### Cycle 20 — Artwork / 内存攻击
问题：高分辨率封面可能导致内存峰值和滚动卡顿。

修正：
- 列表只请求目标尺寸。
- 解码尺寸必须贴合组件。
- 原图仅在必要页面获取。
- 缓存 key 含尺寸和服务器。

### Cycle 21 — API Fuzz / 不可信数据攻击
问题：远程 Metadata 可能超长、缺字段、异常字符、恶意尺寸。

修正：
- DTO parser defensive。
- 对超大响应、超长字符串、非法数字做边界检查。
- Provider contract test 增加 fuzz/异常 fixture。

### Cycle 22 — Release 可复现攻击
问题：构建能成功一次，不等于别人可以复现。

修正：
- 新增 `RELEASE_GATES.md`。
- RC 必须从干净工作区构建。
- 记录 SDK/Hvigor/ohpm/commit SHA。
- Release Notes 必须说明 VERIFY 项和 Beta Provider 状态。

### Cycle 23 — 多 AI 文档漂移攻击
问题：AI 改了实现却不更新规范，会造成文档逐渐失真。

修正：
- 每个影响架构/数据模型/状态机的改动必须同步规范或 ADR。
- `PROJECT_STATUS.md` 记录文档同步状态。
- CI 可加入文档引用完整性检查。

### Cycle 24 — 用户备份/恢复攻击
问题：本地收藏/歌单/设置属于用户资产，但还没有备份语义。

修正：
- V1 预留本地导出/导入格式。
- 敏感凭证默认不明文导出。
- 下载文件不强制打包进入配置备份。

### Cycle 25 — 最终交叉复查
跨角色检查新增规则后，没有发现新的 P0 架构阻断。

仍必须真实验证：
```text
HarmonyOS 真机后台
AVSession
蓝牙/车载
真实 Navidrome
大库性能
功耗
Gapless 实际等级
ReplayGain
真实下载断点续传
```

结论：

**V13 APPROVED FOR M0 IMPLEMENTATION**

后续不再通过无限加文档替代真实工程验证。



## 1X. V14 扩展红队循环（Cycle 26–40）

### Cycle 26 — 播放历史语义攻击
发现“播放过”定义不够统一。修正：历史记录、最近播放、完成播放和 scrobble 分离；短暂误触不应污染“常听”。

### Cycle 27 — Shuffle 可重复性攻击
发现随机模式在队列修改/重启后可能跳歌或重复。修正：Shuffle 必须保存逻辑顺序/历史，Prev 返回真实播放历史，重启恢复随机上下文。

### Cycle 28 — Repeat 边界攻击
明确 Repeat Off / All / One 在单曲、队尾、手动 Next、自然结束时的不同语义；Repeat One 下手动 Next 仍允许前进。

### Cycle 29 — Queue 编辑竞态攻击
播放中删除当前项、拖动当前项、清空队列必须保持 current media 与 index 一致；删除当前项默认继续合理的相邻项而非播放错误对象。

### Cycle 30 — 多服务器身份碰撞攻击
再次验证所有收藏、历史、下载、歌单引用必须使用完整 MediaKey；任何 plain remoteId 查询都视为架构缺陷。

### Cycle 31 — 服务器时钟/过期 URL 攻击
不得完全信任设备或服务器绝对时间判断 URL 是否仍有效；实际 401/403/读取失败可触发一次安全刷新，避免时钟漂移造成假过期。

### Cycle 32 — HTTP Range 异常攻击
服务器可能忽略 Range、返回错误 Content-Range 或内容变化。断点续传必须验证响应，不能简单 append，否则会产生“完成但损坏”的音频。

### Cycle 33 — 磁盘清理/系统回收攻击
系统可能在应用外部影响临时文件。启动 reconciliation 必须核对 Download/Cache 索引与真实文件，不把数据库状态当作绝对事实。

### Cycle 34 — 数据库并发攻击
Queue checkpoint、history、favorite、download completion 同时写入时必须避免长事务阻塞播放控制；播放热路径不等待非关键数据库写入。

### Cycle 35 — 搜索竞态攻击
快速输入 `a → ab → abc` 时旧搜索结果不能覆盖新查询；搜索也采用 request generation/cancellation 思路。

### Cycle 36 — 封面/歌词隐私攻击
外部 Artwork/Lyrics Provider 请求可能泄露用户曲库信息。默认 Provider 必须说明数据流；第三方查询不得携带音乐服务器凭证。

### Cycle 37 — Android/iOS 思维污染攻击
禁止 AI 假设 Android Service、ExoPlayer、iOS AVAudioSession 等概念在 HarmonyOS 存在同名等价实现；必须以当前 HarmonyOS SDK 为准。

### Cycle 38 — UI 状态恢复攻击
旋转/折叠屏切换/页面重建不能创建第二个播放器，也不能重置 Queue；页面状态与应用级播放状态严格分离。

### Cycle 39 — 用户误操作恢复攻击
删除本地歌单、清历史、删除下载等用户资产操作应提供适当确认/Undo；不可逆行为必须清楚描述影响范围。

### Cycle 40 — 全局一致性复查
重新交叉检查 V11→V14 的核心规范，没有发现新的文档级 P0 架构矛盾。后续风险集中在真实实现和平台行为。

**结论：V14 / 40 CYCLES CONVERGED。**



## 1Y. V15 多维度交叉循环（Cycle 41–60）

本轮不以“继续增加功能”为目标，而是从互相冲突的维度攻击既有设计；攻击失败允许 NO CHANGE。

### 41 产品经理 × 普通用户
攻击：规范越来越专业是否让用户体验变复杂？
结论：KEEP。技术复杂度必须被客户端内部吸收；普通用户仍只看到连接、浏览、播放、下载等直接动作。

### 42 极简主义者 × 架构师
攻击：37份规范是否已经过度设计？
结论：CHANGE。新增文档索引，把规范分成 Normative / Operational / Review Archive；AI 不需要每次读完全部文件。

### 43 HarmonyOS 平台 × 跨平台架构
攻击：为了未来跨平台而抽象所有 HarmonyOS API。
结论：REJECT。SoundIsle 是 HarmonyOS 原生客户端。只抽象业务边界，不为不存在的跨平台计划制造 wrapper。

### 44 普通用户 × 发烧友
攻击：高级音频信息污染播放器。
结论：KEEP 分层。主播放器保持简单；Codec/bit depth/sample rate/source type 进入高级详情。

### 45 NAS 用户 × 安全工程师
攻击：严格安全策略是否导致 HTTP LAN 用户无法使用？
结论：COMPROMISE。用户主动配置的私网 HTTP 可用但明确提示未加密；公网 HTTP 强警告；绝不提供全局 Trust-All TLS。

### 46 隐私 × 可观测性
攻击：诊断日志可能泄露曲库、服务器和凭证。
结论：CHANGE。诊断包采用分级字段；敏感值永不进入日志，媒体标题/服务器地址默认最小化或脱敏。

### 47 性能 × 数据可靠性
攻击：频繁持久化保证恢复，但增加 I/O 和功耗。
结论：COMPROMISE。播放状态内存高频、数据库节流 checkpoint；关键生命周期边界强制 flush。

### 48 离线用户 × Remote Authority
攻击：服务器不可达时 Remote Authority 是否导致本地 UI 无法工作？
结论：CHANGE。Remote Authority 指“远程事实最终来源”，不是“每次必须联网”。缓存快照可离线展示，下载可离线播放。

### 49 多服务器 × 极简 V1
攻击：MediaKey 多服务器设计是否应该删除？
结论：NO CHANGE。身份命名空间成本很低，删除会制造未来不可迁移的数据债。

### 50 下载 × 存储生命周期
攻击：用户在下载过程中删除服务器。
结论：CHANGE。新任务立即停止；已完成下载保留为孤立本地资产；临时文件按安全清理策略处理。

### 51 歌词 × 时间轴
攻击：不同歌词源时间单位/格式不一致。
结论：CHANGE。Domain 统一毫秒；Raw provider lyrics 必须 mapper 转换；重复/倒序 timestamp 需要规范化或拒绝。

### 52 排序 × 国际化
攻击：艺术家/专辑排序不能假设 ASCII/英文。
结论：CHANGE。排序策略 locale-aware；原始 metadata 不破坏；Article 忽略规则必须可配置而非硬编码英语。

### 53 搜索 × 中文用户
攻击：中文/拼音/大小写/全半角如何处理？
结论：DEFER 智能拼音搜索，但 V1 搜索输入必须 Unicode-safe；本地历史去重采用规范化字符串而不是破坏原查询。

### 54 无障碍 × Mini Player
攻击：Mini Player 控件过小、屏幕阅读器语义混乱。
结论：CHANGE。Mini Player 核心按钮满足触控目标；整行与按钮语义不能重复触发；播放状态可读。

### 55 电池 × 后台功能
攻击：后台轮询服务器、预加载封面、健康检查消耗电量。
结论：CHANGE。后台播放不等于后台同步；无用户价值的轮询禁止常驻，健康检查按需触发。

### 56 QA × 随机事件序列
攻击：手写测试覆盖不了状态组合爆炸。
结论：CHANGE。对 Queue/Playback state machine 增加 model/property-based sequence tests（工具允许时）。

### 57 开源维护者 × Provider 插件化
攻击：现在就做动态插件系统。
结论：REJECT。Provider 是源码级模块化，不在 V1 引入动态插件 ABI/加载器。

### 58 发布经理 × Feature Flag
攻击：VERIFY 功能代码可能误开放。
结论：CHANGE。新增 Feature Gate 规范；Gapless/ReplayGain/Beta Provider 等必须显式状态控制。

### 59 灾难恢复 × 用户资产
攻击：数据库损坏怎么办？
结论：CHANGE。启动检测数据库不可用时不得自动清库；优先只读诊断/恢复路径；备份导出格式预留 schemaVersion。

### 60 全维度终审
从产品、普通用户、重度用户、发烧友、NAS、HarmonyOS、ArkTS、音频、网络、数据库、安全、隐私、无障碍、国际化、性能、功耗、QA、开源维护、AI 自治和发布共20个维度交叉复核。

结论：未发现新的文档级 P0 架构阻断。V15 后继续纯文档循环的边际收益很低，下一轮最有价值的输入应来自真实实现失败和真机证据。



## 1Z. V16 长期真实使用生命周期循环（Cycle 61–80）

### Cycle 61 — 新用户第一天
区分认证失败、不可达、协议不兼容、空库/扫描中，禁止统一成“连接失败”。

### Cycle 62 — 使用一个月
历史、搜索记录、缓存和日志必须有独立保留/容量策略，不能无限增长。

### Cycle 63 — 连续播放8小时
加入 soak test；检查内存、句柄、日志、DB写入、封面分配和功耗是否持续增长。

### Cycle 64 — 50k/100k曲库
分页之外继续限制并发和 N+1 请求，禁止 UI 线程一次性 materialize 超大列表。

### Cycle 65 — 弱网/高丢包
前台交互、播放恢复、后台请求使用不同 retry budget，避免无限等待和流量浪费。

### Cycle 66 — NAS宕机24小时
离线状态去抖并减少无意义探测；下载和缓存内容继续可用。

### Cycle 67 — Navidrome升级
Capability snapshot 不是永久事实；版本变化或能力相关失败时刷新。

### Cycle 68 — 更换NAS地址
ServerProfile ID 与 URL 解耦；编辑同一 Profile 地址不得改变 serverId。

### Cycle 69 — NAS重装导致ID变化
禁止危险自动合并；旧本地资产进入 orphan 语义，未来候选迁移必须用户确认。

### Cycle 70 — 换手机
正式定义版本化逻辑备份格式；凭证和下载音频默认不进入配置备份。

### Cycle 71 — App强杀/系统回收
关键生命周期 flush；恢复状态不等于自动播放，默认 restartAutoPlay=false。

### Cycle 72 — App升级
设置迁移保留既有用户选择语义，不能因为新默认值变化而悄悄改变旧用户行为。

### Cycle 73 — App降级
遇到 future schema 禁止旧版写入或自动重建空库，必须显示不兼容。

### Cycle 74 — 数据库损坏
durable DB 失败不得自动清库；保留原数据并进入诊断/恢复路径。

### Cycle 75 — 500GB下载库
冷启动不能同步 hash 全部文件；快速索引核对后再增量深检。

### Cycle 76 — 服务器替换文件但ID不变
Range续传/缓存不能只信 remoteId；使用可用 validator/size/modified hints。

### Cycle 77 — 时区/系统时间变化
持久化事件用 epoch ms；运行时耗时优先 monotonic clock；展示再本地化。

### Cycle 78 — 删除服务器/隐私清理
删除 SecureStorage 凭证和 disposable cache；durable 本地资产按用户选择处理。

### Cycle 79 — 一年后维护
新增规范必须进入 DOC_INDEX；Review Archive 不得反向成为当前规范。

### Cycle 80 — 生命周期终审
串联第一天到长期维护复核，未发现新的文档级 P0 架构阻断。

**结论：V16 / 80 CYCLES CONVERGED。**


## 1AA. V17 对抗性循环（Cycle 81–100）

### Cycle 81 — 恶意测试员：疯狂操作
连续快速点播/暂停/Seek/切歌/清队列/重排/返回前台，要求不崩、不串状态、不错误自动播放。

### Cycle 82 — 恶意测试员：边下载边删
下载中删除任务、删除服务器、清缓存、切换账号，临时文件和数据库必须最终一致。

### Cycle 83 — 真机故障：蓝牙抖动
蓝牙设备反复连接/断开，不允许反复自动恢复造成扬声器外放或状态抖动。

### Cycle 84 — 真机故障：音频焦点风暴
导航/电话/语音助手频繁打断，UserPlaybackIntent 必须始终高于自动恢复逻辑。

### Cycle 85 — 真机故障：低内存
系统回收页面/非关键对象后，播放器单例与队列状态不应被重复创建。

### Cycle 86 — 真机故障：存储突然不足
下载/缓存写入失败时不得污染已完成文件或删除用户旧下载。

### Cycle 87 — 恶意服务端：慢响应
服务器故意卡住连接/read，不允许占死 UI、命令队列或无限等待。

### Cycle 88 — 恶意服务端：超大JSON
限制响应体/字段长度/数组规模，解析异常不应造成 OOM。

### Cycle 89 — 恶意服务端：错误MIME/格式
服务端宣称 FLAC 实际返回别的内容，播放器/下载验证失败必须安全降级。

### Cycle 90 — 恶意重定向
多跳 redirect、Host 切换、HTTPS→HTTP 降级都必须遵循认证剥离和安全策略。

### Cycle 91 — AI失败：重复造层
AI 可能新建第二套 Repository/PlayerStateStore。新增 ARCHITECTURE_GUARDRAILS 规则防重复核心。

### Cycle 92 — AI失败：接口命名漂移
AI 修改接口不更新调用方/文档。要求契约变更必须同提交更新引用和测试。

### Cycle 93 — AI失败：假测试
AI 用 mock 证明后台/蓝牙通过。再次强化 DEVICE_TEST_REQUIRED 不可被 mock 取代。

### Cycle 94 — AI失败：补丁式特殊判断
AI 可能到处加 if Navidrome/version。要求 compatibility workaround 集中、带测试和移除条件。

### Cycle 95 — AI失败：过度重构
任务只需修 bug 却重写架构。增加 Change Budget：非当前任务相关重构必须有 ADR/收益证明。

### Cycle 96 — 发布故障：签名/权限
Release 构建权限、签名、后台能力与 Debug 不同，RC 必须用 Release 配置走关键链路。

### Cycle 97 — 发布故障：配置泄漏
Debug server、测试账号、日志开关、内部 feature flag 不得进入 Release。

### Cycle 98 — 第三方依赖故障
依赖升级可能破坏构建/许可证/行为，新增依赖锁定和升级验证规则。

### Cycle 99 — 用户支持：无法复现Bug
诊断包必须包含版本/状态机/网络/Provider 摘要，但默认脱敏，方便远程排障。

### Cycle 100 — 全局终审
对100轮累计决策做矛盾扫描；未发现新的文档级 P0 阻断，剩余高风险均要求真实代码/设备/服务器验证。

**结论：V17 / 100 CYCLES CONVERGED。**


## 1AB. V18 证据驱动循环（Cycle 101–120）

### Cycle 101 — 证据门槛：禁止为了循环而改
要求每个新建议先证明现有规范存在具体失败场景；证明不了则记录 NO CHANGE。

### Cycle 102 — 普通用户：播放器首页还要不要再简化
攻击失败。现有首页优先继续播放/最近播放/最近添加已经足够简单。NO CHANGE。

### Cycle 103 — 发烧友：主播放页应常驻显示24bit/96k
攻击失败。主界面常驻技术信息会污染普通体验；高级详情已满足需求。NO CHANGE。

### Cycle 104 — 架构师：是否需要统一全局EventBus
攻击失败。已有明确状态源/接口，万能 EventBus 反而增加隐式耦合。REJECT。

### Cycle 105 — ArkTS：是否要把全部网络请求放Worker
攻击失败。I/O 优先平台异步 API，Worker/TaskPool 只用于CPU重任务。NO CHANGE。

### Cycle 106 — QA：Queue随机模式仍有恢复歧义
攻击成功。补充随机顺序持久化版本号与队列编辑后的再映射规则，避免重启后 shuffle history 指向失效索引。

### Cycle 107 — 业务逻辑：收藏同步失败状态不够细
攻击成功。区分 LOCAL_ONLY / SYNC_PENDING / SYNCED / SYNC_FAILED / UNSUPPORTED，且服务器同步失败不回滚本地收藏。

### Cycle 108 — 安全：日志中的mediaKey是否也可能泄露
攻击成功。诊断默认允许稳定哈希/短引用，不记录完整服务器URL+remoteId组合；用户主动高级诊断时才扩大信息。

### Cycle 109 — API：Capability snapshot可能被服务器虚报
攻击成功。能力声明只是提示；关键操作需 runtime fallback，不可因 advertised=true 就跳过错误处理。

### Cycle 110 — 下载：文件完整性只靠size不够
攻击成功。若服务器提供可用 validator/hash 应纳入验证；无hash时至少做状态/size/可打开性检查，不能声称“强校验”。

### Cycle 111 — 缓存：歌词/封面版本长期陈旧
攻击成功。Metadata/lyrics/artwork cache增加刷新触发器：TTL、手动刷新、服务器版本/媒体hint变化。

### Cycle 112 — UI：离线缓存显示会不会误导为“最新”
攻击成功。离线或旧缓存需轻量状态标识，避免用户误以为服务器已经同步。

### Cycle 113 — 无障碍：拖动队列排序无法被屏幕阅读器完成
攻击成功。必须提供非拖拽等价操作或可访问的移动命令。

### Cycle 114 — 性能：超大歌单重排会频繁写DB
攻击成功。队列/歌单排序采用批量/事务化更新，不逐项同步写盘。

### Cycle 115 — Release：Feature Gate是否可能因旧设置被用户绕过
攻击成功。发布级Gate状态必须由产品/构建策略约束，用户设置不能启用DISABLED功能。

### Cycle 116 — AI：规范太多导致漏读
攻击成功。DOC_INDEX增加Task→Required Specs映射表，任务创建时必须声明required_docs。

### Cycle 117 — 开源维护：ADR会不会无限膨胀
攻击成功。ADR必须有状态和superseded_by，旧决策不再参与当前执行但保留历史。

### Cycle 118 — 支持场景：用户只说“播不了”
攻击成功。诊断包新增最后一次播放失败摘要：generation、sourceType、route、errorCategory、recoverySteps，仍需脱敏。

### Cycle 119 — 数据恢复：备份导入同名服务器冲突
攻击成功。Restore必须明确MERGE/KEEP_BOTH/REPLACE三类策略，默认不静默覆盖。

### Cycle 120 — 证据驱动终审
重新检查本轮全部修改，保留10项成功攻击、5项NO CHANGE/REJECT。未发现新的文档级P0阻断。

### V18 审查规则
从本版本开始，任何后续“循环”都必须先满足：

```text
提出攻击
→ 给出具体失败场景
→ 证明现有规范无法覆盖
→ 才允许 CHANGE

无法证明
→ NO CHANGE / REJECT
```

这条规则用于防止为了追求轮数而把稳定设计反复改坏。

**结论：V18 / 120 CYCLES CONVERGED。**


## 1AC. V19 状态不变量 / 数据一致性循环（Cycle 121–140）

### Cycle 121 — 状态不变量：当前媒体唯一性
证明若 UI currentMedia、Queue currentIndex、Engine source 可分别更新，会产生“显示C实际播B”。修正：定义 CurrentMediaInvariant，三者必须由同一 generation 提交。

### Cycle 122 — 状态不变量：暂停绝对优先
证明系统恢复与用户暂停竞态可导致误播放。修正：任何 auto-resume 必须重新检查 UserPlaybackIntent==PLAY，且检查发生在真正 start 前。

### Cycle 123 — 队列不变量：索引合法性
证明删除/移动后 currentIndex 可能越界。修正：每次队列 mutation 后必须满足 empty 或 0<=index<size，并以 MediaKey 重定位当前项。

### Cycle 124 — 队列不变量：当前项身份
证明仅靠 index 在重排后会错歌。修正：current MediaKey 为身份权威，index 只是位置缓存。

### Cycle 125 — Shuffle 不变量：历史不可重写
证明重排/删除后随机历史若按 index 保存会错。修正：shuffle traversal/history 按 MediaKey 保存并映射。

### Cycle 126 — 播放代际不变量
证明旧 callback 可能晚于新 generation。修正：所有异步提交点必须携带 generation guard，而不是仅 Resolve 阶段检查。

### Cycle 127 — 操作幂等性：收藏
证明网络超时后盲目重试 server star 可能重复/状态错乱。修正：本地收藏先落地，远程写按 provider 能力使用幂等或可重放策略。

### Cycle 128 — 操作幂等性：歌单
证明 create/update/delete 在网络不确定时不能统一重试。修正：不同写操作定义 retry safety class。

### Cycle 129 — 下载不变量：DB与文件一致
证明 COMPLETED 但文件缺失/临时文件残留会造成假完成。修正：COMPLETED 需 final file existence + verification marker；启动 reconciliation 可降级状态。

### Cycle 130 — 缓存不变量：可丢弃性
证明若业务逻辑依赖 cache 一定存在，则清缓存会破坏功能。修正：任何 cache miss 必须可重取/可降级，不得成为 durable authority。

### Cycle 131 — 数据库事务边界
证明把播放热路径和历史/下载写进同一长事务会阻塞。修正：区分 critical durable transaction 与 best-effort telemetry/history write。

### Cycle 132 — 迁移不变量：单调版本
证明重复执行 migration 或中断后重跑可能重复修改。修正：migration 必须可检测已应用步骤并验证目标 schema。

### Cycle 133 — 备份不变量：引用闭包
证明导出 playlist 但漏 media snapshots 导致恢复后不可读。修正：备份对被引用 durable objects 必须包含最小可理解快照。

### Cycle 134 — 错误恢复不变量：有限性
证明 Recovery 若没有严格预算可无限循环。修正：定义 recoveryAttemptBudget 与 terminal condition。

### Cycle 135 — 网络不变量：一次失败不等于全局离线
证明某 route 失败时直接标全局 Offline 会误导。修正：区分 route failure、server unreachable、network unavailable。

### Cycle 136 — Feature Gate 不变量
证明代码存在+旧偏好可能越权开启内部能力。修正：最终 effective gate = release policy ∩ capability ∩ user setting，而非用户设置单独决定。

### Cycle 137 — Provider 不变量：能力与行为分离
证明 advertised capability 可能错误。修正：capability 仅影响预期路径，runtime error 仍走 fallback。

### Cycle 138 — 可访问性不变量：无手势唯一入口
证明拖拽/长按若无替代路径违反可访问性。修正：所有关键动作必须有非手势等价入口。

### Cycle 139 — AI实现可证明性
证明“代码看起来对”不能证明不变量。修正：新增 property/model-based test 目标，至少覆盖 Queue/Playback generation/recovery budget。

### Cycle 140 — 形式化终审
将播放、队列、下载、缓存、迁移、恢复、Feature Gate、Provider能力八类不变量交叉复核。新增缺陷均已落入规范；无新的文档级P0阻断。

### V19 总原则
后续实现必须优先证明关键不变量，而不是仅证明“某个 happy path 能跑通”。

**结论：V19 / 140 CYCLES CONVERGED。**


## 1AD. V20 模块契约 / ArkTS 类型边界循环（Cycle 141–160）

### Cycle 141 — Provider→DTO 边界
证明 Provider DTO 若直接进入 Repository/UI，会让协议字段污染业务。修正：Provider 只暴露稳定契约，DTO 仅限 Data/Provider 层。

### Cycle 142 — DTO→Domain 映射
证明可选字段、null、未知字段、单位差异会在强转时泄漏。修正：显式 Mapper + Defensive Parser，禁止 `as Song`。

### Cycle 143 — Domain→UI 边界
证明 UI 若直接持有可变 Domain 实体并修改，会产生双写状态。修正：ViewModel 只发布 Presentation State，写操作回到业务入口。

### Cycle 144 — UI→Player 命令边界
证明页面直接调用 AVPlayer/Engine 会绕过 generation/inhibitor。修正：UI 只能发 PlayerController 命令。

### Cycle 145 — Player→Repository 边界
证明 PlaybackEngine 若直接查数据库/网络，会形成巨型播放层。修正：Resolver/Repository 提供数据，Engine 只负责媒体执行。

### Cycle 146 — Repository→Provider 边界
证明 Repository 到处判断 server type 会扩散兼容逻辑。修正：Repository 依赖 Provider Contract，不依赖品牌实现。

### Cycle 147 — ArkTS类型：any 污染
证明 `any` 会掩盖 nullable/shape 错误。修正：核心层禁止 any；边界 JSON 进入 typed DTO 前必须验证。

### Cycle 148 — ArkTS类型：可选字段
证明 `undefined/null/空字符串` 混用会造成排序/展示/持久化差异。修正：字段语义统一，Mapper 做规范化。

### Cycle 149 — ArkTS类型：数字范围
证明 JS number 对超大整数/时间/size 可能有精度边界。修正：对可能超安全整数范围的数据不得盲转 number；保留字符串或明确边界检查。

### Cycle 150 — ArkTS类型：枚举漂移
证明字符串 magic value 会导致状态不一致。修正：核心状态/错误/ProviderCapability 使用集中定义的 enum/union-like type。

### Cycle 151 — 异步返回类型
证明 Promise<nullable>、throw、Result 混用会导致调用方漏处理。修正：每类接口统一错误契约，不允许同层随机混搭。

### Cycle 152 — 生命周期所有权
证明 ViewModel/页面持有长生命周期对象会泄漏或重复实例。修正：Application/Feature/Page 三层所有权明确。

### Cycle 153 — 依赖方向
证明 Presentation 反向被 Data import、Provider import UI 会形成循环依赖。修正：定义依赖 DAG，CI/静态检查可验证。

### Cycle 154 — 事件边界
证明无类型 EventBus 会让模块间 payload 漂移。修正：系统级事件若存在必须 typed event contract，且数量受控。

### Cycle 155 — 存储序列化边界
证明直接序列化 Domain 对象会在字段升级时破坏兼容。修正：Persistence DTO 与 Domain 分离，schema version 管理。

### Cycle 156 — 缓存模型边界
证明缓存 DTO 与 Domain 共用对象会让失效策略混乱。修正：Cache record 显式包含 version/freshness/source。

### Cycle 157 — 错误传播边界
证明底层异常直接 throw 到 UI 会泄露技术细节。修正：每层只暴露该层允许的 Error Contract。

### Cycle 158 — ArkTS模块命名/文件布局
证明 AI 可能产生同名 Manager/Utils/Common。修正：命名规则与 package boundary 明确，禁止万能目录。

### Cycle 159 — 契约测试
证明接口文档存在但实现可偏离。修正：Provider/Repository/Player boundary 都要有 contract test 或 compile-time fixture。

### Cycle 160 — 边界终审
交叉检查 Provider→Repository→Domain→Player→Presentation→Persistence 依赖与类型流，未发现新的文档级P0阻断。

### V20 总原则

```text
协议数据不能直接变成业务数据
业务数据不能被 UI 直接修改
UI 不能直接控制 AVPlayer
Engine 不能直接访问 Provider/Database
Provider 特判不能泄漏到 Repository/UI
Persistence Model 不能等同 Domain Model
```

**结论：V20 / 160 CYCLES CONVERGED。**


## 1AE. V21 规范瘦身 / AI 可执行性循环（Cycle 161–180）

### Cycle 161 — 新开发者：第一次读文档
证明69份文件会造成入口迷失。修正：定义 START_HERE.md，只允许新人先读最小集合。

### Cycle 162 — AI执行模型：上下文窗口攻击
证明一次读全量规范会浪费上下文。修正：任务驱动按 required_docs 加载，不再默认全读。

### Cycle 163 — 架构师：重复规范攻击
发现 ARCHITECTURE/MODULE_CONTRACTS/DEPENDENCY_DAG 局部重复。修正：明确每份职责，不复制全文规则。

### Cycle 164 — 音频专家：播放规范重复
发现 AUDIO_ARCHITECTURE/PLAYBACK_STATE_MACHINE/SYSTEM_INVARIANTS 重叠。修正：状态机=规范源，Audio Architecture=设计解释，Invariants=必须永远成立。

### Cycle 165 — 数据工程：DATA_MODEL/PERSISTENCE/DATABASE_SCHEMA 重叠
修正：Domain、Persistence DTO、Physical Schema 三层职责冻结，互不复制字段全集。

### Cycle 166 — QA：TEST_PLAN/CHAOS/PROPERTY TEST 重叠
修正：TEST_PLAN 只做总入口；Chaos/Property 为专项，不重复普通用例。

### Cycle 167 — Release：RELEASE_GATES/CONFIGURATION 重叠
修正：Gate 定义能否发版，Configuration 定义构建配置必须检查什么。

### Cycle 168 — 安全：SECURITY/RESOURCE_LIMITS/NETWORK_EDGE_CASES 重叠
修正：Security=威胁与底线，ResourceLimits=输入资源上限，NetworkEdgeCases=网络行为。

### Cycle 169 — 维护者：CHANGELOG泛滥
证明V13~V20 changelog对执行无价值。修正：全部归档到 docs/archive，当前根目录只保留 CURRENT_CHANGELOG。

### Cycle 170 — 维护者：Review Report太长
修正：MULTI_AI_REVIEW_REPORT 移到archive；当前规范只保留 REVIEW_SUMMARY。

### Cycle 171 — 极简主义：是否删除MASTER_PLAN大段历史轮次
攻击成功。当前 MASTER_PLAN 不再继续塞全部历史；历史循环移入 REVIEW_ARCHIVE_INDEX，Master仅保留当前结论。

### Cycle 172 — AI：规范冲突检测
新增 SPEC_CONSISTENCY_CHECKLIST，变更必须检查术语、状态、单位、优先级、引用。

### Cycle 173 — AI：任务完成判断
新增 DEFINITION_OF_DONE，统一什么叫DONE，避免每份文件各写一套。

### Cycle 174 — 项目经理：M0范围漂移
重申CURRENT_MILESTONE是执行范围唯一入口，Master不直接下放每日任务。

### Cycle 175 — 普通用户：文档简化会不会丢需求
NO CHANGE。产品需求仍由 PRODUCT_REQUIREMENTS/ACCEPTANCE_CRITERIA 保持，不因技术瘦身删减。

### Cycle 176 — 开源维护：贡献入口
新增 CONTRIBUTING_GUIDE，解释最小阅读、测试、ADR、Provider贡献路径。

### Cycle 177 — AI：术语漂移
新增 GLOSSARY，冻结 MediaKey/AudioSource/QueueSeed/UserPlaybackIntent 等核心名词。

### Cycle 178 — 架构治理：文档所有权
新增 SPEC_OWNERSHIP，规定每类变更应该更新哪份规范，减少多处同步。

### Cycle 179 — 反向删除测试
尝试删除重复文档；发现部分虽重叠但承担不同规范层级。采取“归档+索引+职责分离”，不做破坏性合并。

### Cycle 180 — 瘦身终审
从69份文件中把执行入口压缩到少量核心文件，其余按任务按需加载；未发现瘦身导致的P0信息丢失。

### V21 核心结论

从 V21 开始：

```text
新人 / AI 不再默认阅读全部规范
→ 先读 START_HERE
→ 读取 CURRENT_MILESTONE
→ 根据 TASK_SPEC_MAPPING 加载 required_docs
→ 实现
```

历史评审材料全部降级为 Archive，不参与当前规范优先级。

**结论：V21 / 180 CYCLES CONVERGED。**


## 1AF. V22 M0/M1 实现演练循环（Cycle 181–200）

### Cycle 181 — AI模拟：创建工程骨架
发现规范没有明确哪些模块先建、哪些只是package。修正：新增IMPLEMENTATION_BLUEPRINT，明确M0最小骨架。

### Cycle 182 — AI模拟：Composition Root
发现AI可能在页面里new Repository。修正：给出唯一Composition Root装配范式和生命周期。

### Cycle 183 — AI模拟：Domain模型
发现AI可能一次实现全部未来字段。修正：最小可编译模型 + 可选字段，禁止为了完整性过度建模。

### Cycle 184 — AI模拟：NetworkClient
发现AI可能把Provider认证逻辑塞进通用HTTP层。修正：NetworkClient只做通用请求，认证装饰由Provider/ServerSession负责。

### Cycle 185 — AI模拟：SecureStorage
发现AI可能在接口不存在时用Preferences暂代。修正：敏感存储不可降级到明文Preferences；缺平台能力则BLOCKED。

### Cycle 186 — AI模拟：RDB
发现AI可能M0就建全部表。修正：M0只建必要schema基础/迁移框架；业务表按里程碑落地。

### Cycle 187 — AI模拟：OpenSubsonic ping
发现AI可能把API endpoint写死为/rest并忽略Base URL path。修正：新增URL构造规范，服务器Base URL与endpoint安全拼接。

### Cycle 188 — AI模拟：认证参数
发现AI可能记录密码/token到调试日志。修正：Provider request logging默认只记录endpoint/category，不记录敏感query/header。

### Cycle 189 — AI模拟：DTO
发现AI可能用一个巨大SubsonicResponse类型。修正：按endpoint定义小DTO+共享基础字段，不建万能DTO。

### Cycle 190 — AI模拟：Repository
发现AI可能返回Provider DTO。修正：Repository contract只返回Domain/PagedResult。

### Cycle 191 — AI模拟：首页
发现AI在M0提前做真实首页请求。修正：M0 UI Shell只能placeholder/mock-free静态壳，不冒充M1数据功能。

### Cycle 192 — AI模拟：Player接口
发现AI可能M0就写完整AVPlayer实现。修正：M0只定义接口/生命周期骨架，真正AVPlayer在M2。

### Cycle 193 — AI模拟：错误处理
发现AI可能M0就做全局toast。修正：错误模型先定义，UI呈现按feature实现，不建立万能Toast服务。

### Cycle 194 — AI模拟：测试
发现AI可能只写存在性测试。修正：M0测试至少覆盖依赖装配、模块边界、敏感配置不落盘、基础DTO mapper。

### Cycle 195 — AI模拟：CI
发现AI可能猜DevEco/Hvigor命令。修正：BUILDING必须从真实仓库/工具链探测后填写，禁止凭经验编命令。

### Cycle 196 — AI模拟：M1 ServerProfile
发现AI可能把password放ServerProfile。修正：ServerProfile只持credentialRef，真实secret只在SecureStorage。

### Cycle 197 — AI模拟：M1连接测试
发现AI可能连接成功后直接写入Profile再验证。修正：先验证临时连接，再事务性保存Profile+credentialRef，失败不残留半配置。

### Cycle 198 — AI模拟：Capability
发现AI可能ping成功就假设所有OpenSubsonic扩展。修正：能力独立探测，失败时保守降级。

### Cycle 199 — AI模拟：分页
发现AI可能Repository一次返回全部Albums。修正：M1 contract直接定义Page/Cursor/Offset模型，避免未来重构。

### Cycle 200 — 实现演练终审
将M0→M1从空仓库到真实Navidrome首个浏览请求完整模拟，未发现新的文档级P0阻断。

### V22 结论
从本版本开始，规范不仅要“逻辑正确”，还要能指导一个陌生AI从空仓库做出最小正确实现。

**结论：V22 / 200 CYCLES CONVERGED。**


## 1AG. V23 假想 PR / 代码审查循环（Cycle 201–220）

### Cycle 201 — PR Review：工程骨架提交
发现AI可能一次提交数百文件，无法审查。修正：PR按可验证垂直切片拆分，禁止“大爆炸式首提交”。

### Cycle 202 — PR Review：Composition Root
发现AI可能为了测试暴露全局ServiceLocator。修正：生产代码禁止全局可变ServiceLocator，测试通过显式依赖替换。

### Cycle 203 — PR Review：ArkTS异步闭包
发现页面销毁后Promise回调仍写UI状态。修正：ViewModel请求引入request generation/disposed guard。

### Cycle 204 — PR Review：UI状态双写
发现页面本地state和ViewModel同时维护loading/error/data。修正：同一feature只允许一个Presentation State权威。

### Cycle 205 — PR Review：ServerProfile保存
发现SecureStorage成功但RDB失败会遗留孤立credential。修正：定义补偿删除与启动孤儿凭证清理策略。

### Cycle 206 — PR Review：OpenSubsonic认证
发现query auth参数可能进入URL日志/崩溃报告。修正：敏感query在网络日志与诊断中统一redact。

### Cycle 207 — PR Review：分页并发
发现快速滚动时Page 3先于Page 2返回导致顺序错乱。修正：分页请求必须带query generation + page sequence/merge rule。

### Cycle 208 — PR Review：搜索
发现旧关键词响应覆盖新关键词。已有generation规则可覆盖。NO CHANGE，要求测试证明。

### Cycle 209 — PR Review：封面
发现列表复用后旧封面异步回填到新歌曲。修正：Artwork binding按MediaKey/token验证后提交。

### Cycle 210 — PR Review：M2 AVPlayer准备
发现prepare旧回调可能覆盖新曲。已有PlaybackGeneration原则，但实现模板不够。修正：新增PLAYBACK_IMPLEMENTATION_CHECKLIST。

### Cycle 211 — PR Review：音频中断
发现恢复逻辑直接调用play绕过UserPlaybackIntent。已有不变量覆盖。NO CHANGE，列为BLOCKER审查项。

### Cycle 212 — PR Review：耳机拔出
发现route loss若自动切扬声器继续播会造成隐私/社交问题。修正：耳机/蓝牙意外断开默认暂停，恢复需明确策略。

### Cycle 213 — PR Review：Seek风暴
发现每次slider变化都立即seek导致Engine命令拥塞。修正：UI预览位置与实际seek提交分离，拖动结束/节流提交。

### Cycle 214 — PR Review：进度持久化
发现每秒写RDB导致I/O过多。已有节流规则覆盖。NO CHANGE，增加PR证据要求。

### Cycle 215 — PR Review：下载并发
发现每个任务各自无限并发。修正：DownloadScheduler统一并发预算，前台播放优先于后台下载。

### Cycle 216 — PR Review：离线播放
发现下载记录存在但文件已被系统/用户删除。已有reconciliation覆盖。NO CHANGE，要求播放前快速存在性检查。

### Cycle 217 — PR Review：错误Toast
发现网络抖动会连续弹多个Toast。修正：错误展示分为inline/banner/actionable toast，重复错误去抖。

### Cycle 218 — PR Review：测试质量
发现测试只assert方法被调用，不验证不变量。修正：PR模板要求至少一项行为/状态结果断言。

### Cycle 219 — PR Review：性能回归
发现代码正确但首页一次触发几十个Artwork请求。修正：PR性能检查增加请求扇出/列表首屏资源预算。

### Cycle 220 — PR终审
模拟M0/M1/M2连续PR链，保留4项NO CHANGE并新增可执行审查门槛；未发现新的文档级P0阻断。

### V23 结论

规范现在必须同时回答两个问题：

```text
“应该怎么设计？”
以及
“代码提交后，Reviewer 如何证明它真的遵守设计？”
```

**结论：V23 / 220 CYCLES CONVERGED。**


## 1AH. V24 连续里程碑 / 技术债 / 真机生命周期循环（Cycle 221–240）

### Cycle 221 — M0→M1：临时接口债
证明M0若用临时接口签名，M1会大面积重构。修正：M0接口必须按已知长期边界设计，未知能力用最小扩展点而非TODO参数。

### Cycle 222 — M1→M2：Repository阻塞播放
证明浏览Repository若被设计成只返回完整Song对象，播放需要额外网络拼装。修正：MediaKey/PlaybackResolver边界必须从M1就可用。

### Cycle 223 — M1→M2：认证会话刷新
证明M1只做一次ping认证不足以支持长时播放。修正：ServerSession/CredentialProvider支持按请求读取当前credential，避免Player缓存secret。

### Cycle 224 — M2→M3：播放与下载抢带宽
证明两套独立HTTP执行器会互相争抢。修正：共享NetworkPolicy/QoS概念，播放流优先，下载可降并发/暂停。

### Cycle 225 — M2→M3：缓存与下载混淆
证明“播过的缓存”被误当“已下载”会导致离线承诺错误。已有不变量覆盖，NO CHANGE；增加里程碑验收证据。

### Cycle 226 — 升级：数据库v1→v2
证明真实用户升级时migration失败不能直接清库。修正：升级路径必须保留旧库、失败可诊断、禁止自动wipe。

### Cycle 227 — 升级：Queue Snapshot兼容
证明新版本字段变化可能让旧队列无法恢复。修正：持久化快照版本化，旧版本可迁移或安全降级。

### Cycle 228 — 升级：Settings兼容
证明枚举新增/删除会导致旧设置解析失败。修正：设置解析必须有unknown/default迁移策略。

### Cycle 229 — 真机：Ability前后台
证明页面消失不等于应用播放生命周期结束。修正：Player核心生命周期与Page解耦。

### Cycle 230 — 真机：进程被杀
证明只在onBackground保存状态不可靠。修正：关键播放/队列状态采用节流增量持久化 + 生命周期flush。

### Cycle 231 — 真机：后台播放
证明仅AVPlayer能播不代表系统允许后台持续。修正：后台播放所需HarmonyOS能力/声明/会话必须列为DEVICE_TEST_REQUIRED，禁止猜API。

### Cycle 232 — 真机：锁屏控制
证明媒体会话命令可能与页面命令并发。修正：所有外部控制统一进入PlayerController命令入口。

### Cycle 233 — 真机：通知/媒体卡片
证明UI显示的歌曲可能落后PlayerState。修正：系统媒体元数据由同一PlayerState/CurrentMedia投影，不另建状态源。

### Cycle 234 — 真机：音频焦点/中断
证明来电/语音应用打断后恢复存在竞态。已有Intent/Inhibitor覆盖；NO CHANGE，要求真机矩阵验证。

### Cycle 235 — 真机：蓝牙重连
证明断开暂停后自动重连是否恢复存在产品歧义。妥协：默认不自动恢复，提供未来可配置策略但M3不开放。

### Cycle 236 — 真机：网络切换
证明Wi‑Fi→蜂窝时旧stream可能半开。修正：网络变化只触发受控恢复，不直接重建Player；保留generation与position。

### Cycle 237 — 真机：系统省电
证明后台任务/下载可能被系统限制。修正：下载调度必须可中断、可恢复，不依赖永久后台存活假设。

### Cycle 238 — M3：磁盘空间
证明下载前有空间但写入中途耗尽。修正：预检查只是提示，写入期间仍处理ENOSPC并保持一致状态。

### Cycle 239 — 里程碑债务门
新增TECH_DEBT_GATE：每个Milestone结束必须分类债务，P0/P1禁止滚入下一里程碑。

### Cycle 240 — 连续开发终审
模拟从空工程→服务器→播放→下载/后台能力的连续演进，发现并封堵跨里程碑接口债、迁移债、生命周期债；无新文档级P0阻断。

### V24 结论
任何里程碑都不能通过“先写死、以后再重构”把确定性问题推给下一阶段。

```text
M0 架构债
→ 会在 M1 Provider 爆炸

M1 数据/API债
→ 会在 M2 Playback 爆炸

M2 生命周期/网络债
→ 会在 M3 Download/Background 爆炸
```

因此从 V24 开始增加 Milestone Debt Gate。

**结论：V24 / 240 CYCLES CONVERGED。**


## 1AI. V25 上线后真实世界循环（Cycle 241–260）

### Cycle 241 — 真实用户：Navidrome版本差异
证明不能只按单一测试服务器行为实现。修正：记录serverVersion/protocolVersion并以Capability为准，版本号只作诊断线索。

### Cycle 242 — 真实用户：OpenSubsonic扩展缺失
证明声明OpenSubsonic不等于每个扩展都可用。已有Capability模型覆盖；NO CHANGE，增加兼容矩阵证据。

### Cycle 243 — 反向代理：路径重写
证明代理可能同时有子路径、尾斜杠和重写。强化URL规范：保存用户ServerRoot语义，endpoint resolver不得二次吞路径。

### Cycle 244 — 反向代理：401/302登录页
证明错误代理可能返回HTML而非JSON。修正：Content-Type/body-shape异常映射为Protocol/Proxy错误，不当作空数据。

### Cycle 245 — TLS：自签名证书
产品妥协：V1默认不绕过TLS验证；未来若支持自定义CA必须显式信任，不提供“忽略所有证书错误”。

### Cycle 246 — 弱网：高延迟抖动
证明固定超时会误杀慢服务器。修正：连接/metadata/source/stream按操作类型定义超时策略，不能一个全局timeout。

### Cycle 247 — 弱网：断流后服务器已换URL
证明恢复时复用旧stream URL可能继续失败。已有Source refresh覆盖；NO CHANGE，加入生产故障测试。

### Cycle 248 — 大曲库：10万歌曲
证明全库内存索引不可作为默认设计。修正：搜索/浏览分页、数据库索引、增量缓存；禁止启动时全量加载Domain对象。

### Cycle 249 — 大曲库：巨型歌单
证明数万条playlist一次渲染/复制会卡顿。修正：虚拟化/分页或分块加载；QueueSeed构造不得阻塞UI线程。

### Cycle 250 — 异常音频：损坏文件
证明duration/bitrate/container metadata可能错误。修正：远端metadata是提示，实际播放失败进入可恢复错误，不污染队列。

### Cycle 251 — 异常音频：未知编码
证明支持格式不能只看扩展名。修正：播放能力由平台实际解码结果/声明能力决定；失败可按Policy尝试服务器转码。

### Cycle 252 — 异常音频：超长/0时长
修正：duration边界验证；0/unknown duration允许直播式/未知进度语义时必须明确，否则显示不可seek。

### Cycle 253 — Artwork炸弹
证明超大图片/畸形图片可造成内存峰值。修正：Artwork decode尺寸/像素预算、缩略图优先、失败占位。

### Cycle 254 — 歌词炸弹
证明超大LRC/逐字歌词可造成解析卡顿。已有ResourceLimits概念，强化歌词大小/行数/时间戳上限与后台解析。

### Cycle 255 — 崩溃：播放状态写一半
证明多字段分散写会形成撕裂快照。修正：Queue/Playback snapshot采用版本+原子替换/事务语义。

### Cycle 256 — 崩溃：下载rename前后
证明临时文件与数据库状态可能不一致。修正：下载提交顺序冻结：temp complete→verify→atomic rename→durable COMPLETED。

### Cycle 257 — 线上回归：新版本Provider坏了
新增Compatibility Kill Switch：可通过本地feature gate/版本策略禁用危险可选能力，但核心离线/本地数据不能被远程破坏。

### Cycle 258 — 用户反馈：诊断不够
新增Support Diagnostic Bundle规范：仅非敏感环境/错误/能力摘要，默认不含URL凭证、用户名、媒体标题等隐私内容。

### Cycle 259 — 发布：兼容矩阵
新增PRODUCTION_COMPAT_MATRIX，至少记录Navidrome版本、HarmonyOS设备/版本、网络/代理场景、媒体格式和结果。

### Cycle 260 — 生产终审
模拟V1.0上线后真实用户、旧/新Navidrome、代理、弱网、10万曲库、坏文件、崩溃和回归；新增生产防线后无文档级P0阻断。

### V25 结论
V1.0 之后，服务器、网络、媒体文件和设备都不能被假设为“正常输入”。

```text
外部世界 = 不可信但合法的复杂输入
→ 验证
→ 限制资源
→ 保持用户数据
→ 可诊断
→ 可恢复
```

**结论：V25 / 260 CYCLES CONVERGED。**


## 1AJ. V26 反架构 / 最小复杂度循环（Cycle 261–280）

### Cycle 261 — 极简架构师：Repository是否多余
攻击失败。Provider DTO不能泄漏Domain/UI，且本地/远端组合需要边界。保留Repository，但禁止一实体一Repository的机械拆分。

### Cycle 262 — 极简架构师：PlayerStateStore是否多余
攻击失败。页面、锁屏、后台、媒体卡片共享状态需要单一权威。保留，但明确只保存播放器状态，不变成万能AppStore。

### Cycle 263 — 极简架构师：Provider抽象是否过早
部分成功。V1只实现OpenSubsonic/Navidrome；保留最小Provider Contract，但禁止为了未来Emby/Jellyfin预埋未验证方法。

### Cycle 264 — 产品经理：MVP被架构拖慢
攻击成功。新增MVP_COMPLEXITY_BUDGET：V1只实现用户可感知或避免高风险返工的基础设施。

### Cycle 265 — 普通用户：是否真的需要全部高级能力
攻击成功。Gapless/ReplayGain/高级音频信息等按Feature Gate，不阻塞核心“连接→浏览→播放”。

### Cycle 266 — AI：109文件重新膨胀
攻击成功。新增ACTIVE_SPEC_SET，当前任务默认只读核心+required_docs；历史Changelog继续降级。

### Cycle 267 — 维护者：规范之间引用太深
攻击成功。引用链超过两跳时，任务映射应直接列最终规范，避免AI递归读文档。

### Cycle 268 — ArkTS架构师：接口过碎
攻击成功。禁止为每个单方法创建Interface；只有跨层、可替换、测试隔离或生命周期边界才值得接口。

### Cycle 269 — 架构师：Manager过多
已有命名规则覆盖。NO CHANGE。QueueManager保留，因为它有明确状态所有权。

### Cycle 270 — 数据层：Mapper过多
部分成功。Remote/Persistence边界必须Mapper；Domain→Presentation可用轻量纯转换，不强制每类型一个Mapper类。

### Cycle 271 — 测试架构师：Mock泛滥
攻击成功。优先Fake/contract fixture；Mock只验证必要交互，行为正确性不能靠mock call count证明。

### Cycle 272 — 性能工程师：抽象层影响性能
攻击未证明普遍问题。NO CHANGE；只有profiling证据才能为性能绕过架构边界。

### Cycle 273 — 产品经理：设置项过多
攻击成功。V1设置只暴露用户真正理解且有稳定行为的选项；内部策略留内部。

### Cycle 274 — 安全工程师：过度安全导致自签名用户无法用
妥协。保持不允许全局忽略TLS；自定义CA列入后续明确功能，不阻塞V1。

### Cycle 275 — 普通用户：错误信息太技术化
已有Error Presentation覆盖。NO CHANGE；诊断详情与用户消息继续分离。

### Cycle 276 — 开发者：Feature Gate太复杂
部分成功。V1 Gate只保留会影响发布安全/未完成能力的项目，不给每个小功能建Gate。

### Cycle 277 — 开源维护者：ADR过度使用
攻击成功。只有跨模块/难逆转/高成本决策才需要ADR；普通实现选择直接PR说明。

### Cycle 278 — 项目经理：所有任务都要求大量文档
攻击成功。任务分为S/M/L风险等级，小任务required_docs可以极少，但仍必须遵守核心不变量。

### Cycle 279 — 反向重构演练
尝试把Repository/Provider/PlayerStateStore三者全部删掉，结果分别导致协议泄漏、未来服务器耦合、播放状态双源。REJECT。

### Cycle 280 — 架构挑战终审
删除“为未来而未来”的扩展点，保留能解决当前真实复杂度的边界；V1核心路径复杂度下降，无新增P0阻断。

### V26 结论
架构存在的理由不是“看起来专业”，而是降低真实风险。

```text
当前没有真实需求
+ 没有高概率返工风险
+ 没有安全/数据一致性价值
→ 不提前抽象
```

但已经证明承担真实边界职责的 Repository、最小 Provider Contract、PlayerStateStore 保留。

**结论：V26 / 280 CYCLES CONVERGED。**

## 2. 项目原则

整个项目必须遵守以下原则。

### 2.1 不允许 Demo 架构

禁止为了快速展示而：

-   把所有代码写入一个 Page
-   在 UI 中直接调用服务器 API
-   在 UI 中直接控制 AVPlayer
-   写死 Navidrome 地址
-   写死账号密码
-   写死播放 URL
-   写死 JSON 数据
-   使用不可维护的临时代码完成正式功能

每个功能都必须按照可持续维护的正式项目方式实现。

------------------------------------------------------------------------

## 3. 技术栈

优先采用：

-   HarmonyOS 原生应用
-   ArkTS
-   ArkUI
-   Stage 模型
-   HarmonyOS Media Kit
-   AVPlayer
-   HarmonyOS 本地数据能力
-   HarmonyOS 网络能力
-   HarmonyOS 后台任务能力
-   HarmonyOS 系统媒体控制能力

如有多个实现方案：

优先：

1.  HarmonyOS 官方 API
2.  稳定成熟方案
3.  最少第三方依赖
4.  可长期维护

不得为了方便随意引入大量第三方框架。

------------------------------------------------------------------------

## 4. 总体架构

必须采用分层架构。

基本结构：

``` text
SoundIsle
│
├── UI
├── ViewModel / State
├── Repository
├── Provider
├── Player
├── Database
├── Download
├── Cache
├── Network
└── System Integration
```

禁止：

``` text
页面
 ↓
直接访问 Navidrome
 ↓
直接播放
```

必须：

``` text
UI
 ↓
ViewModel
 ↓
Repository
 ↓
Provider
 ↓
Server
```

播放器独立：

``` text
UI
 ↓
PlayerController
 ↓
PlayerService
 ↓
AVPlayer
```

------------------------------------------------------------------------

## 5. Provider 架构

服务器必须使用 Provider 抽象。

定义：

``` text
MusicServerProvider
```

至少包含：

``` text
connect
authenticate
ping
getServerInfo
getSongs
getSong
getAlbums
getAlbum
getArtists
getArtist
getPlaylists
getPlaylist
search
getStreamSource
getCover
getLyrics
star
unstar
setRating
scrobble
getPlayQueue
savePlayQueue
```

不同服务器分别实现：

``` text
OpenSubsonicProvider
JellyfinProvider
EmbyProvider
AudioStationProvider
PlexProvider
```

UI 和 Player 不允许知道具体服务器类型。

------------------------------------------------------------------------

## 6. 第一优先服务器：OpenSubsonic

OpenSubsonic 是整个项目的最高优先级。

必须优先完整兼容：

``` text
Navidrome
OpenSubsonic Server
Subsonic Compatible Server
```

登录服务器时执行能力探测。

例如：

``` text
ping
↓
server info
↓
getOpenSubsonicExtensions
↓
生成 Capability
```

保存：

``` text
supportsLyrics
supportsStructuredLyrics
supportsTranscoding
supportsPlayQueue
supportsPlaybackReport
supportsApiKey
supportsSonicSimilarity
...
```

绝对不能假设所有 OpenSubsonic 服务器实现相同扩展。

必须：

``` text
能力检测
↓
有能力 → 使用
↓
无能力 → 自动降级
```

------------------------------------------------------------------------

## 7. 认证

OpenSubsonic 至少支持：

``` text
API Key
Token + Salt
传统兼容方式
```

如果服务器支持 API Key：

优先 API Key。

账号凭证必须使用 HarmonyOS 安全能力保存。优先使用 **Asset Store Kit /
系统关键资产存储能力** 保存密码、API Key、Token 等短敏感数据；普通
Preferences/RDB 只能保存非敏感配置和凭证引用，不得保存明文秘密。

禁止：

``` text
明文写入日志
明文保存数据库
URL 日志中暴露密码
```

日志系统必须自动脱敏：

``` text
password=***
token=***
apiKey=***
authorization=***
```

------------------------------------------------------------------------

## 8. 多服务器

必须支持保存多个服务器。

服务器对象：

``` text
ServerProfile

id
name
type

publicUrl
localUrl

username

authentication

enabled

priority
```

示例：

``` text
家里 Navidrome

局域网：
http://192.168.1.20:4533

公网：
https://music.example.com
```

------------------------------------------------------------------------

## 9. 内网 / 公网智能线路

这是核心功能。

每个服务器允许配置：

``` text
主线路
局域网线路
备用线路 1
备用线路 2
```

启动或恢复网络时自动检测。

优先顺序：

``` text
局域网
↓
公网主线路
↓
备用线路
```

但不能只通过 Ping 判断。

必须通过真实服务器 API 健康检查。

切换线路不得：

-   丢播放队列
-   丢当前位置
-   丢当前歌曲
-   导致 UI 卡死

正在播放情况下如果当前线路失败：

``` text
检测失败
↓
切换备用线路
↓
重新获取媒体 URL
↓
尽量从原播放位置继续
```

------------------------------------------------------------------------

## 10. 统一数据模型

至少建立：

``` text
Song
Album
Artist
Playlist
Genre
Lyrics
ServerProfile
AudioSource
PlayQueue
PlayHistory
DownloadTask
Favorite
```

Song 示例：

``` text
id
serverId
title
artistIds
artistNames
albumId
albumName
duration
track
disc
year
genre
coverId
suffix
codec
bitRate
bitDepth
sampleRate
channels
size
replayGain
starred
rating
```

不得依赖具体服务器返回格式直接渲染 UI。

Provider 必须转换为统一模型。

------------------------------------------------------------------------

## 11. 首页

首页至少包括：

``` text
继续播放
最近播放
最近添加
常听歌曲
常听专辑
随机推荐
音乐漫游
```

如果服务器没有某种能力：

自动隐藏相关模块。

首页内容必须异步加载。

不得让单个 API 失败导致整个首页空白。

------------------------------------------------------------------------

## 12. 音乐库

音乐库包含：

``` text
歌曲
专辑
艺术家
歌单
类型
已下载
收藏
```

支持：

``` text
排序
筛选
搜索
分页加载
下拉刷新
```

大量音乐库必须使用分页或懒加载。

禁止一次加载数万首歌曲阻塞 UI。

------------------------------------------------------------------------

## 13. 搜索

统一搜索：

``` text
歌曲
专辑
艺术家
歌单
```

搜索要求：

-   输入防抖
-   最近搜索
-   清除历史
-   分类型展示
-   分页
-   空状态
-   网络错误状态

后期支持：

``` text
跨服务器搜索
```

------------------------------------------------------------------------

## 14. 播放器核心

播放器是最高稳定性模块。

必须提供：

``` text
play
pause
resume
stop
seek
next
previous
playSong
playAlbum
playPlaylist
addNext
addToQueue
removeFromQueue
clearQueue
```

------------------------------------------------------------------------

## 15. 播放模式

支持：

``` text
顺序播放
列表循环
单曲循环
随机播放
```

随机模式必须保证：

-   不频繁重复歌曲
-   上一首能够回到真实播放历史

------------------------------------------------------------------------

## 16. 播放队列

队列必须独立保存。

数据包括：

``` text
songs
currentIndex
currentPosition
playMode
serverId
timestamp
```

App 被系统杀死后重新启动：

允许恢复：

``` text
歌曲
播放队列
播放位置
播放模式
```

------------------------------------------------------------------------

## 17. 播放页

完整播放页至少包含：

``` text
封面
歌曲名称
艺术家
专辑
播放进度
播放时间
歌曲总时长
上一首
播放/暂停
下一首
播放模式
收藏
播放队列
歌词
```

支持：

``` text
封面页
歌词页
```

自然切换。

------------------------------------------------------------------------

## 18. Mini Player

除播放器页面外：

底部保持 Mini Player。

显示：

``` text
封面
歌名
歌手
播放/暂停
下一首
```

点击进入完整播放器。

------------------------------------------------------------------------

## 19. 后台播放

必须达到正式音乐 App 标准。

场景：

``` text
锁屏
返回桌面
切换 App
屏幕关闭
```

音乐不得因为普通后台状态中断。

------------------------------------------------------------------------

## 20. 音频焦点

必须正确处理：

``` text
电话
语音消息
导航
其他音乐 App
系统声音
耳机插拔
蓝牙连接变化
```

不能粗暴继续播放。

必须按照 HarmonyOS 音频焦点机制处理暂停、Duck、恢复等状态。

------------------------------------------------------------------------

## 21. 系统媒体控制

必须使用 HarmonyOS **AVSession Kit**
维护系统可见的媒体会话、元数据、播放状态和控制命令，并结合 **Background
Tasks Kit** 按系统规范实现持续后台音乐播放。

支持 HarmonyOS：

``` text
媒体中心
锁屏
通知中心
蓝牙设备
耳机按钮
```

至少提供：

``` text
播放
暂停
上一首
下一首
歌曲信息
封面
播放位置
```

------------------------------------------------------------------------

## 22. 音频格式

尽可能支持：

``` text
MP3
AAC
M4A
FLAC
ALAC
OGG
OPUS
WAV
```

具体以 HarmonyOS 系统能力和服务端转码能力为准。

不支持的格式：

优先使用服务器转码。

------------------------------------------------------------------------

## 23. 服务端转码

支持：

``` text
Original
MP3
AAC
Opus
```

如服务器提供更多格式：

根据 Capability 扩展。

音质设置允许：

``` text
Wi-Fi 音质
移动网络音质
下载音质
```

例如：

``` text
Wi-Fi：
原始

移动网络：
AAC 256K

下载：
原始
```

------------------------------------------------------------------------

## 24. Gapless 无缝播放

必须设计支持无缝播放。

特别针对：

-   Live Album
-   Classical
-   DJ Mix
-   连续专辑

播放器架构不得写死为：

``` text
当前歌曲播放结束
↓
重新创建播放器
↓
下一首
```

需要研究并使用 HarmonyOS 能力实现尽可能平滑的切歌。

如果设备/API 本身存在限制：

必须实现最佳降级方案。

------------------------------------------------------------------------

## 25. 下一首预加载

当前歌曲播放过程中：

自动准备下一首。

至少：

``` text
提前解析下一首播放地址
提前读取 Metadata
提前加载封面
```

在适合情况下预缓冲媒体。

------------------------------------------------------------------------

## 26. ReplayGain

如果服务器返回 ReplayGain：

支持：

``` text
关闭
Track Gain
Album Gain
```

同时支持：

``` text
Preamp
```

如果系统播放链无法安全实现：

不得伪装已经支持。

需要保留架构接口并记录限制。

------------------------------------------------------------------------

## 27. 淡入淡出

提供：

``` text
关闭
1 秒
2 秒
3 秒
5 秒
自定义
```

不要让 Crossfade 破坏 Gapless。

两者设置必须互斥或根据场景智能处理。

------------------------------------------------------------------------

## 28. 歌词系统

必须建立独立：

``` text
LyricsProvider
```

优先顺序：

``` text
服务器歌词
↓
本地缓存歌词
↓
第三方歌词 API
```

------------------------------------------------------------------------

## 29. OpenSubsonic 歌词

如果支持：

``` text
getLyricsBySongId
```

优先使用结构化歌词。

支持：

``` text
普通歌词
LRC 同步歌词
多语言歌词
```

------------------------------------------------------------------------

## 30. 第三方歌词

预留：

``` text
LRCLIBProvider
CustomLyricsProvider
```

如果服务器没有歌词：

自动尝试备用 Provider。

匹配参数：

``` text
track
artist
album
duration
```

避免只通过歌曲名称匹配。

------------------------------------------------------------------------

## 31. 歌词显示

至少支持：

``` text
自动滚动
当前行高亮
点击歌词跳转
手动滚动
回到当前歌词
歌词延迟调整
```

目标支持：

``` text
逐字歌词
翻译歌词
多语言歌词
```

------------------------------------------------------------------------

## 32. 自定义 API

允许用户配置自定义接口，用于：

``` text
歌词
封面
Metadata
```

架构必须安全。

不得允许危险任意代码执行。

推荐采用：

``` text
URL Template
HTTP Method
Headers
Query
Response Mapping
```

方式。

敏感 Header 必须加密保存。

------------------------------------------------------------------------

## 33. 收藏

至少支持：

``` text
歌曲收藏
专辑收藏
艺术家收藏
```

服务器支持时：

同步到服务器。

离线时：

写入本地 pending operation。

恢复网络后同步。

------------------------------------------------------------------------

## 34. 评分

服务器支持时：

提供：

``` text
1-5 星
```

并同步服务器。

------------------------------------------------------------------------

## 35. Scrobble

必须正确调用服务器 Scrobble。

区分：

``` text
Now Playing
Played
```

避免：

-   打开歌曲立刻算播放一次
-   Seek 导致重复提交
-   暂停恢复重复提交

------------------------------------------------------------------------

## 36. 播放历史

本地保存：

``` text
播放歌曲
开始时间
结束时间
播放时长
是否完成
服务器
```

提供：

``` text
最近播放
播放次数
常听歌曲
```

------------------------------------------------------------------------

## 37. 歌单

必须支持：

``` text
创建
删除
改名
添加歌曲
删除歌曲
调整顺序
```

如果服务器支持：

同步服务器。

------------------------------------------------------------------------

## 38. 歌单导入导出

预留支持：

``` text
M3U
M3U8
```

如果导入内容无法匹配：

提供匹配结果。

不能静默丢弃。

------------------------------------------------------------------------

## 39. 下载

建立独立：

``` text
DownloadManager
```

支持：

``` text
单曲下载
专辑下载
歌单下载
批量下载
暂停
继续
失败重试
删除
```

------------------------------------------------------------------------

## 40. 下载策略

允许：

``` text
仅 Wi-Fi 下载
允许移动网络
并发任务数量
下载音质
```

------------------------------------------------------------------------

## 41. 离线模式

断网情况下仍可：

``` text
打开 App
查看已下载
播放已下载歌曲
查看缓存封面
查看缓存歌词
查看本地播放历史
```

不能出现整个首页无限 Loading。

------------------------------------------------------------------------

## 42. 缓存

区分：

``` text
图片缓存
Metadata 缓存
歌词缓存
音频缓存
正式下载
```

缓存可以自动清除。

用户下载不得因为清理缓存被删除。

------------------------------------------------------------------------

## 43. 下载完整性

下载完成必须验证。

至少记录：

``` text
预期大小
实际大小
状态
```

如果服务端支持校验信息：

使用校验值。

损坏文件不得标记为完成。

------------------------------------------------------------------------

## 44. 断点续传

服务器支持 Range 时：

实现断点续传。

不支持时：

安全重新下载。

------------------------------------------------------------------------

## 45. 多服务器统一库

架构必须从第一天支持。

即使 V1 UI 暂时不开放全部功能，也不能写死单服务器。

未来允许：

``` text
Navidrome A
Navidrome B
Jellyfin
```

同时存在。

Song 的唯一标识必须：

``` text
serverId + songId
```

不能只使用 songId。

------------------------------------------------------------------------

## 46. 跨服务器搜索

后续必须能够：

``` text
搜索一次
↓
同时请求多个服务器
↓
合并结果
```

并显示来源。

------------------------------------------------------------------------

## 47. 相同歌曲识别

预留媒体 Identity 层。

未来用于判断：

``` text
Server A 晴天.flac
Server B 晴天.mp3
```

属于同一首歌曲。

不要仅依赖文件名。

可以综合：

``` text
MusicBrainz ID
ISRC
Title
Artist
Album
Duration
Audio fingerprint
```

------------------------------------------------------------------------

## 48. 自动选源

未来支持同一首歌多个来源时：

优先考虑：

``` text
可访问性
局域网
音质
用户优先级
延迟
```

选择最佳来源。

------------------------------------------------------------------------

## 49. Jellyfin

V1 正式版需要支持 Jellyfin。

至少覆盖：

``` text
登录
音乐库
歌曲
专辑
艺术家
歌单
搜索
收藏
封面
播放
播放状态
```

与 OpenSubsonic 共用统一模型。

------------------------------------------------------------------------

## 50. Emby

采用独立 Provider。

不得简单假设 Jellyfin API 与 Emby 永久完全兼容。

------------------------------------------------------------------------

## 51. Plex

建立 PlexProvider。

认证流程与其他服务器隔离。

------------------------------------------------------------------------

## 52. Synology AudioStation

建立：

``` text
AudioStationProvider
```

支持群晖 NAS 用户。

认证和 Session 管理必须封装。

------------------------------------------------------------------------

## 53. 本地音乐

至少预留 LocalMusicProvider。

未来允许扫描：

``` text
手机音乐文件
用户授权目录
```

本地歌曲与服务器歌曲使用相同 Song 模型。

------------------------------------------------------------------------

## 54. WebDAV

作为扩展 Provider。

不要第一阶段优先开发。

架构需要允许未来增加：

``` text
WebDAVProvider
```

------------------------------------------------------------------------

## 55. 网络电台

支持：

``` text
Internet Radio
M3U8
```

服务器存在网络电台接口时：

读取服务器配置。

也允许用户手动添加。

------------------------------------------------------------------------

## 56. UI 导航

建议主导航：

``` text
首页
音乐库
搜索
我的
```

全局存在 Mini Player。

------------------------------------------------------------------------

## 57. "我的"

至少包含：

``` text
收藏
歌单
下载
播放历史
服务器
设置
```

------------------------------------------------------------------------

## 58. 服务器管理

用户可以：

``` text
添加
编辑
删除
启用
禁用
测试连接
切换默认服务器
```

删除服务器前：

提示本地下载处理方案。

------------------------------------------------------------------------

## 59. 首次使用

第一次启动：

``` text
欢迎
↓
添加服务器
↓
选择类型
↓
服务器地址
↓
认证信息
↓
测试连接
↓
成功
↓
进入主页
```

测试失败必须明确显示原因：

``` text
DNS
连接超时
TLS
401
认证失败
服务器版本不支持
API 不兼容
```

禁止统一显示：

``` text
连接失败
```

------------------------------------------------------------------------

## 60. HTTPS

公网服务器优先 HTTPS。

遇到非法证书：

不能默认无条件信任。

如果以后增加自签证书支持：

必须让用户明确选择。

------------------------------------------------------------------------

## 61. 错误系统

统一：

``` text
AppError
```

至少分类：

``` text
NetworkError
TimeoutError
AuthenticationError
ServerError
UnsupportedFeatureError
PlaybackError
DownloadError
DatabaseError
```

UI 根据类型给用户可理解提示。

------------------------------------------------------------------------

## 62. 日志

实现 Debug Log。

允许用户导出诊断日志。

日志不得包含：

``` text
密码
API Key
Token
Cookie
Authorization
完整敏感 URL
```

------------------------------------------------------------------------

## 63. 数据库

数据库至少保存：

``` text
servers
songs_cache
albums_cache
artists_cache
playlists_cache
history
queue
downloads
lyrics_cache
settings
pending_operations
```

实现 Schema Version。

数据库升级必须支持 Migration。

------------------------------------------------------------------------

## 64. 状态同步

修改：

``` text
收藏
评分
歌单
播放状态
```

时：

在线：

``` text
本地更新
+
服务器更新
```

离线：

``` text
本地更新
+
写 pending operation
```

恢复网络：

``` text
自动重试同步
```

------------------------------------------------------------------------

## 65. 性能

必须针对大音乐库设计。

测试数据至少模拟：

``` text
50,000 Songs
5,000 Albums
2,000 Artists
```

列表不得一次创建所有组件。

使用：

``` text
Lazy rendering
Pagination
Cache
```

------------------------------------------------------------------------

## 66. 图片

封面必须：

``` text
异步加载
缓存
占位图
失败重试
```

根据组件大小请求适当尺寸的封面。

不要列表缩略图下载超大原图。

------------------------------------------------------------------------

## 67. 平板

不能简单把手机 UI 拉宽。

至少设计响应式布局。

例如播放页：

手机：

``` text
封面
↓
信息
↓
控制
↓
歌词
```

平板：

``` text
封面          歌词
信息          歌词
控制          歌词
```

------------------------------------------------------------------------

## 68. 深色模式

完整支持：

``` text
跟随系统
浅色
深色
```

禁止在组件中大量写死颜色。

------------------------------------------------------------------------

## 69. 动态主题

可以根据专辑封面提取主题视觉。

但：

-   不影响文字可读性
-   不得导致频繁闪烁
-   低端设备需要能够关闭

------------------------------------------------------------------------

## 70. 无障碍

按钮必须具有语义描述。

支持系统字体缩放。

重要操作不能只靠颜色表达状态。

------------------------------------------------------------------------

## 71. 动画

动画用于：

``` text
页面过渡
播放器展开
封面切换
Mini Player
歌词
```

动画不得影响播放和列表性能。

------------------------------------------------------------------------

## 72. 网络变化

监听：

``` text
Wi-Fi → 蜂窝
蜂窝 → Wi-Fi
断网
重新联网
```

根据设置自动调整：

``` text
线路
转码
预缓存
下载
```

------------------------------------------------------------------------

## 73. 手机流量保护

设置：

``` text
移动网络播放
移动网络原始音质
移动网络下载
```

默认采用安全合理配置。

------------------------------------------------------------------------

## 74. Server Capability

每台服务器保存 Capability。

示例：

``` text
ServerCapability {
  structuredLyrics
  transcoding
  playQueue
  rating
  star
  scrobble
  apiKey
  sonicSimilarity
  internetRadio
}
```

UI 根据 Capability 展示。

不要让用户点击一个服务器根本不支持的功能后才报错。

------------------------------------------------------------------------

## 75. Feature Flag

复杂功能使用 Feature Flag。

例如：

``` text
multiServerSearch
wordByWordLyrics
gapless
crossfade
webdav
```

便于开发和测试。

------------------------------------------------------------------------

## 76. 设置

设置至少包含：

``` text
播放
音质
下载
歌词
缓存
服务器
外观
数据
网络
关于
开发者选项
```

------------------------------------------------------------------------

## 77. 播放设置

至少：

``` text
播放模式
Gapless
Crossfade
ReplayGain
预缓存
断点续播
```

------------------------------------------------------------------------

## 78. 音质设置

分别：

``` text
Wi-Fi
移动数据
下载
备用线路
```

------------------------------------------------------------------------

## 79. 歌词设置

支持：

``` text
字体大小
对齐
翻译
歌词延迟
歌词 Provider 顺序
```

------------------------------------------------------------------------

## 80. 缓存管理

显示：

``` text
图片缓存
歌词缓存
音乐缓存
总占用
```

支持：

``` text
分别清除
```

------------------------------------------------------------------------

## 81. 数据备份

预留导出：

``` text
服务器配置
App 设置
歌单
```

敏感账号数据默认不得明文导出。

------------------------------------------------------------------------

## 82. 隐私

App 本身不应上传用户音乐数据到开发者服务器。

外部 Metadata/Lyrics Provider 请求应在设置中说明。

如果功能不需要自己的云端：

不要引入自己的云端账号系统。

------------------------------------------------------------------------

## 83. 测试策略

每完成一个模块必须进行：

``` text
编译测试
单元测试
集成测试
手动场景检查
```

------------------------------------------------------------------------

## 84. Provider 单元测试

Provider 必须通过 Mock JSON 测试。

至少测试：

``` text
正常响应
空响应
字段缺失
旧版本服务器
扩展不存在
401
403
404
500
Timeout
Malformed JSON
```

------------------------------------------------------------------------

## 85. Player 测试

必须覆盖：

``` text
播放
暂停
Seek
下一首
上一首
单曲循环
随机
切线路
网络断开
网络恢复
后台
前台
耳机拔出
来电
```

------------------------------------------------------------------------

## 86. Download 测试

包括：

``` text
正常完成
中途断网
恢复下载
存储不足
服务器关闭
URL 失效
删除任务
重复下载
```

------------------------------------------------------------------------

## 87. 数据库测试

包括：

``` text
第一次创建
版本升级
Migration
大量数据
异常退出恢复
```

------------------------------------------------------------------------

## 88. 性能测试

至少检查：

``` text
冷启动
主页加载
50000 首歌曲列表
快速滑动
封面加载
内存占用
后台播放
连续播放数小时
```

------------------------------------------------------------------------

## 89. AI 自动执行规则

你必须自己持续推进。

每次开始任务：

``` text
检查当前代码
↓
读取 TODO
↓
读取编译错误
↓
选择最高优先级未完成任务
↓
实现
↓
编译
↓
测试
↓
修复
↓
再次测试
↓
记录进度
↓
继续下一任务
```

不要每完成一个小功能就停止询问用户。

------------------------------------------------------------------------

## 90. AI 禁止行为

禁止：

``` text
“下面是示例代码，你自己集成”
“由于项目较大，我先给框架”
“剩下功能以后再实现”
“这里先用 TODO”
“为了演示写死数据”
“假设接口返回如下”
“测试需要你自己进行”
```

除非外部硬件、账号或真实服务器确实只有用户才能提供。

------------------------------------------------------------------------

## 91. TODO 规则

允许存在 TODO 的唯一情况：

当前阶段明确尚未开始的功能。

当前阶段正在实现的功能：

不允许通过 TODO 假装完成。

------------------------------------------------------------------------

## 92. 编译规则

任何一次较大的修改完成后：

必须运行真实构建。

如果构建失败：

继续修复。

直到：

``` text
BUILD SUCCESS
```

才允许把该任务标记完成。

------------------------------------------------------------------------

## 93. 测试失败规则

测试失败：

``` text
不得跳过
不得删除测试
不得通过注释代码绕过
```

必须定位原因并修复。

------------------------------------------------------------------------

## 94. API 不确定时

如果 API 行为不确定：

优先：

``` text
官方 HarmonyOS 文档
官方 OpenSubsonic 文档
官方服务器文档
真实服务器响应
```

不得凭记忆编造接口。

------------------------------------------------------------------------

## 95. 兼容性原则

OpenSubsonic / Jellyfin / Emby 等服务器版本可能不同。

所有响应解析必须：

``` text
允许可选字段缺失
提供默认值
检查 Capability
避免强制断言
```

------------------------------------------------------------------------

## 96. 网络请求

必须包含：

``` text
Timeout
Retry
Cancellation
Error mapping
```

搜索请求切换关键词时：

取消旧请求。

------------------------------------------------------------------------

## 97. 播放错误恢复

播放失败时：

根据错误自动尝试：

``` text
刷新播放 URL
↓
切备用线路
↓
尝试服务器转码
↓
提示用户
```

不能无限循环重试。

------------------------------------------------------------------------

## 98. 用户体验底线

禁止：

-   无限 Loading
-   点击无反应
-   错误无提示
-   页面空白
-   播放器状态与声音不同步
-   进度条乱跳
-   重复加入歌曲
-   下载假完成
-   歌词明显错歌却自动使用

------------------------------------------------------------------------

## 99. 开发阶段

按下面顺序推进。

### Phase 0

项目初始化。

完成：

``` text
目录结构
基础主题
Router
日志
网络
数据库
错误系统
测试框架
```

### Phase 1

OpenSubsonic 服务器连接。

完成：

``` text
添加服务器
认证
Ping
Capability
保存服务器
编辑
删除
测试连接
```

验收：

真实 Navidrome 可以成功连接。

### Phase 2

音乐库。

完成：

``` text
歌曲
专辑
艺术家
歌单
搜索
封面
分页
缓存
```

验收：

能够正常浏览真实 Navidrome 音乐库。

### Phase 3

播放器。

完成：

``` text
AVPlayer
播放
暂停
Seek
上下首
队列
播放模式
Mini Player
完整播放页
```

验收：

可以连续正常播放真实服务器音乐。

### Phase 4

系统播放能力。

完成：

``` text
后台播放
音频焦点
锁屏
媒体中心
耳机
蓝牙
状态恢复
```

### Phase 5

歌词。

完成：

``` text
OpenSubsonic Lyrics
结构化歌词
LRC
歌词缓存
LRCLIB
Custom Lyrics API
```

### Phase 6

收藏和歌单。

完成：

``` text
收藏
评分
Scrobble
播放历史
歌单
同步
离线 Pending Operation
```

### Phase 7

下载与离线。

完成：

``` text
DownloadManager
断点续传
下载管理
离线库
下载音质
缓存管理
```

### Phase 8

高级播放器。

完成：

``` text
转码
预缓存
Gapless
ReplayGain
Crossfade
线路切换
```

### Phase 9

Jellyfin。

完成完整 Provider。

### Phase 10

Emby。

完成完整 Provider。

### Phase 11

AudioStation。

完成完整 Provider。

### Phase 12

Plex。

完成完整 Provider。

### Phase 13

多服务器。

完成：

``` text
服务器切换
统一搜索
线路优先
Source Identity
```

### Phase 14

HarmonyOS 深度适配。

完成：

``` text
手机
平板
折叠屏
深色模式
系统媒体
多设备能力评估
```

### Phase 15

Release Candidate。

执行：

``` text
全量测试
性能优化
内存检查
网络异常测试
后台长时间测试
数据库升级测试
安装升级测试
UI 修复
无障碍检查
安全检查
日志脱敏检查
```

------------------------------------------------------------------------

## 100. V1.0 发布条件

以下项目全部满足才能称为 V1.0：

``` text
应用可正常构建
无 P0 / P1 Bug
Navidrome 完整可日常使用
OpenSubsonic 核心功能完整
Jellyfin 可日常使用
Emby 可日常使用
AudioStation 可日常使用
Plex 可日常使用
后台播放稳定
系统媒体控制正常
歌词稳定
收藏正常
歌单正常
搜索正常
下载正常
离线播放正常
转码正常
多线路正常
长时间连续播放稳定
平板布局正常
深色模式正常
数据库升级正常
```

------------------------------------------------------------------------

## 101. 验收原则

不要以：

``` text
“代码写了”
```

作为完成。

必须以：

``` text
功能真实运行
+
编译通过
+
测试通过
+
异常情况可控
```

作为完成。

------------------------------------------------------------------------

## 102. 项目进度文件

在仓库根目录创建：

``` text
PROJECT_STATUS.md
```

内容维护：

``` text
当前版本
当前阶段
已完成
进行中
下一步
已知 Bug
技术债
测试状态
```

每完成重要任务自动更新。

------------------------------------------------------------------------

## 103. 项目决策记录

创建：

``` text
docs/adr/
```

重大架构变化写 ADR。

例如：

``` text
0001-provider-architecture.md
0002-player-architecture.md
0003-database.md
0004-download-manager.md
```

避免后续 AI 不知道之前为什么这样设计而重新推翻架构。

------------------------------------------------------------------------

## 104. API 能力表

创建：

``` text
docs/server-capabilities.md
```

维护：

``` text
OpenSubsonic
Navidrome
Jellyfin
Emby
AudioStation
Plex
```

对应：

``` text
Lyrics
Rating
Star
Playlist
Scrobble
Transcode
Download
PlayQueue
Radio
ReplayGain
```

实际实现以后持续更新。

------------------------------------------------------------------------

## 105. AI 上下文恢复

为了支持下一次换一个 AI 继续开发：

必须保持以下文件最新：

``` text
README.md
PROJECT_STATUS.md
ARCHITECTURE.md
ROADMAP.md
docs/server-capabilities.md
docs/adr/
```

新 AI 第一步必须先读取这些文件。

然后：

``` text
检查 Git 状态
↓
检查最近 Commit
↓
运行 Build
↓
运行 Tests
↓
继续当前任务
```

------------------------------------------------------------------------

## 106. Git 规则

每完成一个独立可运行功能：

创建一个清晰 Commit。

例如：

``` text
feat: add OpenSubsonic authentication
feat: add album browsing
feat: implement persistent play queue
fix: restore playback after network switch
```

不得把几十个无关功能堆进一个 Commit。

------------------------------------------------------------------------

## 107. 版本规则

开发版本：

``` text
0.1.x
0.2.x
...
```

功能达到发布标准以后：

``` text
1.0.0
```

------------------------------------------------------------------------

## 108. 最终质量目标

用户不需要知道：

``` text
OpenSubsonic
Jellyfin API
AVPlayer
Provider
Transcoding
```

用户体验应该只是：

``` text
安装
↓
添加自己的服务器
↓
登录
↓
看到自己的音乐
↓
播放
```

技术复杂性全部隐藏在 App 内部。

------------------------------------------------------------------------

## 109. 最重要的项目要求

始终牢记：

> 这是准备真正长期使用的音乐播放器，不是教学 Demo。

> 不要为了短期跑通牺牲后期架构。

> 不要把未实现功能写成已完成。

> 不要遇到错误就停止，把错误解决后继续。

> 不要每一步都询问用户。

> 能通过代码、官方文档、日志、测试自行判断的事情自行完成。

> 每个阶段结束后自动进入下一阶段。

> 保证任何时候仓库都尽量处于可编译、可测试、可继续开发状态。

最终目标：

> 做出一款 HarmonyOS 原生私人音乐播放器，在核心 NAS
> 音乐使用体验上至少达到音流级别，并在 OpenSubsonic、HarmonyOS
> 原生体验、后台播放、多线路、离线下载和多服务器方面形成自己的优势。

------------------------------------------------------------------------

# 109A. 多角色联合审批结论

本任务书经过以下角色视角审查。AI
在实现时必须同时满足这些视角，而不能只追求"功能写完"。

## 产品负责人审批

**结论：通过。**

必须把"达到音流级别"转换成可验证能力，而不是主观口号。

V1 功能分为：

-   **P0：必须完成**：OpenSubsonic/Navidrome、稳定播放、后台/系统媒体控制、音乐库、搜索、歌词、收藏/歌单、下载离线、转码、线路切换、恢复能力。
-   **P1：正式版目标**：Jellyfin、Emby、AudioStation、Plex、多服务器基础能力、ReplayGain、Gapless
    的可验证实现。
-   **P2：增强项**：跨服务器去重/自动选源、WebDAV、逐字歌词、复杂动态主题、更多分布式能力。

原则：**P0 不稳定时禁止为了"功能数量"提前堆 P2。**

------------------------------------------------------------------------

## HarmonyOS 首席架构师审批

**结论：通过，但增加平台基线门禁。**

项目初始化时必须在 `ARCHITECTURE.md` 记录：

``` text
DevEco Studio version
HarmonyOS SDK version
compileSdk/API version
compatibleSdk/minimum API
target device types
ArkTS language constraints
```

不得在整个项目开发过程中随意升级 SDK。升级 SDK 必须：

``` text
建立升级分支
→ 阅读官方变更
→ 构建
→ 回归 Player / Background / AVSession / Database
→ 记录 ADR
→ 再合并
```

HarmonyOS 官方能力优先级：

``` text
Media Kit / AVPlayer
Audio Kit
AVSession Kit
Background Tasks Kit
ArkData (RDB / Preferences)
Asset Store Kit
Network Kit / 系统网络能力
Core File Kit
```

具体 API 名称、起始 API Level 和限制必须以当前项目 SDK
与华为官方文档为准，不得凭模型记忆硬编码。

------------------------------------------------------------------------

## 音频播放器工程师审批

**结论：有条件通过。**

播放器必须进一步建立明确状态机，例如：

``` text
Idle
Preparing
Ready
Playing
Paused
Buffering
Seeking
Completed
Error
Released
```

任何 UI 状态必须来源于 Player State，不得自己猜测。

必须处理：

``` text
快速连续切歌
连续 Seek
播放 URL 过期
网络从 Wi-Fi 切蜂窝
蓝牙断开
耳机拔出
系统抢占音频焦点
后台恢复
播放器资源释放
服务器转码中断
下一首预加载失败
```

Gapless、Crossfade、ReplayGain 不允许仅通过"有设置开关"验收。

每项高级音频功能必须有：

``` text
能力实现说明
支持条件
降级路径
可复现测试方法
实际测试结果
```

如果 HarmonyOS 当前公开 API 无法做到真正 Sample-Accurate
Gapless，则必须明确标记限制，不得宣称"完美无缝"。

------------------------------------------------------------------------

## OpenSubsonic / API 架构师审批

**结论：通过，但 Provider 合同需要更严格。**

OpenSubsonic 的认证策略必须基于服务器能力协商。API Key 是 OpenSubsonic
扩展；传统 Subsonic 兼容场景仍可能使用 token +
salt。禁止同时发送冲突认证方式。

所有 Provider 统一返回领域模型，同时保留：

``` text
raw server id
server id
provider type
capability snapshot
source revision / etag（存在时）
```

OpenSubsonic 实现必须优先 ID3 组织方式：

``` text
getArtists
getArtist
getAlbum
getSong
```

文件树接口只作为兼容/特殊浏览能力，不应作为默认音乐库模型。

API 客户端应优先根据官方 OpenAPI/接口文档建立可测试合同。每个 Provider
必须保存一组脱敏后的响应 Fixtures，用于回归解析器。

------------------------------------------------------------------------

## 安全工程师审批

**结论：原文不足，优化后通过。**

必须建立 `docs/SECURITY.md`，至少包含：

``` text
Threat Model
Credential Storage
TLS Policy
Logging Redaction
Custom API Security
Dependency Security
Export/Backup Security
Vulnerability Reporting
```

禁止：

-   默认信任无效 TLS 证书
-   在日志输出完整 Authorization / Cookie / API Key
-   把真实服务器账号提交进 Fixtures
-   Custom API 执行任意 JS/ArkTS
-   Custom API 读取任意本地文件
-   Custom API 任意访问 App 私有凭证
-   自动把 HTTP 凭证升级/转发到未知 Host
-   跟随跨 Host 重定向时无条件携带 Authorization

对于服务器地址、重定向和自定义 API 必须考虑
SSRF/本地网络访问边界；这是私人 NAS
客户端，不能简单禁止局域网地址，但必须避免第三方 Provider 利用 App
窃取局域网资源或凭证。

------------------------------------------------------------------------

## 隐私负责人审批

**结论：通过。**

默认坚持 Local-First。

第三方歌词/Metadata 服务调用前，产品必须能说明可能发送：

``` text
歌曲名
艺术家
专辑
时长
```

不得默认发送：

``` text
服务器地址
用户名
本地文件路径
设备唯一标识
用户私人歌单内容
```

除非功能确实需要且用户明确知情。

建立 `PRIVACY.md`，说明 SoundIsle
本身是否收集数据。没有自建遥测服务器时，不要为了"统计"临时增加用户追踪。

------------------------------------------------------------------------

## QA 负责人审批

**结论：原文测试范围够大，但缺少可量化门禁；优化后通过。**

测试状态统一为：

``` text
NOT_STARTED
IMPLEMENTED
AUTO_TESTED
DEVICE_TESTED
BLOCKED
FAILED
DONE
```

禁止只有 `DONE / TODO` 两种状态。

建立 `docs/test-matrix.md`。

至少包含：

  场景                 自动测试       模拟器           真机       状态
  -------------------- -------------- ---------------- ---------- ------
  OpenSubsonic 登录    必须           可选             必须       \-
  网络播放             部分           可选             必须       \-
  后台播放             不足           不作为最终依据   必须       \-
  AVSession/锁屏控制   部分           可选             必须       \-
  蓝牙控制             否             否               必须       \-
  下载/断点续传        必须           可               必须抽测   \-
  数据库迁移           必须           可               抽测       \-
  深色模式             可做 UI 测试   可               抽测       \-

AI 没有真机时，可以完成代码和自动测试，但相关项必须保持
`UNVERIFIED/DEVICE_TEST_REQUIRED`，不得冒充验收通过。

------------------------------------------------------------------------

## DevOps / Release 工程师审批

**结论：通过，但必须保证可复现。**

依赖必须锁定版本。

必须维护：

``` text
BUILDING.md
CHANGELOG.md
THIRD_PARTY_NOTICES.md
```

Release 必须记录：

``` text
版本号
Git commit SHA
DevEco Studio version
SDK version
构建类型
签名状态
已知问题
测试矩阵摘要
```

不得把开发机绝对路径、密钥路径、私有服务器地址写入项目配置。

Release Candidate
必须从干净工作区重新构建，而不是只依赖开发过程中残留缓存。

------------------------------------------------------------------------

## UI/UX 负责人审批

**结论：通过，但禁止"功能齐全、体验混乱"。**

所有核心页面必须具备完整状态：

``` text
Loading
Content
Empty
Offline
Partial Error
Fatal Error
```

服务器慢时优先显示缓存数据并标记刷新状态，不要整页白屏等待。

核心交互要求：

-   播放按钮必须立即给出状态反馈。
-   收藏/歌单操作采用乐观更新时必须支持失败回滚。
-   删除下载、服务器等破坏性操作必须明确确认。
-   当前服务器/线路/离线状态在需要时可被用户理解，但不要把技术细节塞满普通界面。
-   平板/折叠屏采用响应式布局，不做简单等比拉伸。
-   首次连接服务器的失败原因必须可操作，例如"证书无效""认证失败""连接超时"，并提供下一步提示。

------------------------------------------------------------------------

## 开源合规负责人审批

**结论：通过。**

Apache-2.0 可以作为 SoundIsle
自身许可证，但这并不意味着所有第三方代码都能直接合并。

引入依赖前记录：

``` text
dependency
version
source
license
notice requirement
reason
```

强 Copyleft 依赖、闭源 SDK
或许可证不清晰组件必须先评估，不得为了省开发时间直接复制。

音流 StreamMusic
只作为功能/体验对标对象。不得反编译、复制其闭源实现、图标、品牌素材、文案或私有资源。

------------------------------------------------------------------------

# 109B. 需求追踪与"完成证据"

建立：

``` text
docs/requirements-traceability.md
```

每一个 P0/P1 功能必须有唯一 ID，例如：

``` text
PLAY-001 播放/暂停
PLAY-002 Seek
SYS-001 后台播放
SYS-002 AVSession
SUB-001 OpenSubsonic 登录
SUB-002 音乐库
DL-001 单曲下载
LYR-001 服务器歌词
```

每项至少关联：

``` text
需求
实现文件
自动测试
真机测试（需要时）
已知限制
状态
```

AI 判断"完成"必须给出证据，而不是自然语言自评。

------------------------------------------------------------------------

# 109C. Provider 合同与兼容性测试

每种服务端建立独立兼容性矩阵：

``` text
Navidrome
OpenSubsonic reference/compatible server
Jellyfin
Emby
AudioStation
Plex
```

至少记录：

``` text
tested server version
authentication method
library browse
search
stream
cover
lyrics
favorite
playlist
transcode
download
scrobble
known quirks
```

无法实际连接某服务端时：

``` text
代码实现 ≠ 兼容性验证
```

状态必须标记为 `IMPLEMENTED_UNVERIFIED`。

------------------------------------------------------------------------

# 109D. 数据与数据库可靠性门禁

数据库 Migration 必须满足：

1.  Migration 单向可重复测试。
2.  升级前后的关键数据数量可核对。
3.  Migration 失败不得静默清空数据库。
4.  下载记录和服务器配置不得因为普通版本升级丢失。
5.  敏感凭证与普通业务数据分离。
6.  数据库 schema 必须有明确版本号。
7.  缓存数据可以重建，用户创建的数据必须优先保护。

Release Candidate 至少测试：

``` text
fresh install
N-1 → N upgrade
异常终止后重启
缓存损坏恢复
数据库部分异常
```

------------------------------------------------------------------------

# 109E. 网络与弱网工程门禁

统一 Network Layer 必须具备：

``` text
connect timeout
read timeout
request cancellation
bounded retry
exponential backoff（适用时）
request id
error mapping
network state awareness
```

禁止所有错误无脑自动重试。

以下请求默认不应自动无限重试：

``` text
创建/修改歌单
评分
收藏写操作
删除操作
```

需要通过幂等策略或 Pending Operation 避免重复写入。

线路健康评分不能只看一次延迟，应综合：

``` text
API health
近期失败率
连接耗时
当前网络类型
用户优先级
```

------------------------------------------------------------------------

# 109F. 性能预算

在真实设备条件允许时建立基线并持续记录，而不是写死不现实的绝对数字。

至少追踪：

``` text
cold start
home first content
library scroll jank
memory while playing
memory after 2h playback
CPU while screen off
battery impact
cover cache hit rate
network requests per track
```

性能回归超过项目基线阈值时必须调查。

------------------------------------------------------------------------

# 109G. 发布阻断级别

Bug 统一分级：

``` text
P0 = 数据丢失 / 安全问题 / 无法启动 / 大范围无法播放
P1 = 核心功能不可用 / 后台播放严重异常 / 下载损坏 / 认证异常
P2 = 有替代路径的功能缺陷
P3 = 轻微 UI / 文案 / 边缘问题
```

V1.0：

``` text
P0 = 0
P1 = 0
P2 = 必须记录并评估
P3 = 可进入已知问题
```

安全漏洞不因"功能能用"而降级。

------------------------------------------------------------------------

# 109H. AI 决策优先级

发生规范冲突时按以下顺序：

1.  用户最新明确要求。
2.  安全、隐私、数据完整性。
3.  当前 HarmonyOS 官方 SDK/API 实际约束。
4.  本 `MASTER_PLAN.md`。
5.  `ARCHITECTURE.md` 中已批准 ADR。
6.  `ROADMAP.md`。
7.  AI 自己的偏好。

如果官方 API 与本文中的具体 API 名称发生变化，以官方当前 SDK
为准，并更新本文/ADR，而不是强行使用过时名称。

# 110. AI 自动完成协议

本节优先级高于普通开发建议。

AI 的目标不是"给出如何开发 SoundIsle
的回答"，而是**在拥有仓库和开发工具的环境中实际完成 SoundIsle**。

## 110.1 持续执行

只要还有当前 Phase 内可独立完成的任务，AI 必须继续工作。

不得因为：

-   单次修改较大
-   文件较多
-   Token/上下文较长
-   已经完成一个页面
-   已经完成一个 Provider
-   已经给出开发总结

而主动结束开发。

如果环境限制导致一次会话无法完成全部项目，必须在结束前更新
`PROJECT_STATUS.md`，使下一位 AI 可以无歧义继续。

## 110.2 遇到错误

遇到编译、类型、API、测试或运行错误：

``` text
读取完整错误
→ 定位根因
→ 查阅项目代码/官方文档
→ 修改
→ 重新构建
→ 重新测试
→ 直到通过或确认存在真实外部阻塞
```

不得通过删除功能、注释测试、吞掉异常或伪造成功结果绕过问题。

## 110.3 外部阻塞

只有以下情况可以请求用户：

-   需要真实 Navidrome/Jellyfin/Emby/Plex/AudioStation
    测试账号且仓库没有测试配置。
-   需要用户在 HarmonyOS 真机上执行只能人工完成的操作。
-   需要正式签名证书/发布证书。
-   需要开发者账号权限。
-   两个产品方案存在重大、不可逆且无法从本任务书判断的取舍。

请求用户前，必须先完成所有不依赖该信息的任务。

## 110.4 真实性

AI 不得声称：

-   "已真机测试"，除非确实完成。
-   "所有服务器兼容"，除非有对应测试证据。
-   "Gapless 完美"，除非经过可验证测试。
-   "BUILD SUCCESS"，除非实际运行构建成功。
-   "V1.0 完成"，除非第 100 节发布条件全部满足。

所有无法验证的项目必须在 `PROJECT_STATUS.md` 标为 `UNVERIFIED`，而不是
`DONE`。

## 110.5 完成定义

一个任务只有同时满足以下条件才是 DONE：

``` text
实现完成
+
代码可维护
+
构建通过
+
自动测试通过（适用时）
+
真实场景验证完成（适用时）
+
错误路径已处理
+
文档已更新
```

## 110.6 最终交付

最终 V1.0 至少应产出：

``` text
可构建的 HarmonyOS 项目源码
README.md
LICENSE
THIRD_PARTY_NOTICES.md
MASTER_PLAN.md
ARCHITECTURE.md
ROADMAP.md
PROJECT_STATUS.md
CHANGELOG.md
docs/server-capabilities.md
docs/adr/
自动测试
CI 配置
正式版本号
可复现构建说明
安装/服务器连接说明
```

如具备签名和构建环境，再生成可安装发布产物；没有签名条件时，不得伪造发布包。

------------------------------------------------------------------------

# 111. AI 启动指令

任何编程 AI 接收到本仓库后，直接执行以下指令：

> 阅读仓库根目录 `MASTER_PLAN.md`，把它视为 SoundIsle
> 项目的最高级产品与工程规范；随后优先读取
> `CURRENT_MILESTONE.md`、`PROJECT_STATUS.md` 与
> `TASKS.md`，以当前里程碑为实际执行范围。不要只向用户解释计划。立即检查仓库、Git
> 状态、现有代码、构建环境和项目状态文件；建立真实构建/测试基线；然后从最早未完成阶段开始持续实现。你负责架构、编码、测试、修复、文档和
> Git
> 进度维护。除非出现本文件定义的真实外部阻塞，否则不要等待用户逐步下达下一项任务。任何功能只有实际实现并通过适用的构建和测试后才能标记完成。始终保持仓库可继续开发，并持续推进直到达到
> V1.0 发布条件。
