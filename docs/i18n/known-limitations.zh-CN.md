# 已知限制

*英文原文为准（[known-limitations.md](../known-limitations.md)）；本译文可能滞后。*

LiveBridge 不做或只做到一部分的事情，以及每个实测项背后的记录。概述见 [README](README.zh-CN.md#已知限制)，这里提到的设置见 [guide.zh-CN.md](guide.zh-CN.md)。

- **Connect over TCP** 只是优先 TCP，并不强制，通话期间也不显示线路实际用了哪种传输方式，所以退回 UDP 的线路仍可能断续。这条路线只测量过一次，是在一个移除了 UDP 候选项的调试版本中（10 分钟内没有丢失音频）；正式采用的方式，即降低其优先级，只观察到一次选择了 TCP。调试模式会记录传输方式（`onTcp`）（[CONTRIBUTING.md](../../CONTRIBUTING.md#reading-debug-modes-numbers)）。
- 语音有时会说它在查看（“On it”“Looking now”），却没有转交请求，于是什么也没有送到 Claude：按最初写下的规则，约五分之一的请求如此；按现在的规则为 20 次中 0 次，次数太少，无法与运气区分（[BR-001](../../docs/bugs/BR-001.md)）。它还可能声称做了它没有做的工作，例如 “I'll take a look.”，包括根据只作为上下文拥有的行（[ADR 0001 (n), (o)](../../docs/adr/0001-platform-findings.md)）。应用把请求放入 Claude 的队列时会播放一声短音，它不同于回答的声音；如果语音说它在查看却没有这声短音，请再说一遍。应用无法凭措辞区分这种承诺和回答，因为语音说的是你的语言。
- Claude 的提问或它正在等待的权限提示只是交给语音，语音可能不说；没有什么能强制它说。所以离开 Mac 时不要依赖语音来播报提示：Claude 可能在没有任何通知的情况下等待。提示仍在 Claude Code 中等待，它才是唯一的控制手段；语音不是控制手段，LiveBridge 也绝不回答提示。在检查中，打开的线路上来自输入轮次的权限通知，在键盘回答之前被说出的次数为 3 次运行中 0 次，这是计数，不是比率（[ADR 0001 (n)](../../docs/adr/0001-platform-findings.md)）。已关闭的线路只有在目标会话的对话中有你的一轮时才会为它们打开；否则应用发出提示音，通话关闭时则只做记录。
- Claude 桌面应用把输入的提示的来源报告成什么，尚未观察到（[ADR 0001 (m)](../../docs/adr/0001-platform-findings.md)）。模组只有在提示的来源是 `composer` 时才把它记录为你的。如果在那里输入的提示以其他来源到达，在那里输入的内容都不会被记录，也不会标记缺口，菜单显示 **Context up to date**，暂停的作用范围也会变小（[详情](../../SECURITY.md#what-session-text-can-do)）。
- 在线路等待期间到达的结果，会作为待说出的文本交给语音；codex 没有能让语音立即开口的调用，因此由模型决定何时说。
  测试中它在几秒内就说了。如果没有说，结果仍保持未听取：它会在你接下来说话时再次交给语音，或在线路关闭时发出提示音。
- 当 Claude 的答复重新打开线路时，语音可能保持沉默：实测的 14 次运行中有 4 次如此，样本较小（[ADR 0001 (n)](../../docs/adr/0001-platform-findings.md)）。
  此时线路会在等待第一句话的时间结束时关闭（[设置](guide.zh-CN.md#设置)），答复会像下文所述那样发出提示音并等待。语音开口时，都是在连接后约 2 秒内开始；若在这段等待之后才开始，则会被截断。
- 当你接下来说的话重新打开线路时，语音有时只回应这些话，而不说出等待中的结果。结果并没有丢失：它仍在等待，
  会在线路关闭时发出提示音并推送通知，并在线路下次打开时再次交给语音。
- 达到你的 ChatGPT 套餐的用量限额时，语音会停止，直到限额重置。菜单和状态条会说明这一点，使用 codex 的原句，并在 codex 给出时附上重置时间；通话随之结束，这样说话就不会再打开注定失败的线路。Claude Code 继续工作，答复继续等待，Start 会再试一次。应用只能靠 codex 的措辞或服务的错误代码识别限额，因为没有别的信号（[详情](../../docs/research/2026-11-05-gpt-live-limits.md)）。它无法识别的拒绝，例如没有说明原因就断开的线路（“The voice session closed (transport_closed).”），通话会保持开启，你接下来说的话会再次尝试；在限额重置之前请按 **Stop**。
- 不是在输入框中键入的提示（host 的消息、定时任务、其他代理，大概还有 Remote Control），不会作为你的话记录到语音的对话中，但 Claude 对它的答复会被记录，而且在暂停下它不会拒绝正在运行的一轮（哪些提示算作你的，见 [SECURITY.md](../../SECURITY.md#what-session-text-can-do)）。
- 若 Claude Code 的提供方（Bedrock、Vertex 或 Foundry）不提供 **Summary model** 中选择的模型，或组织不允许使用它，该模型会失败并由 Haiku 5.5 撰写摘要；若连 Haiku 5.5 也不提供，语音就得不到摘要，Settings 会说明。在此设置之前，摘要由会话自己的模型撰写，只要会话能用就能用。固定 id 能在这些提供方上解析，这一点来自 Claude Code 的文档，未经实际运行。
- 仍在使用此版本之前模组的会话，在重启之前不会同步：它会像缺少轮次的会话那样加载摘要，暂停也不会拒绝它的行（[其他差异](../../CHANGELOG.md)）。
- 在模组加载之前就已打开的 Claude Code 会话，可能需要重新打开，`/live` 才能在其中使用。
- 在 Claude 桌面应用中，如果在其 Claude Code 进程尚未启动的会话（新建的会话，或刚重新打开的会话）里输入 `/live`，
  可能会显示“/live isn't a command here.”，但命令仍会执行。桌面应用是通过一次关闭了 hooks 的检查来列出这类会话的命令的，
  因此声明了 `/live` 的模组代码不会在那里运行；会话运行起来之后，桌面应用就会从会话本身获取命令列表。模组对此没有修复办法：
  静态命令文件会被列为 `/livebridge:live` 而不是 `/live`，而且在 hooks 关闭时，它会把自己的文本发给模型，而不是运行模组。
- 一条答复是否已经说出了等待中的结果，是根据其用词来判断的，所用的常用词表只涵盖英语和俄语
  （[规则](../../docs/architecture/overview.md#a-result-while-the-line-is-closed)）。在其他语言中，
  语音只是提到了结果，也可能被算作已听取。
- 在由组织管理 Claude Code 的环境中，LiveBridge 不会告诉你有权限提示正在等待。Claude Code 的内置防护会在有托管设置的机器上，
  以及用 Team 或 Enterprise 套餐登录的会话中加载，此时模组的权限 hooks 不会运行。提示仍会出现在 Claude Code 中并等待你回应，
  但语音不会提到它，菜单也只显示 Claude 正在工作，所以如果答复迟迟不来，请查看 Claude Code。`/plugin` 会列出这些 hooks，
  较新版本的 Claude Code 还会打印一行文字说明某个 hook 被跳过。Claude 提出的问题仍会传到语音。这些 hooks 是在 Linux 容器中[实测](../../docs/adr/0001-platform-findings.md)的；
  语音和菜单栏的表现是从代码推断的，没有运行真实线路。Team 和 Enterprise 的情况来自 Claude Code 的文档。
- 如果托管设置中有 `allowManagedHooksOnly`、`allowManagedModsOnly` 或 `disableAllHooks`，模组不会加载，`/live` 也无法使用。
  管理员可以从每台机器上的一个文件夹[把模组安装为组织自己的模组](https://code.claude.com/docs/en/plugins/mods/admin#install-your-organizations-mods)，这样权限 hooks 就会运行，在前两项设置下也一样（[实测](../../docs/adr/0001-platform-findings.md)）。
  根据 Claude Code 的文档，在托管设置中启用 marketplace 副本是不够的。
