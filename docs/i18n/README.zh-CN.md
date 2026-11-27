<p align="center"><a href="../../README.md">English</a> · <b>简体中文</b> · <a href="README.hi.md">हिन्दी</a> · <a href="README.es.md">Español</a> · <a href="README.fr.md">Français</a> · <a href="README.ru.md">Русский</a> · <a href="README.uk.md">Українська</a></p>

<p align="center"><img src="../../site/assets/icon.png" alt="LiveBridge 应用图标" width="144"></p>

<h1 align="center">LiveBridge</h1>

<p align="center"><strong>用语音与已打开的 Claude Code 会话对话。</strong></p>

<p align="center">适合在 Apple Silicon Mac 上使用 Claude Code、且所用 ChatGPT 套餐的 Codex 包含语音的用户。</p>

<p align="center">
  <a href="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml"><img src="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/getLiveBridge/LiveBridge"><img src="https://api.scorecard.dev/projects/github.com/getLiveBridge/LiveBridge/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://www.bestpractices.dev/projects/16502"><img src="https://www.bestpractices.dev/projects/16502/badge" alt="OpenSSF Best Practices"></a>
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey.svg" alt="平台：Apple Silicon 上的 macOS 14+">
</p>

<p align="center">
  <a href="https://getlivebridge.com">getlivebridge.com</a> ·
  <a href="#快速开始">快速开始</a> ·
  <a href="#安装">安装</a> ·
  <a href="#使用">使用</a> ·
  <a href="#按需计费的设计">计费</a> ·
  <a href="#隐私">隐私</a> ·
  <a href="#已知限制">限制</a> ·
  <a href="#路线图与欢迎协助">欢迎协助</a> ·
  <a href="#参与贡献">参与贡献</a>
</p>

LiveBridge 是一款 macOS 菜单栏应用，它通过 `codex app-server`，使用你的 ChatGPT 登录（无需 API 密钥）保持一条随时可用的
GPT-Live 语音线路。语音相当于前台接待：它负责闲聊、询问你的意思，并通过一个小型 Claude Code 模组 `livebridge`
把真正的工作交给你的 Claude Code 会话。Claude 用自己的模型、工具和权限模式完成工作，再由语音把结果告诉你。
Claude 工作时你不必让线路一直打开：它的答复会重新打开已关闭的线路，并交给语音去说。语音还会跟进你在会话中输入的内容和 Claude 的答复，所以你可以在说话和打字之间随意切换。

*英文原文为准（[README.md](../../README.md)）；本译文可能滞后。*

