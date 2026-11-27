# Using LiveBridge

Every command, the band, the menu and each setting; what the voice does; how the line is billed;
and how to update and uninstall. The [README](../README.md) has the summary, the requirements and
the install steps, [privacy.md](privacy.md) what leaves your Mac, and
[known-limitations.md](known-limitations.md) what does not work yet.

## Use

### Commands

In the Claude Code session you want to talk to:

| Command | What it does |
|---|---|
| `/live` | Joins LiveBridge under the session's title, and opens the app if it is not running. In a joined session it brings back the band and answers in one line: the call, the target, unheard results, minutes today. |
| `/live off` | Leaves LiveBridge. |

The command is `/live`, not `/voice`, because `/voice` is Claude Code's own voice mode. Whether a
session's typing is kept out of the voice while the call is stopped is not a command: it is one
setting for every session, in LiveBridge's [Settings](#settings) window.

### The band and the menu

Press **Start**, in the band above the prompt or in the menu bar menu, and talk.

- **The band's Start** makes its session the target and starts the call; the line it opens is seeded
  with the session's conversation, and loads a summary of the session as well when the voice would
  lack part of it (see **Load context** below), but while **Pause sync** is on or after a
  pause only when it has none yet ([details](architecture/overview.md#when-the-app-asks)). With a mod of this
  release the summary is asked for at Start and when the target changes during the call, and the
  line waits for it before it connects, for at most [the wait's limit](architecture/overview.md#its-time): what you say meanwhile is
  held on the Mac and played to the voice once the line opens. Stop or a target change during the
  wait drops what was held, and so does a reconnect after **Connect over TCP** changes, which keeps
  at most the last 2 seconds for the line that opens again. While the call talks to another
  session, the band shows **Talk here**. If the band is not there in a joined session, `/live`
  brings it back.
- **The menu bar menu** has the call, the joined sessions (click one to make it the target),
  **Load context**, the target's **Conversation** as LiveBridge keeps it (with a **Task** line
  for each request the voice handed to Claude and a **Loaded context** line where a summary was
  loaded), the usage limits, the minutes, **Quick Settings** (checkmark items for **Connect over
  TCP**, **Play sounds for requests and answers**, **Notify when a result is waiting**, **Pause
  sync while the call is stopped** and **Load a session's context on its first call**),
  **Settings…**, **Feedback & Support** (**Report a Bug…** opens the repository's bug report form,
  **LiveBridge Website** opens getlivebridge.com, **Star LiveBridge on GitHub** opens the
  repository's page, then **Debug Mode** and **Show Debug Files**, [debug mode](#settings)'s
  switch and folder, and **Uninstall LiveBridge…** ([Uninstall](#uninstall))) and **Quit LiveBridge**. Quick Settings is there even when the menu shows
  only the call. During a call **Conversation** shows your words and the voice's as codex transcribes them, so yours can appear a
  moment after you say them and the voice's a moment before you hear them. When each is finished,
  its final text replaces them. Only final text is kept: words still waiting for it when the line
  closes are gone.
- **Mute** (beside **Stop**, in the band and in the menu's call card; **Unmute** while muted)
  releases your microphone while the call goes on: an answer from Claude still opens the line and
  goes to the voice to say. While muted the voice hands nothing to a session: you cannot have
  asked for it, so a handoff then is the voice acting on the lines it was given, and the app tells it
  nothing was handed off. Say it again after **Unmute**. The band keeps the phase and adds `· muted`; the menu says "Muted — line
  closed" while no line is open. Mute does not close a line: an open line closes after the usual
  silence, counted from Mute if you were speaking, and when it would have without Mute if the line
  was already quiet; it is billed like any silence, so Mute does not save realtime minutes.
  **Unmute** takes the microphone again, and the call ends with the reason if it cannot (denied,
  busy, missing). **Stop** ends the call and the mute; the next **Start** begins unmuted. Mute is
  not a lock: any process running as you can unmute
  ([SECURITY.md](../SECURITY.md#who-can-drive-the-bridge)).
- **Load context** is enabled only when the voice lacks part of the target: it has no summary
  and **Pause sync** stops the next line loading one or the last one asked for failed
  (until the session's next turn or the next Start), a turn did not arrive, a question or permission notice did not reach the app, turns ran while the
  mod was off, the lines since the summary no longer all fit what the voice can carry (a long
  conversation outgrows that), the session was paused and has a summary, or its mod does not sync. Otherwise the item
  reads **Context up to date** and is disabled, because the voice already has the conversation. With
  no line open, when the next line will load the summary and nothing else is missing, it reads **Context loads with the line** and is disabled, because
  the next line asks for one by itself. While a summary of the target is on its way, whatever asked
  for it, the item reads **Loading context…** and is disabled, for at most the time the mod allows it ([how long](architecture/overview.md#its-time); on an older mod it stays **Load context**); one that arrives shows **Context
  loaded** for a moment, and an empty answer goes back to **Load context**. A summary carries no date, so one can be ignored while the item stays enabled
  ([BR-002](bugs/BR-002.md)).
- **New conversation…** erases the target's conversation and its loaded context, and a session's ×
  removes it and erases its own; both ask first. The voice starts afresh from the next time the line
  opens. Results it has not said yet stay and are added again; only **Stop** clears them. Claude's
  waiting questions follow other rules ([details](../SECURITY.md#residual-risk-by-design)). With
  **Load a session's context on its first call** on, or **Pause sync** off and the session not paused, the next line loads a summary of the same session's
  transcript by itself, which holds the conversation's text (an app and a mod of this release leave
  out tool output, thinking and reminders, but not text that quotes them, and an older one sends the
  whole request); `/clear` the session first to avoid
  that, then press **New conversation**. `/live` in a removed session joins it again.

### Settings

**Settings…** opens LiveBridge's Settings window, in four tabs in its toolbar.
The menu's **Quick Settings** holds five of its switches ([the menu](#the-band-and-the-menu)): each
item is the setting itself, so a change in one place shows at once in the other, and it asks what
the switch here asks.
**General** holds notifications, Open at login, updates and debug mode:

- **Notify when a result is waiting** (on by default): with the chime for a result that waits
  while the line is closed, a macOS notification names the session ("Alpha has a new result —
  speak to hear it"), never the result itself. Clicking it opens the menu bar menu.
- **Open at login** (off by default).
- **Updates**: the running version, **Check for update**, **Check for updates automatically**
  and what the last update did ([Updating](#updating)).
- **Debug mode** (off by default): during a call, a row a second of the voice's network numbers
  (packets lost and discarded, jitter, concealed samples, whether the line runs over TCP), one CSV
  per call, in `~/Library/Application Support/LiveBridge/debug/call-stats/`; no audio, no
  transcript, no session names. Turned on during a call, it records the open line from then; turned
  off, it stops at once, and the files stay until you delete them. **Show Debug Files** opens the
  folder. It is also **Debug Mode** in the menu's **Feedback & Support**
  ([reading the numbers](../CONTRIBUTING.md#reading-debug-modes-numbers)).

**Voice** holds what you hear during a call:

- **Voice**: one of the realtime voices your codex offers, which codex lists when this tab
  opens, or **Codex default**. It is heard from the next time the line opens.
- **Prompt** (empty by default): your own instructions for the voice, such as "Speak with me in
  Spanish", up to 2,000 characters. They are added after LiveBridge's own rules for the voice,
  which win where the two disagree, and apply from the next time the line opens.
- **Play sounds for requests and answers** (on by default): a short sound for each request the voice
  hands off ([why](known-limitations.md)), and one for each answer, failure or question from Claude
  that reaches an open or opening line while nobody is speaking. The chime for a result that waits
  plays either way.

**Line** holds how long the line stays open in quiet and how it connects:

- **Silence before the line closes** (20 seconds by default), **Wait for a first word on a line
  a result opened** (5 seconds) and **Sound without words before the line closes** (90 seconds):
  how long each kind of quiet keeps an open line, from 0 to 300 seconds. 0 switches the silence or
  the sound without words off, and a first-word wait of 0 waits as long as the silence. With all
  three at 0, quiet never closes the line: it stays open, billed all the while
  ([Billing](#billing-aware-by-design)), until you press Stop, change the target or OpenAI closes
  it. A short silence closes the line inside ordinary pauses, and each reopening takes a few
  seconds before the voice answers, so Settings warns at 1 to 9 seconds; so it does for sound
  without words, which your speech counts as until it is recognised, and at 1 to 3 seconds for the
  first word, as the voice often starts about 2 seconds after the line connects. A timer you turn
  on starts at once on a quiet open line; one already counting keeps its time.
- **Connect over TCP** (off by default): if the voice breaks up on a poor connection, turn this on.
  The line then prefers the TCP route the media server offers (port 443 in the answers seen) to
  UDP, and can still fall back to UDP. On a lossy connection that can turn breakups into short
  pauses between phrases ([how far it is tested](known-limitations.md)). A line that is open when you
  change it closes and opens again at once, after you confirm; what the voice was saying is cut
  off, and a result the line was waiting for still comes to the new one.

**Context** holds how your sessions reach the voice:

- **Pause sync while the call is stopped** (off by default): by default, what you type in a joined
  session and Claude's final answer to it are kept in that session's conversation with the voice
  even while the call is stopped, and the voice has them when the next line opens. None of it
  reaches OpenAI until a line opens. For text you do not want to reach OpenAI, turn this on, turn off the next
  setting if the session may have no summary yet, press Stop, then type: nothing you type while the call is stopped is recorded, and the session is marked as
  paused. While it is on, no line loads a summary by itself, and neither does one after a pause,
  except for a session with no summary (the next setting); otherwise only **Load context** does. That
  summary is written from the transcript, so it carries what you paused. Typing into a turn that runs a voice request fails its
  answer, with nothing of it recorded or said. It removes nothing already recorded, and Claude's
  later answers may repeat paused text; [SECURITY.md](../SECURITY.md#residual-risk-by-design) says what
  it does and does not do.
- **Load a session's context on its first call** (on by default; off if **Pause sync** was on when you updated to it): Start, a
  change of target during the call, or a line that opens, for a session the voice has no summary
  for, asks for one even while **Pause sync** is on or the session is paused, an old chat or a chat after **New conversation** included. That summary
  is written from the transcript, so it carries what you paused, and it goes to OpenAI. Once
  a session has a summary, the pause governs what follows. With this off, only **Load context**
  loads a summary under the pause.
- **Summary model** (Haiku 5.5 by default, on an update too; or Sonnet 5.5, Opus 5.5 or
  **Custom…**): the model that writes the summary the voice gets as context, always at low effort,
  on your Claude usage. If another model fails, Haiku 5.5 writes it instead, unless that model ran
  out of time. A line under it says when the last summary came from Haiku 5.5 instead, or from no
  model, and why. A session on a mod from before this setting ignores it and writes with the
  session's own model. **Custom…** takes
  a model id and **Check and save**, which has a joined session send that model one short request
  ("Reply with OK.") on your Claude usage, and saves the id only if it answers; otherwise the
  reason shows beside the field and the previous choice stays. It needs a session on a mod of
  this version, and speaks for that session's Claude Code: another session can differ, and a
  saved id is not checked again.

### What the voice does

- It answers small talk and explanations itself, and hands off anything that needs the
  repository or the session: tasks, questions about the code, decisions, corrections and stops.
- Before it hands off anything destructive or outward (delete, push, publish, send, deploy,
  pay) it repeats the request and asks "yes?". This is a habit the voice is told to keep, not a
  safeguard; [SECURITY.md](../SECURITY.md) says what is one.
- It reads results back in a sentence or two, with the session's name. Code blocks and tables
  stay in the session, and credentials it recognises are redacted.
- It comes back when Claude is done. You need not keep the line open: the line closes when the talk
  goes quiet, and Claude's answer to your request opens it again and is given to the voice to say,
  so you can walk away while Claude works. That holds for the session you are talking to; another
  session's result chimes and waits ([how it is billed](#billing-aware-by-design)). If the voice
  stays silent on the reopened line, the answer chimes and waits too, so it is not lost. A question
  Claude asks you or a permission prompt it waits on opens the line the same way, but the voice may
  not say it: do not rely on that when away from the Mac ([known limitations](known-limitations.md)).
- When Claude asks a question, it is given to the voice to put to you, and your answer goes back to
  that session. So it is with a question Claude asks while it works (the dialog with options): the
  voice is given it to tell you about, explain the options in its own words and talk them over with
  you for as long as you like, without asking Claude. What you decide, an option or a question back
  to Claude, answers the dialog; you can still answer it at the keyboard instead. Work Claude
  finishes later in the background goes to the voice as an update.
- When Claude is waiting for a permission prompt, the voice is given a notice and may say so, except
  [where an organization manages Claude Code](known-limitations.md). You answer the prompt in Claude
  Code; LiveBridge never answers it for you.
- It is given what you type. While a session is joined, what you type in it and Claude's final
  answer to each turn that was not a voice request go into that session's conversation with the
  voice, as context: they never chime and do not open a closed line ([the limits on
  this](known-limitations.md)). A line that is open gets them at once; a line opened later is seeded
  with them. A voice answer that a newer request superseded is not said but is kept and added the
  same way. Claude's text in the middle of a turn is not synced, except what it wrote just before a
  question or a permission prompt, which goes with that; subagents and tool output are not synced. A
  question or a permission prompt in the target is given to the voice, whichever turn caused it; in
  another session it goes as a result from that session would, except that one from a turn that was
  not a voice request is only recorded. A turn the pause keeps out has none of this. When a question
  or a prompt is settled without the voice, or a turn ends without an answer, the voice is given a
  line saying so ([which lines](../SECURITY.md#what-session-text-can-do)).

## Billing-aware by design

A realtime voice session costs while it is open, so LiveBridge opens it only while someone is
talking, while Claude's answer to a request you just made may still come, or to say that answer,
a question Claude asks you, or that Claude waits for your approval:

- While a call is on and nobody is talking, the microphone feeds only a voice detector on your
  Mac. No audio is sent anywhere.
  While muted, LiveBridge holds no microphone, and macOS's microphone indicator shows that.
- When you start speaking, the line opens. The 2 seconds before you started are kept and sent
  first, so your first words are not lost.
- The line closes after a stretch of silence, and sound without words (music, a TV) closes it after
  a stretch of its own. [Settings](#settings) sets each; at 0, that one does not close it.
- When the voice hands a request to Claude (a handoff), the line stays open for up to 2 minutes
  after that handoff, billed like any open line, and Claude's answer goes to the voice to say once
  nobody is talking. A later handoff starts the 2 minutes again; an exchange that sends nothing to
  Claude closes after the usual silence.
- Claude's answer to a request you handed the session you are talking to, a question Claude asks you
  there, or a permission prompt it waits on opens the line again when it comes after the line
  closed, and is given to the voice to say, billed like any open line. Anything else that arrives
  while the line is closed (anything from a session you switched away from, a later update) plays a
  chime and waits: the band and the menu show it as unheard, and it goes to the voice when you next
  speak ([when it counts as
  heard](architecture/overview.md#a-result-while-the-line-is-closed)).
- Each Claude Code session has its own conversation with the voice. It is carried over to the
  next realtime session, and across Stop and Start, so the voice remembers what you said a minute
  ago. A new target switches the conversation: an open line closes, and your next words open it
  with the new target's.
- The menu shows the minutes the line was open, counted by the app from when the voice connects, so
  your plan may count a little more. OpenAI prices desktop voice per minute of your Codex usage
  budget, and on its API the same model family bills silence too
  ([details](research/2026-11-04-gpt-live-billing.md),
  [limits](research/2026-11-05-gpt-live-limits.md)); your plan's own usage page is the
  authority.
- The menu shows how much of your Codex and Claude usage is used, a row each, as the percent used
  of every window the plan reports (up to three a row, for example `7% of 5 h · 19% of week`),
  orange from 90 %; hover a row for when each window resets. Codex's figures are read each time
  the menu opens, at most once a minute, by a short-lived codex; Claude's come from a joined
  session once it has answered. A row with nothing to show is left out, and the Codex row says
  `blocked` when codex reports ordinary usage as not allowed. The last Codex reading shows at once and
  a new one replaces it a few seconds later, so the figures can change with the menu open; right
  after launch the row appears when the first read lands, and if reads fail a reading goes after
  15 minutes. Which limit stops the voice first
  is not documented ([details](research/2026-11-05-gpt-live-limits.md)).

## Updating

LiveBridge updates itself and its mod when you click **Install**, and never on its own. Only
the copy at `/Applications/LiveBridge.app` updates; any other copy says so in Settings.

- **Check for updates automatically**, in Settings (on by default, off for a build from
  source): once a day, the app asks GitHub which release is the latest. A newer one is
  announced once, with a notification whose **Install** installs it, and the menu bar menu
  offers **Install LiveBridge X.Y.Z…** until it is installed, asking GitHub again at each launch
  to keep that item. **Check for update** in Settings asks at once.
- **Install** needs the [GitHub CLI](https://cli.github.com) signed in (`gh auth login`);
  without it, Install downloads nothing and links to the release page. It downloads the
  release's image, checks it with the same `gh attestation verify` as
  [From the disk image](../README.md#from-the-disk-image) shows, then checks the
  app inside it, and installs nothing unless every check passes. It waits while Claude is still
  on a voice request, updates the mod with `claude plugin marketplace update livebridge` and
  `claude plugin update livebridge@livebridge`, stops the call, puts the new app in place in one
  step and opens it.
- Afterwards Settings says which version it updated from. If the mod could not be updated, it
  shows those two commands for you to run. Claude Code sessions already open keep the old mod
  until they restart; Settings lists the joined ones that still do.
- The update's download sets no quarantine attribute, so macOS should not stop the updated
  app's first launch to ask, as it did after the first download; this follows from the code and
  has not yet been observed. The checks above are what stands in its place
  ([SECURITY.md](../SECURITY.md#what-an-update-installs)). Releases after 0.4.2 are signed with
  LiveBridge's Developer ID, so the microphone permission should carry over from one to the
  next; this follows from how macOS keys the permission and has not yet been observed. 0.4.2 and
  earlier were signed ad hoc, so the first update from one of them asks for the microphone once
  more, at the first **Start**.

To update by hand instead, run `/live off` in every session (the mod reopens the app at
`/Applications` whenever the app stops answering), quit LiveBridge, install the newer image as
[Install](../README.md#install) says and run the two `claude plugin` commands.

## Uninstall

In the copy in `/Applications`, the menu's **Feedback & Support ▸ Uninstall LiveBridge…** asks
first, then moves the app to the Trash; if it cannot, it says so, leaves the app where it is and
puts back any login item it removed first, and if macOS does not let it put that login item back,
it says that too, and how to turn **Open at login** on again. Then a call open ends and every session leaves LiveBridge, as the
menu's × does, so `/live`
turns off in each instead of opening LiveBridge again; LiveBridge removes its login item and
microphone permission and quits, and once it has quit, the files it keeps (listed below) go to a
folder in the Trash, until you empty it. It leaves the Claude Code mod, and
copies the command that removes it, `claude plugin uninstall livebridge@livebridge`, for you to run
in Terminal. A session that was not open then may still look for LiveBridge when it opens again;
removing the mod ends that.

Installed with Homebrew? `brew uninstall --cask getlivebridge/tap/livebridge` removes the app
and Homebrew's record of it; the steps below still cover the files the app keeps.

From a clone, `scripts/build-app.sh --uninstall` removes `/Applications/LiveBridge.app`,
however it was installed, its login item and every file it keeps, and prints the two commands
it leaves to you: `tccutil reset Microphone com.getlivebridge.livebridge` and
`claude plugin uninstall livebridge@livebridge`.

By hand, without a clone, turn off **Open at login** in LiveBridge's Settings, quit LiveBridge, and run
the same steps in Terminal:

```sh
rm -rf /Applications/LiveBridge.app ~/Library/Application\ Support/LiveBridge \
  ~/Library/{Caches,WebKit}/com.getlivebridge.livebridge \
  ~/Library/HTTPStorages/com.getlivebridge.livebridge{,.binarycookies} \
  ~/Library/Preferences/com.getlivebridge.livebridge.plist
tccutil reset Microphone com.getlivebridge.livebridge
claude plugin uninstall livebridge@livebridge
```

None of these removes a copy named `/Applications/.LiveBridge-update-….app`, which an update stopped
mid-install can leave behind. The app removes such copies at its next launch; after an
uninstall, delete one by hand if it is there.

`claude plugin uninstall` may leave the mod's snapshot, `~/.claude/plugins/store/livebridge_*.json`:
Claude Code's documentation of what it deletes does not name that file, and this was not run. Delete
it by hand if it is there.
