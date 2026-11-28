# Known limitations

What LiveBridge does not do, or does only in part, with the record behind each measured item. The
[README](../README.md#known-limitations) has the summary, and [Using LiveBridge](guide.md) the
settings named here.

- **Connect over TCP** prefers TCP; it does not force it, and nothing shows during a call which
  transport a line took, so a line that fell back to UDP can still break up. The route was measured
  once, in a debug build that removed the UDP candidates (no audio lost in 10 minutes); the shipped
  way, lowering their priority, was seen once to choose TCP. Debug mode records
  the transport (`onTcp`) ([CONTRIBUTING.md](../CONTRIBUTING.md#reading-debug-modes-numbers)).
- The voice sometimes says it is looking ("On it", "Looking now") without handing the request off,
  so nothing reaches Claude: about one request in five with the rule as first written, and 0 of 20
  with the rule now, too few to tell from luck ([BR-001](bugs/BR-001.md)). It can also claim
  work it has not done, as in "I'll take a look.", also from lines it only has as context ([ADR 0001
  (n), (o)](adr/0001-platform-findings.md)). The app plays a short sound when it queues a
  request for Claude, not the one an answer has; if the voice says it is looking and that sound
  does not follow, say the request again.
  The app cannot tell such a promise from an answer by its words, since the voice speaks your
  language.
- A question Claude asks, or a permission prompt it waits on, is only given to the voice, and the
  voice may not say it; nothing makes it. So do not rely on the voice to announce a prompt when you
  are away from the Mac: Claude may be waiting unannounced. The prompt still waits in Claude Code,
  and it is the one control; the voice is not a control, and LiveBridge never answers the prompt. In
  the checks, a typed turn's permission notice on a live line was said before the keyboard answer in
  0 of 3 runs, a count and not a rate ([ADR 0001 (n)](adr/0001-platform-findings.md)). A closed
  line opens for either only when the target's conversation holds a turn of yours; otherwise the app
  chimes, and with the call off it is only recorded.
- A result that arrives while the line waits for it goes to the voice as text to say; codex has no
  call that makes the voice speak at once, so the model decides when. The end-to-end smoke test
  ([scripts/smoke.sh](../scripts/smoke.sh)) checks that the voice says such a result before your
  next words; how soon it speaks was not measured. If it does not say it, the result stays unheard:
  it goes to the voice again with your next words, or it chimes when the line closes.
- When Claude's answer opens the line again, the voice can stay silent: it did in 4 of 14 measured
  runs, a small sample ([ADR 0001 (n)](adr/0001-platform-findings.md)). The line then closes
  once its wait for a first word ends ([Settings](guide.md#settings)), and the answer chimes and waits, as
  below. Where the voice spoke, it started within about 2 seconds of the connect; one that would
  start after the wait is cut off.
- When your next words reopen the line, the voice sometimes answers only them and does not say
  the waiting result. The result is not lost: it stays waiting, chimes and posts a notification
  when the line closes, and goes to the voice again the next time the line opens.
- At your ChatGPT plan's usage limit the voice stops until the limit resets. The menu and the band
  say so, in codex's sentence with its reset time where codex gives one, and the call ends, so
  speech does not open lines that fail. Claude Code keeps working, answers keep waiting, and Start
  tries once more. The app recognises a limit only by codex's wording or the service's error code,
  as nothing else reports it ([details](research/2026-11-05-gpt-live-limits.md)). A refusal it
  does not recognise, such as a line that drops with no reason given ("The voice session closed
  (transport_closed)."), leaves the call on, so your next words try again; press **Stop** until the
  limit resets.
- A prompt not typed in the composer (a host's message, a schedule, another agent and presumably
  Remote Control) is not recorded in the voice's conversation as your words, though Claude's answer
  to it is, and it does not refuse a running turn under the pause
  ([SECURITY.md](../SECURITY.md#what-session-text-can-do) says which prompts count as yours).
- Where Claude Code's provider (Bedrock, Vertex or Foundry) does not offer the model set as
  **Summary model**, or the organisation does not allow it, that model fails and Haiku 5.5 writes
  the summary; where Haiku 5.5 is not offered either, the voice gets no summary, which Settings
  says. Before this setting the session's own model wrote it, which works wherever the session
  does. That a pinned id resolves on those providers comes from Claude Code's documentation and
  was not run.
- A session still on a mod from before this release, until it restarts, is not synced: it loads a
  summary as a session with missing turns does, and no pause refuses its lines ([what else
  differs](../CHANGELOG.md)).
- A Claude Code session that was already open before the mod loaded may need to be reopened
  before `/live` works in it.
- In the Claude desktop app, `/live` typed in a session whose Claude Code process has not
  started yet (a new session, or one just reopened) can show "/live isn't a command here." The
  command still runs. The desktop lists such a session's commands from a check it runs with hooks
  turned off, so the mod's code, which declares `/live`, does not run there; once the session is
  running, the desktop takes its list from the session itself. The mod has no fix for this: a
  static command file would be listed as `/livebridge:live`, not `/live`, and with hooks off it
  would send its text to the model instead of running the mod.
- Whether a reply has said a waiting result is judged by its words, with a list of common words
  in English and Russian only
  ([the rule](architecture/overview.md#a-result-while-the-line-is-closed)). In another
  language a result can count as heard when the voice only mentioned it.
- Where an organization manages Claude Code, nothing in LiveBridge tells you that a permission
  prompt is waiting. Claude Code's built-in guard loads on a machine with managed settings and in
  a session signed in to a Team or Enterprise plan, and there the mod's permission hooks do not
  run. The prompt still appears in Claude Code and still waits for you, but the voice says nothing
  about it and the menu shows Claude working, so look at Claude Code if an answer seems late.
  `/plugin` names the hooks, and recent versions of Claude Code also print a line saying a hook
  was skipped. Claude's questions still reach the voice. The hooks were
  [measured](adr/0001-platform-findings.md) in a Linux container; what the voice and the menu
  bar do follows from the code, and no real line was run. The Team and Enterprise case comes from
  Claude Code's documentation.
- With `allowManagedHooksOnly`, `allowManagedModsOnly` or `disableAllHooks` in managed settings,
  the mod does not load and `/live` does not work. An administrator can [install the mod as the
  organization's
  own](https://code.claude.com/docs/en/plugins/mods/admin#install-your-organizations-mods), from a
  folder on each machine: then the permission hooks run, also with the first two settings
  ([measured](adr/0001-platform-findings.md)). Claude Code's documentation says that turning
  on the marketplace copy in managed settings is not enough.