**是对话，不是听写。** GPT-Live 一边说一边听：你随时打断，它就停下来听你说；你边想边说时，它还可能插一句“嗯”。**谈话安静下来，线路就关闭：** OpenAI 按分钟计算语音费用，所以静默达到你在[设置](guide.zh-CN.md#设置)中设定的时长（默认 20 秒）后线路会关闭，你一开口就重新打开，对话从上次停下的地方继续。关闭前的这段静默照样计费，交接之后等待 Claude 答复的最多 2 分钟也计费；**Mute** 不会关闭线路，所以省不下分钟数（[计费](#按需计费的设计)）。

<p align="center"><img src="../assets/readme-demo.gif" alt="通过 LiveBridge 与 Claude Code 会话对话" width="100%"></p>

<p align="center">GIF 没有声音：<a href="https://getlivebridge.com/assets/livebridge-demo.mp4">在 getlivebridge.com 观看 64 秒的有声演示</a>。</p>

**设计上完全本地。** 没有遥测，也没有自己的服务器：LiveBridge 只是你 Mac 上的一座桥，连接你自己的 codex 与你自己的
Claude Code。应用与模组之间通过只有你的用户才能打开的 Unix 套接字通信，应用不监听任何网络端口。除了这两个工具本来就会发送的内容
（语音线路经你的 codex 发往 OpenAI，仅在线路打开期间，其中包括你在已加入的会话中输入的内容；Claude 的工作经你的 Claude Code 会话发往 Anthropic），
应用自身唯一的流量是：你打开菜单时，一个短时运行的 codex 向 OpenAI 请求你的 Codex 用量数据（通话关闭时同样如此），以及用于[更新](guide.zh-CN.md#更新应用)的流量：向 GitHub 自动检查是否有新版本（每天一次，以及在它通知过的版本尚未安装时的每次启动），可以关闭；
你点击 **Check for update** 时的同一检查；通知新版本时的 `gh auth status`；以及你点击 **Install** 时的下载、验证和模组更新。
[隐私](privacy.zh-CN.md)准确列出了哪些内容会到达 OpenAI，并列出应用向 GitHub 发出的请求；[SECURITY.md](../../SECURITY.md) 说明了它能防范什么、不能防范什么。

> **状态：** 0.x，一位维护者。**非官方项目：** 与 Anthropic 或 OpenAI 无任何隶属、认可或支持关系。LiveBridge
> 在你的 ChatGPT 登录上使用 codex 的实验性实时 API，OpenAI 并未将其作为第三方应用的途径写入文档，任何一次 codex
> 发布都可能使它失效。使用风险由你自行承担。
>
> **需要：** Apple Silicon 上的 macOS 14 或更高版本、Claude Code 2.1.301 或更高版本，以及已登录（`codex login`）到其
> Codex 包含语音的 ChatGPT 套餐的 [codex](https://github.com/openai/codex)；语音分钟数计入该套餐。若要自行构建应用，还需要带
> Swift 6.0 或更高版本的 Xcode。详情见[系统要求](#系统要求)。

## 快速开始

```sh
# 1. The app, from LiveBridge's own Homebrew tap
brew install --cask getlivebridge/tap/livebridge

# 2. The mod, from this repository's marketplace
claude plugin marketplace add getLiveBridge/LiveBridge
claude plugin install livebridge@livebridge
```

3. 从“应用程序”中打开 LiveBridge。首次打开时，macOS 会询问是否打开从互联网下载的应用；点击 **Open**。LiveBridge 在菜单栏中运行。
4. 在你想与之对话的 Claude Code 会话中输入 `/live`。它会回答 “Joined LiveBridge.”，提示输入框上方会出现状态条：**Voice off**、通话所对应的会话，以及 **Start**。
5. 点击 **Start**。首次使用时，macOS 会请求麦克风权限：请允许。它还可能询问 LiveBridge 能否查找本地网络上的设备；语音线路也需要这项权限。状态条随后显示 **Listening**：你 Mac 上的语音检测器在等你开口，此时还没有发送任何内容。
6. 问一句“这个会话在做什么？”。状态条先显示 **Connecting**，再显示 **Live**，语音会根据会话的对话作答，或把问题交给 Claude。请它做一项修改，语音会把它交给 Claude，并在 Claude 完成后告诉你结果。谈话安静下来后，线路关闭，状态条重新显示 **Listening**（[何时关闭](#按需计费的设计)）。

没有 Homebrew？每个[发布版本](https://github.com/getLiveBridge/LiveBridge/releases/latest)都附有由 GitHub Actions 构建并出具证明的磁盘映像形式的应用（[通过磁盘映像安装](#通过磁盘映像安装)），你也可以自行构建（[从源码构建](#从源码构建)）。无论哪种方式，模组的安装方法都相同。

如果在已经打开的会话中找不到 `/live`，请重新打开该会话（[原因](#已知限制)）。磁盘映像、从源码构建和权限见[安装](#安装)；其余内容见[更新应用](guide.zh-CN.md#更新应用)、[卸载](guide.zh-CN.md#卸载)和[使用](#使用)。

## 系统要求

- Apple Silicon 上的 macOS 14 或更高版本。
- Claude Code 2.1.301 或更高版本。
- [Codex CLI](https://github.com/openai/codex)（`codex`，已在 0.172.0 上测试），通过
  Homebrew（`brew install --cask codex`）或 npm（`npm install -g @openai/codex`）安装，位于你的 shell 在终端窗口中设置的
  `PATH` 上，并已用 `codex login` 登录到其 Codex 包含语音的 ChatGPT 套餐（Plus、Pro、Business、Enterprise 或 Education，见 [OpenAI 的 Codex 定价](https://learn.chatgpt.com/docs/pricing)）。如果 LiveBridge 无法读取某个 codex 的
  `codex features list`，它会拒绝使用该 codex，因此其他版本可能要等 LiveBridge 更新后才能启动。
- 构建应用：Xcode，Swift 6.0 或更高版本的工具链。已测试的版本见
  [CONTRIBUTING.md](../../CONTRIBUTING.md#toolchain)。构建出的应用可在 macOS 14 或更高版本上运行。

## 安装

模组来自本仓库的 marketplace（即[快速开始](#快速开始)中的命令），它指向最新发布版本的标签，因此你安装的就是该版本的模组。
应用无论采用哪种方式，都安装在 `/Applications`：
通过磁盘映像，或从源码构建。从 0.4.2 之后的第一个发布版本起，磁盘映像使用 LiveBridge 的 Developer ID 签名，并经 Apple 公证；0.4.2 及更早的版本使用 ad hoc 签名，未经公证；从源码构建的应用既未使用 Developer ID 签名，也未经公证。

### 通过磁盘映像安装

1. 从最新发布版本下载
   [LiveBridge.dmg](https://github.com/getLiveBridge/LiveBridge/releases/latest/download/LiveBridge.dmg)。
2. 在保存该文件的文件夹中，用 [GitHub CLI](https://cli.github.com) 验证：

   ```sh
   gh attestation verify LiveBridge.dmg --repo getLiveBridge/LiveBridge \
     --signer-workflow getLiveBridge/LiveBridge/.github/workflows/release.yml \
     --source-ref refs/tags/vX.Y.Z --deny-self-hosted-runners
   ```

   其中 `vX.Y.Z` 是该发布版本的标签，以其发布页面上的名称为准。只有由本仓库的[发布工作流](../../.github/workflows/release.yml)
   在 GitHub 托管的 runner 上根据该标签构建、且此后未被改动的映像才能通过验证。
   对于 0.4.2 之后的发布版本，Developer ID 签名由 macOS 自行检查，说明是谁签署了映像，而这项验证说明映像是由什么构建的；对于 0.4.2 及更早的版本，其 ad hoc 签名不指明任何人，这项验证是映像唯一的来源证明。它并不能证明有人审查过代码。
3. 打开映像，把 LiveBridge 拖到“应用程序”。
4. 首次启动时，0.4.2 之后的发布版本会让 macOS 询问是否打开从互联网下载的应用；点击 **Open**。0.4.2 及更早的版本会被拦截，直到你在“系统设置”>“隐私与安全性”> **Open Anyway** 中允许它们。

### 通过 Homebrew 安装

```sh
brew install --cask getlivebridge/tap/livebridge
```

这条命令从 [LiveBridge 自己的 tap](https://github.com/getLiveBridge/homebrew-tap) 安装同一个磁盘映像，它不是 Homebrew 的官方 cask。Homebrew 可能会先要求你信任这个 tap，macOS 也会像上面所说的那样在首次启动时询问。之后应用会自行更新（[更新应用](guide.zh-CN.md#更新应用)）。

### 从源码构建

`scripts/build-app.sh --release` 会构建应用，把它安装到 `/Applications`（你的账户必须有写入权限，管理员账户即可）并打开它。
再次运行即可重新构建。该构建使用 ad hoc 签名，因此每次重新构建后 macOS 都会再次请求麦克风权限。若想保留该权限，
请运行一次 `scripts/build-app.sh --make-signing-identity`：它会先征求确认，然后在你的登录钥匙串中创建一个自签名代码签名证书，
之后的发布构建都会用它签名。

marketplace 把模组固定在上一个发布版本的标签上，因此从默认分支构建的应用会搭配该版本的模组运行。若要两者一致，请构建该发布版本的标签（`git checkout vX.Y.Z`），
或用 `claude --plugin-dir plugin` 加载工作树中的模组。

从源码构建的应用只有在你于 Settings 中开启后才会自行检查更新。安装更新会用发布版本的映像替换它，该映像使用 LiveBridge 的 Developer ID 签名，而不是你的自签名证书，
因此 macOS 会再次请求一次麦克风权限；**Install** 会说明这一点并先征求确认。

### 权限

首次点击 Start 时，macOS 会请求麦克风权限。如果被拒绝，通话会停止并给出一句提示，此时菜单栏菜单中的
**Open Microphone Settings** 会打开“隐私与安全性”>“麦克风”，你可以在那里允许 LiveBridge。从 ad hoc 签名的发布版本进行第一次更新后，以及每次使用 ad hoc 签名从源码重新构建后，
第一次点击 Start，macOS 都会再次询问（见上文）。macOS 还可能询问是否允许 LiveBridge 查找本地网络上的设备。语音线路同样需要这第二项权限；
没有它，通话会停止并给出一句提示，说明在哪里允许。

### 更新与卸载

LiveBridge 只在你点击 **Install** 时更新自身和模组，从不自行更新；它先检查什么、如何手动更新，见[更新应用](guide.zh-CN.md#更新应用)。[卸载](guide.zh-CN.md#卸载)介绍菜单中的 **Uninstall LiveBridge…**、Homebrew、仓库克隆以及手动步骤。

## 已知限制

完整列表及每个实测项背后的记录见 [known-limitations.zh-CN.md](known-limitations.zh-CN.md)。简而言之：

- **语音是一个语言模型，并不总是按指示行事。** 它有时说自己正在查看，却没有交出请求，于是什么也没到 Claude 那里：如果随后没有听到请求入队的短提示音，请再说一遍。Claude 的答复重新打开线路时，它可能保持沉默；这时答复会发出提示音并等待。它可能不提 Claude 正在等待的问题或权限提示，所以你不在 Mac 旁时不要依赖它来告知。权限提示仍在 Claude Code 中等待，LiveBridge 从不代你回答。
- **达到 ChatGPT 套餐的用量限额时**，语音会停止，直到限额重置。Claude Code 继续工作，它的答复会等待。
- **在由组织管理 Claude Code 的环境中**，LiveBridge 不会告诉你有权限提示在等待，某些托管设置还会让模组无法加载。
- **`/live`**：如果会话在模组加载之前就已打开，可能需要重新打开该会话。
- **Connect over TCP** 优先使用 TCP，但不强制，而且没有任何地方显示线路实际走的是哪种传输方式。
- 语音是否已说出等待中的结果，是根据它的措辞判断的，目前只支持英语和俄语。完整列表还涉及非键入的提示、没有摘要模型的提供方，以及仍在旧版模组上的会话。

## 使用

在你想与之对话的 Claude Code 会话中，`/live` 将它加入 LiveBridge，`/live off` 让它退出。提示输入框上方状态条或菜单栏菜单中的 **Start** 开始通话；**Mute** 在通话继续时释放麦克风，**Stop** 结束通话，**Talk here** 把通话转到你按下它的那个会话。菜单栏菜单列出已加入的会话、目标会话与语音的对话、你的分钟数和用量，以及 **Settings…**：语音、你为它写的提示、静默多久后关闭线路，以及会话内容如何传给语音。

[guide.zh-CN.md](guide.zh-CN.md) 介绍每条命令、状态条、菜单和每项设置，以及语音如何处理你的请求和 Claude 的答复与问题。

## 按需计费的设计

实时语音线路在打开期间持续计费，所以 LiveBridge 只在有人说话时、在 Claude 对你请求的答复可能还会到来时（每次交接后最多 2 分钟），或为了告诉你 Claude 的答复、它向你提出的问题、或它在等待你的批准时，才打开线路。线路关闭时，麦克风只供你 Mac 上的语音检测器使用，不会发送任何音频。菜单显示线路打开的分钟数，以及你的 Codex 和 Claude 用量已用多少；以你套餐自己的用量页面为准。每条规则见 [guide.zh-CN.md](guide.zh-CN.md#按需计费的设计)。

## 隐私

简而言之：没有遥测、没有自己的服务器、不监听网络端口；你的语音、你在已加入的会话中输入的内容，以及 Claude 的答复和摘要，只在线路打开期间经你的 codex 发往 OpenAI。[privacy.zh-CN.md](privacy.zh-CN.md) 列出发往 OpenAI 的每一项及其限制、凭据过滤器覆盖哪些内容、每一个发往 GitHub 的请求，以及应用在你 Mac 上保存的内容。

[SECURITY.md](../../SECURITY.md) 给出了威胁模型：简而言之，凡是你的麦克风能听到的内容，都可能变成一条请求，由 Claude 在该会话自己的权限模式下执行。

## 工作原理

[docs/architecture/overview.md](../../docs/architecture/overview.md) 描述了各组件、模组与应用之间的通信协议以及消息流；
[ADR 0001](../../docs/adr/0001-platform-findings.md) 记录了该设计所依据的平台事实。

## 路线图与欢迎协助

目前的 LiveBridge 是一个 Mac 应用、一个执行者（Claude Code）和一个语音提供方（使用 ChatGPT 登录的 codex）。三者在狭窄的接缝处相接，
下面的每个方向都欢迎贡献者参与。相关议题带有
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
标签；[CONTRIBUTING.md](../../CONTRIBUTING.md#where-to-start) 指出了应先阅读的文件。

- **Windows 和 Linux。** 菜单栏应用、它的音频页面和套接字服务器都与 macOS 绑定；模组与应用之间的协议以及模组本身是可移植的。
  移植从为新平台编写一个使用同一协议的应用开始。
- **其他智能体作为执行者**，例如 Codex CLI、Hermes Agent 或 Gemini CLI：每一个都需要自己的适配器，使用与 Claude Code 模组相同的协议。
- **其他语音提供方**，例如使用你自己 API 密钥的 OpenAI Realtime API，或 Google 的 Gemini Live API：每一个都将是应用实时协议的另一种实现。

## 参与贡献

欢迎贡献。对于比一次修复更大的改动，请先开一个议题，以便在开工前商定方案。适合入手的地方有
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
议题、[已知限制](#已知限制)以及[上文](#路线图与欢迎协助)的各个方向。

- [CONTRIBUTING.md](../../CONTRIBUTING.md)：目录布局、工具链、检查（`scripts/check.sh`）和约定。
- [议题表单](https://github.com/getLiveBridge/LiveBridge/issues/new/choose)：报告缺陷或提出功能请求。
- [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)：我们在这里如何相互对待。
- [SECURITY.md](../../SECURITY.md)：请私下报告漏洞，不要发在公开议题中。
- [CHANGELOG.md](../../CHANGELOG.md)：每个发布版本的变更。

## 致谢

模组与应用之间的通信协议受到
[claude-code-voice-mod](https://github.com/ldk00315-jpg/claude-code-voice-mod) 的启发。没有复制它的任何代码或文字。

## 许可证

[MIT](../../LICENSE)。
