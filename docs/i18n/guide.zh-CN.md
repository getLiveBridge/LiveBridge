# 使用 LiveBridge

*英文原文为准（[guide.md](../guide.md)）；本译文可能滞后。*

每条命令、状态条、菜单和每项设置；语音做什么；线路如何计费；以及如何更新和卸载。[README](README.zh-CN.md) 包含概述、系统要求和安装步骤，[privacy.zh-CN.md](privacy.zh-CN.md) 说明哪些内容会离开你的 Mac，[known-limitations.zh-CN.md](known-limitations.zh-CN.md) 说明哪些功能尚不可用。

## 使用

### 命令

在你想与之对话的 Claude Code 会话中：

| 命令 | 作用 |
|---|---|
| `/live` | 以会话标题加入 LiveBridge；如果应用未运行，则将其打开。在已加入的会话中，它会让状态条重新出现，并用一行作答：通话、目标、未听取的结果、今日分钟数。 |
| `/live off` | 离开 LiveBridge。 |

命令是 `/live` 而不是 `/voice`，因为 `/voice` 是 Claude Code 自带的语音模式。通话停止期间，你在会话中输入的内容是否不进入语音，并不是一个命令：
它是对所有会话生效的一项设置，位于 LiveBridge 的[设置](#设置)窗口中。

### 状态条与菜单

在提示输入框上方的状态条或菜单栏菜单中点击 **Start**，然后开始说话。

- **状态条上的 Start** 会让它所属的会话成为目标并开始通话；它打开的线路会带上该会话的对话，并且在语音会缺少该会话的一部分时（见下文 **Load context**）另外加载摘要，但在 **Pause sync** 开启期间或暂停之后，只有在尚无摘要时才加载（[详情](../../docs/architecture/overview.md#when-the-app-asks)）。使用本版本的模组时，摘要会在按下 Start 和通话中切换目标时请求，线路在连接前等待它，最长不超过[等待的上限](../../docs/architecture/overview.md#its-time)：这期间你说的话保留在 Mac 上，线路打开后再交给语音。等待期间按 Stop 或切换目标会丢弃保留的内容；更改 **Connect over TCP** 后的重新连接也会丢弃，最多只为重新打开的线路保留最后 2 秒。当通话正在对接另一个会话时，状态条显示 **Talk here**。若已加入的会话中没有
  状态条，`/live` 会让它重新出现。
- **菜单栏菜单**包含通话、已加入的会话（点击某个会话使其成为目标）、
  **Load context**、LiveBridge 保存的目标会话 **Conversation**（语音交给 Claude 的每个请求都有一行 **Task**，载入摘要的位置有一行 **Loaded context**）、用量限额、分钟数、
  **Quick Settings**（**Connect over TCP**、**Play sounds for requests and answers**、**Notify when a result is waiting**、**Pause sync while the call is stopped** 和 **Load a session's context on its first call** 的勾选项）、**Settings…**、**Feedback & Support**（**Report a Bug…** 打开仓库的错误报告表单，**LiveBridge Website** 打开 getlivebridge.com，**Star LiveBridge on GitHub** 打开仓库页面，随后是 **Debug Mode** 和 **Show Debug Files**，即[调试模式](#设置)的开关和文件夹，以及 **Uninstall LiveBridge…**（[卸载](#卸载)））和 **Quit LiveBridge**。菜单只显示通话时，Quick Settings 也在。通话期间，**Conversation** 会随着 codex 的转写显示你和语音说的话，因此你的话可能在说出后片刻才出现，语音的话可能在你听到前片刻就出现。每句话结束后，由最终文本替换这些文字。只保留最终文本：线路关闭时仍未等到最终文本的文字会消失。
- **Mute**（在 **Stop** 旁边，位于状态条和菜单的通话卡片中；Mute 后显示 **Unmute**）会在通话继续时释放你的麦克风：Claude 的答复仍会打开线路，并交给语音去说。Mute 期间语音不会把任何请求交给会话：你不可能提出过它，所以此时的交接是语音根据收到的文字行自行做出的，应用会告诉它没有交出任何内容。请在 **Unmute** 后再说一遍。状态条保留阶段并加上 `· muted`；没有线路打开时，菜单显示 “Muted — line closed”。Mute 不会关闭线路：已打开的线路会在通常的无声时长后关闭：若你当时在说话，则从 Mute 起算；若线路本来就安静，Mute 不会改变它何时关闭，计费与任何无声时段相同，因此 Mute 不会节省实时分钟数。**Unmute** 会重新使用麦克风，若无法使用（被拒绝、被占用、缺失），通话会带着原因结束。**Stop** 会结束通话和 Mute；下一次 **Start** 从未 Mute 开始。Mute 不是锁：任何以你的用户身份运行的进程都可以解除它（[SECURITY.md](../../SECURITY.md#who-can-drive-the-bridge)）。
- **Load context** 只在语音缺少目标的一部分时可用：没有摘要且 **Pause sync** 使下一条线路无法加载或上次请求的摘要失败（直到该会话的下一轮或下一次 Start）、某一轮没有送达、某个问题或权限通知没有送到应用、模组关闭期间有轮次运行、摘要之后的行数已超出语音所能承载（较长的对话会超出）、该会话曾被暂停且已有摘要，或其模组不同步。否则该项显示为 **Context up to date** 且不可用，因为语音已经有了这段对话。如果没有打开的线路、下一条线路将加载摘要且没有缺少其他内容，该项显示为 **Context loads with the line** 且不可用，因为下一条线路会自行请求摘要。目标的摘要正在途中时，无论是谁请求的，该项都显示为 **Loading context…** 且不可用，最长为模组给它的时间（[多久](../../docs/architecture/overview.md#its-time)；旧版模组的会话仍显示 **Load context**）；摘要到达后短暂显示 **Context loaded**，空的回复则回到 **Load context**。摘要不带日期，因此它可能被忽略而该项仍保持可用（[BR-002](../../docs/bugs/BR-002.md)）。
- **New conversation…** 会清除目标会话的对话及其已加载的上下文；会话上的 × 会移除该会话并清除它自己的对话；两者都会先询问确认。语音从线路下次打开时重新开始。它还没说出的结果会保留并再次加入，只有 **Stop** 会清除它们。Claude 等待中的问题遵循其他规则（[详情](../../SECURITY.md#residual-risk-by-design)）。**Load a session's context on its first call** 开启时，或 **Pause sync** 关闭且该会话未被暂停时，下一条线路会自行加载同一会话记录的摘要，其中包括对话的文字（本版本的应用和模组会去掉工具输出、思考和提醒，但不会去掉引用它们的文字；更早的版本会发送整个请求）；要避免这一点，请先在该会话中执行 `/clear`，再点击 **New conversation**。在被移除的会话中执行 `/live` 可让它重新加入。

### 设置

**Settings…** 会打开 LiveBridge 的设置窗口，工具栏中有四个标签页。
菜单中的 **Quick Settings** 收有其中五个开关（[菜单](#状态条与菜单)）：每一项就是设置本身，因此在一处更改会立即显示在另一处，并且它会询问此处开关所询问的内容。
**General** 包含通知、登录、更新和调试模式：

- **Notify when a result is waiting**（默认开启）：当线路关闭期间有结果在等待时，除提示音外，还会弹出一条 macOS 通知，其中写明会话名称
  （“Alpha has a new result — speak to hear it”），但绝不包含结果本身。点击通知会打开菜单栏菜单。
- **Open at login**（默认关闭）。
- **Updates**：当前运行的版本、**Check for update**、**Check for updates automatically**，以及上一次更新做了什么（[更新应用](#更新应用)）。
- **Debug mode**（默认关闭）：通话期间每秒记录一行语音的网络数据（丢失和丢弃的数据包、抖动、隐藏的采样、线路是否走 TCP），每次通话一个 CSV，存放在 `~/Library/Application Support/LiveBridge/debug/call-stats/`；不含音频、转写或会话名称。通话中开启时，从那一刻起记录正在打开的线路；关闭时立即停止，已写入的文件会保留，直到你删除。**Show Debug Files** 打开该文件夹。在菜单中，它是 **Feedback & Support** 里的 **Debug Mode**（[如何解读这些数据](../../CONTRIBUTING.md#reading-debug-modes-numbers)）。

**Voice** 包含通话中你听到的内容：

- **Voice**：你的 codex 提供的实时语音之一（此标签页打开时由 codex 列出），或 **Codex default**。从线路下次打开起生效。
- **Prompt**（默认为空）：你给语音的自定义指令，例如“用西班牙语和我说话”，最多 2,000 个字符。它们会追加在 LiveBridge
  为语音设定的规则之后；两者冲突时以 LiveBridge 的规则为准。从线路下次打开起生效。
- **Play sounds for requests and answers**（默认开启）：语音每转交一个请求给 Claude，就播放一声短音（[原因](known-limitations.zh-CN.md)）；无人说话时，Claude 的每个回答、失败或提问到达已打开或正在打开的线路，也会播放一声。等待中结果的提示音始终播放。

**Line** 包含线路在安静中保持打开多久，以及它如何连接：

- **Silence before the line closes**（默认 20 秒）、**Wait for a first word on a line a result opened**（5 秒）和 **Sound without words before the line closes**（90 秒）：每种安静能让打开的线路保持多久，范围为 0 到 300 秒。静音或没有语言的声音设为 0 即关闭该项，而等待第一句话设为 0 时，等待时长与静音相同。三项都为 0 时，安静永远不会关闭线路：线路会一直打开，期间一直计费（[计费](#按需计费的设计)），直到你按下 Stop、更换目标或 OpenAI 将其关闭。时长过短会让线路在普通的停顿中关闭，而每次重新打开都要过几秒语音才会回答，所以设为 1 到 9 秒时 Settings 会给出警告；没有语言的声音也是如此，因为你的说话在被识别之前也算作这种声音；第一句话的等待设为 1 到 3 秒时同样会警告，因为语音常在线路连接后约 2 秒才开口。你开启的计时器会在安静的已打开线路上立即开始计时；已在计时的则保留已计的时间。
- **Connect over TCP**（默认关闭）：如果在网络较差时语音断断续续，请打开它。线路随后优先使用媒体服务器提供的 TCP 路线（已见到的应答中为 443 端口）而不是 UDP，并且仍可能退回 UDP。在丢包的连接上，这可以把断续变成句子之间的短暂停顿（[测试到什么程度](known-limitations.zh-CN.md)）。切换时如果线路正开着，确认后它会立即关闭并重新打开；语音正在说的话会被打断，而线路正在等待的结果仍会进入新的线路。

**Context** 包含你的会话如何到达语音：

- **Pause sync while the call is stopped**（默认关闭）：默认情况下，你在已加入的会话中输入的内容以及 Claude 对此的最终答复，即使通话已停止，也会保存到该会话与语音的对话中，下一条线路打开时语音就拥有它们。在线路打开之前，这些内容都不会到达 OpenAI。若不想让某些文字到达 OpenAI，请开启此项，若该会话可能还没有摘要，请关闭下一项设置，按下 Stop，然后再输入：通话停止期间你输入的内容都不会被记录，该会话会被标记为已暂停。开启期间，没有任何线路会自行加载摘要，暂停之后也是如此，但没有摘要的会话除外（见下一项设置）；其他情况下只有 **Load context** 才会加载。该摘要由会话记录写成，因此会带上你暂停的内容。向正在运行语音请求的那一轮输入，会使它的答复失败，其中的任何内容都不会被记录或说出。此项不会删除已记录的任何内容，Claude 之后的答复也可能重复被暂停的文字；它做什么、不做什么，见 [SECURITY.md](../../SECURITY.md#residual-risk-by-design)。
- **Load a session's context on its first call**（默认开启；如果更新时 **Pause sync** 已开启，则为关闭）：对于语音没有摘要的会话，按下 Start、通话中切换目标或打开线路都会请求摘要，即使 **Pause sync** 已开启或该会话已被暂停，旧对话和 **New conversation** 之后的对话也一样。该摘要由会话记录写成，因此会带上你暂停的内容，并发送给 OpenAI。会话有了摘要之后，后续内容由暂停决定。关闭此项时，暂停期间只有 **Load context** 才会加载摘要。
- **Summary model**（默认 Haiku 5.5，更新后也是；也可选 Sonnet 5.5、Opus 5.5 或 **Custom…**）：撰写语音作为上下文所得摘要的模型，始终使用低推理强度，消耗你的 Claude 用量。若其他模型失败，则由 Haiku 5.5 撰写，除非该模型已超时。设置下方有一行说明上一份摘要何时改由 Haiku 5.5 撰写，或没有任何模型写成，以及原因。使用此设置之前的模组的会话会忽略它，用会话自己的模型撰写。**Custom…** 接受一个模型 id 和 **Check and save**：一个已加入的会话向该模型发送一个简短请求（"Reply with OK."），消耗你的 Claude 用量，只有模型作答时才保存该 id；否则原因显示在输入框旁，之前的选择保持不变。这需要一个运行此版本模组的会话，检查结果只代表该会话的 Claude Code：其他会话可能不同，已保存的 id 不会再次检查。

### 语音做什么

- 闲聊和解释由它自己回答；凡是需要用到仓库或会话的事情，它都会交办出去：任务、关于代码的问题、决策、更正和中止。
- 在交办任何具有破坏性或对外影响的操作（删除、推送、发布、发送、部署、付款）之前，它会复述请求并询问“确认吗？”。
  这是语音被要求遵守的习惯，而不是一道安全保障；哪些才算保障，见 [SECURITY.md](../../SECURITY.md)。
- 它用一两句话念出结果，并带上会话名称。代码块和表格留在会话中，它能识别的凭据会被遮蔽。
- Claude 完成后它会回来。你不必让线路一直打开：谈话安静下来后线路就会关闭，而 Claude 对你请求的答复会重新打开线路并交给语音去说，所以 Claude 工作时你可以走开。这适用于你正在对话的会话；其他会话的结果会发出提示音并等待（[如何计费](#按需计费的设计)）。如果语音在重新打开的线路上保持沉默，答复同样会发出提示音并等待，因此不会丢失。Claude 向你提出的问题或它正在等待的权限提示也会这样打开线路，但语音可能不说：离开 Mac 时不要依赖这一点（[已知限制](known-limitations.zh-CN.md)）。
- 当 Claude 提出问题时，问题会交给语音向你转述，你的回答则发回该会话。对于 Claude 在工作中提出的问题（带选项的对话框）也是如此：语音收到它，用于告诉你这个问题、用自己的话解释各个选项，并按你的需要与你讨论多久都可以，而不去询问 Claude。你的决定，无论是某个选项还是反问 Claude 的问题，都会作为对话框的回答；你也仍然可以在键盘上回答。Claude 之后在后台完成的工作会作为更新交给语音。
- 当 Claude 正在等待权限提示时，语音会收到一条通知，并可能说出来，但[由组织管理 Claude Code 的环境](known-limitations.zh-CN.md)除外。你需要在 Claude Code 中回应该提示；LiveBridge 绝不会替你回答。
- 它会收到你输入的内容。会话处于加入状态时，你在其中输入的内容，以及 Claude 对每个非语音请求轮次的最终答复，都会作为上下文进入该会话与语音的对话：它们不会发出提示音，也不会打开已关闭的线路（[相关限制](known-limitations.zh-CN.md)）。已打开的线路会立即收到它们；之后打开的线路则以它们为开头。被更新的请求取代的语音答复不会被说出，但会以同样方式保留并加入。Claude 在一轮中途的文字不会同步，只有它在提问或权限提示之前刚写下的内容会随之而去；子代理和工具输出不会同步。目标会话中 Claude 的提问或权限提示，无论由哪一轮引起，都会交给语音；在其他会话中，它像那里的结果一样处理，但若那一轮不是语音请求，则只做记录。被暂停挡在外面的一轮没有这些。当提问或权限提示不经语音就已了结，或某一轮没有答复就结束时，语音会收到一行说明（[哪些行](../../SECURITY.md#what-session-text-can-do)）。

## 按需计费的设计

实时语音会话在打开期间产生费用，因此 LiveBridge 只在有人说话时、在你刚提出的请求的 Claude 答复可能即将到来时，或为了说出这条答复、Claude 的提问或 Claude 正在等待你的许可时，才打开它：

- 通话进行中且无人说话时，麦克风只为你 Mac 上的语音检测器供音，不会向任何地方发送音频。
  处于 Mute 时，LiveBridge 不持有麦克风，macOS 的麦克风指示器会显示这一点。
- 当你开始说话时，线路打开。你开口前的 2 秒音频会被保留并最先发送，因此你的头几个字不会丢失。
- 静音一段时间后线路关闭，没有语言的声音（音乐、电视）则在它自己的一段时间后将其关闭。两者各自在[设置](#设置)中设定；某项设为 0 时，它就不会关闭线路。
- 当语音把请求交给 Claude（即一次交办）后，线路最多保持打开 2 分钟，与任何打开的线路一样计费；一旦无人说话，Claude 的答复就会交给语音去说。
  之后的交办会重新开始这 2 分钟；而没有向 Claude 发送任何内容的交流，则在通常的静音后关闭。
- 你交给正在对话的会话的请求的 Claude 答复、Claude 在该会话中向你提出的问题，或它正在等待的权限请求，如果在线路关闭后到达，会重新打开线路并交给语音去说，与任何打开的线路一样计费。
  线路关闭期间到达的其他内容（来自你已切换离开的会话的任何内容、之后的更新）会播放提示音并等待：状态条和菜单会将其显示为未听取，并在你下次说话时交给语音
  （[何时算作已听取](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)）。
- 每个 Claude Code 会话都与语音有各自的对话。它会延续到下一个实时会话中，并在 Stop 和 Start 之间保留，因此语音记得你一分钟前说过的话。
  切换目标会同时切换对话：已打开的线路会关闭，你接下来说的话会带着新目标的对话重新打开它。
- 菜单显示线路打开的分钟数，由应用从语音连接时开始计算，因此你的套餐计入的可能略多一些。OpenAI 按你的 Codex 用量预算的分钟数为桌面语音计价，其 API 上同一模型系列也对静默计费（[详情](../../docs/research/2026-11-04-gpt-live-billing.md)，[限额](../../docs/research/2026-11-05-gpt-live-limits.md)）；以你的套餐自身的用量页面为准。
- 菜单显示你的 Codex 和 Claude 用量已用多少：各一行，按套餐所报告的每个窗口给出已用百分比（每行最多三个，例如 `7% of 5 h · 19% of week`），达到 90% 时显示为橙色；悬停在某一行上可看到各窗口何时重置。Codex 的数字在每次打开菜单时读取，最多每分钟一次，由一个短时运行的 codex 读取；Claude 的数字来自已加入且已回答过的会话。没有可显示内容的行不会出现；当 codex 报告不允许普通用量时，Codex 的那一行会显示 `blocked`。Codex 的上一次读数会立即显示，几秒后由新读数替换，所以菜单打开时数字可能变化；应用刚启动时，那一行在首次读数到达时才出现；如果读取失败，读数会在 15 分钟后消失。哪一项限额最先让语音停下，并未公布（[详情](../../docs/research/2026-11-05-gpt-live-limits.md)）。

## 更新应用

LiveBridge 只在你点击 **Install** 时更新应用及其模组，从不自行安装。只有位于 `/Applications/LiveBridge.app` 的副本会更新；
其他任何副本都会在 Settings 中说明这一点。

- **Check for updates automatically**，位于 Settings（默认开启，从源码构建时默认关闭）：应用每天向 GitHub 询问一次最新的发布版本。
  较新的版本只通知一次：一条通知，其中的 **Install** 会安装它；菜单栏菜单也会显示 **Install LiveBridge X.Y.Z…**，直到它被安装，
  为保留这一项，应用每次启动时都会再次询问 GitHub。Settings 中的 **Check for update** 会立即询问。
- **Install** 需要已登录的 [GitHub CLI](https://cli.github.com)（`gh auth login`）；否则 Install 不会下载任何内容，并给出发布页面的链接。
  它会下载该发布版本的映像，用[通过磁盘映像安装](README.zh-CN.md#通过磁盘映像安装)中同样的 `gh attestation verify` 验证它，再检查其中的应用；只要有一项检查未通过，就什么都不安装。
  如果 Claude 仍在处理语音请求，它会等待；然后用 `claude plugin marketplace update livebridge` 和
  `claude plugin update livebridge@livebridge` 更新模组，停止通话，一步将新应用放到原位并打开它。
- 之后，Settings 会显示是从哪个版本更新而来。如果模组未能更新，那里会列出这两条命令，供你自己运行。
  已经打开的 Claude Code 会话在重启之前仍使用旧模组；Settings 会列出仍在使用旧模组的已加入会话。
- 更新的下载不会设置隔离（quarantine）属性，因此 macOS 不应像首次下载之后那样，在更新后应用的首次启动时停下来询问；这是从代码推出的结论，尚未实际观察到。
  由上述检查承担这一把关作用（[SECURITY.md](../../SECURITY.md#what-an-update-installs)）。0.4.2 之后的发布版本使用 LiveBridge 的 Developer ID 签名，因此麦克风权限应当会在版本之间保留；这是根据 macOS 对该权限的关联方式推断的，尚未观察到。0.4.2 及更早的版本使用 ad hoc 签名，因此从其中任一版本进行的第一次更新，会在第一次点击 **Start** 时再次请求一次麦克风权限。

若要手动更新，请先在每个会话中运行 `/live off`（应用一旦停止响应，模组就会重新打开 `/Applications` 中的应用），退出 LiveBridge，
按[安装](README.zh-CN.md#安装)中的方法安装较新的映像，然后运行这两条 `claude plugin` 命令。

## 卸载

在 `/Applications` 中的副本里，菜单中的 **Feedback & Support ▸ Uninstall LiveBridge…** 会先询问，然后把应用移到废纸篓；如果无法移动，它会说明，把应用留在原处，并放回先前移除的登录项（如果移除过）；如果 macOS 不允许它把该登录项放回去，它也会说明，并告诉你如何重新打开 **Open at login**。然后结束正在进行的通话，每个会话都会离开 LiveBridge（与菜单中的 × 相同），因此其中的 `/live` 会关闭，而不会再次打开 LiveBridge；LiveBridge 移除登录项和麦克风权限后退出，退出之后，它保存的文件（见下文）会移到废纸篓中的一个文件夹，直到你清倒废纸篓。它不会移除 Claude Code 模组，而是复制移除模组的命令 `claude plugin uninstall livebridge@livebridge`，供你在终端中运行。当时未打开的会话在再次打开时可能仍会寻找 LiveBridge；移除模组即可停止。

用 Homebrew 安装的？`brew uninstall --cask getlivebridge/tap/livebridge` 会移除应用及 Homebrew 中的记录；下面的步骤仍适用于应用保存的文件。

在克隆的仓库中运行 `scripts/build-app.sh --uninstall`，无论应用是如何安装的，它都会移除
`/Applications/LiveBridge.app`、其登录项以及它保存的所有文件，并打印出留给你自己执行的两条命令：
`tccutil reset Microphone com.getlivebridge.livebridge` 和
`claude plugin uninstall livebridge@livebridge`。

如果没有克隆仓库，请在 LiveBridge 的 Settings 中关闭 **Open at login**，退出 LiveBridge，然后在终端中执行同样的步骤：

```sh
rm -rf /Applications/LiveBridge.app ~/Library/Application\ Support/LiveBridge \
  ~/Library/{Caches,WebKit}/com.getlivebridge.livebridge \
  ~/Library/HTTPStorages/com.getlivebridge.livebridge{,.binarycookies} \
  ~/Library/Preferences/com.getlivebridge.livebridge.plist
tccutil reset Microphone com.getlivebridge.livebridge
claude plugin uninstall livebridge@livebridge
```

这些方式都不会删除名为 `/Applications/.LiveBridge-update-….app` 的副本，这种副本可能由安装中途中断的更新留下。应用会在下次启动时删除这类副本；
卸载之后，如果它存在，请手动删除。

`claude plugin uninstall` 可能会留下模组的快照 `~/.claude/plugins/store/livebridge_*.json`：Claude Code 文档中列出的删除内容不包括这个文件，这一点也没有实际运行验证。如果它还在，请手动删除。
