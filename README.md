<p align="center"><b>English</b> · <a href="docs/i18n/README.zh-CN.md">简体中文</a> · <a href="docs/i18n/README.hi.md">हिन्दी</a> · <a href="docs/i18n/README.es.md">Español</a> · <a href="docs/i18n/README.fr.md">Français</a> · <a href="docs/i18n/README.ru.md">Русский</a> · <a href="docs/i18n/README.uk.md">Українська</a></p>

<p align="center"><img src="site/assets/icon.png" alt="LiveBridge app icon" width="144"></p>

<h1 align="center">LiveBridge</h1>

<p align="center"><strong>Talk to an open Claude Code session by voice.</strong></p>

<p align="center">For Claude Code users on an Apple Silicon Mac with a ChatGPT plan whose Codex includes voice.</p>

<p align="center">
  <a href="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml"><img src="https://github.com/getLiveBridge/LiveBridge/actions/workflows/ci.yml/badge.svg?branch=main" alt="CI"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/getLiveBridge/LiveBridge"><img src="https://api.scorecard.dev/projects/github.com/getLiveBridge/LiveBridge/badge" alt="OpenSSF Scorecard"></a>
  <a href="https://www.bestpractices.dev/projects/16502"><img src="https://www.bestpractices.dev/projects/16502/badge" alt="OpenSSF Best Practices"></a>
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B%20%C2%B7%20Apple%20Silicon-lightgrey.svg" alt="Platform: macOS 14+ on Apple Silicon">
</p>

<p align="center">
  <a href="https://getlivebridge.com">getlivebridge.com</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#install">Install</a> ·
  <a href="#use">Use</a> ·
  <a href="#billing-aware-by-design">Billing</a> ·
  <a href="#privacy">Privacy</a> ·
  <a href="#known-limitations">Limitations</a> ·
  <a href="#roadmap-and-help-wanted">Help wanted</a> ·
  <a href="#contributing">Contributing</a>
</p>

LiveBridge is a macOS menu bar app that keeps a GPT-Live voice line ready through `codex app-server`
on your ChatGPT login (no API key). The voice is the front desk: it chats, asks what you mean, and
hands real work to your Claude Code session through a small Claude Code mod, `livebridge`. Claude
does the work with its own model, tools and permission mode, and the voice tells you the result.
The voice also follows what you type in the session and what Claude
answers, so you can switch between speaking and typing.

**A conversation, not dictation.** GPT-Live listens while it talks: cut in and it stops and hears you
out, think out loud and it can drop in a quick "mm-hmm". **The line closes when the talk goes
quiet:** OpenAI prices voice by the minute, so after a stretch of silence you set in
[Settings](docs/guide.md#settings) (20 seconds by default) the line closes, and it opens again
when you speak, with the conversation where you left it. The silence before it closes is billed,
and so is the wait of up to 2 minutes for Claude's answer after a handoff; **Mute** does not close
the line, so it saves no minutes ([Billing](#billing-aware-by-design)).

- **Claude's turns go to the work.** Ask "what did you mean?" or "what is the risk with B?" and
  the voice is told to answer it from the conversation it shares with the session, so the
  question does not start a turn of Claude's. Once you have decided, it hands Claude a brief, with
  what was said since the last request quoted after it; a question that needs the code still goes
  to Claude. When the voice lacks part of the session, the line asks for a short summary on the
  side, written by the model set in Settings (Haiku 5.5 by default) (while **Pause sync** is on,
  only when it has no summary).
- **Walk away while Claude works.** Claude's answer to your request opens the closed line again
  and the voice says it. If the voice stays silent, the answer chimes and waits, so it is not lost
  ([what can go wrong](#known-limitations)).
- **Claude's questions, talked through.** When Claude stops to ask you something with options, the
  voice is given the question to put to you: it explains the options in its own words for as long
  as you like, and your choice goes back as the answer. It may not bring the question up by itself
  ([known limitations](#known-limitations)).
- **One voice for all your sessions.** Join several sessions and pick the one to talk to from the
  menu; another session's result that arrives while the line is closed chimes and waits until you
  next speak.
- **Your language.** The voice is told to answer in the language you speak
  ([one limit](#known-limitations)).

Claude Code's own `/voice` turns what you say into a prompt for Claude. LiveBridge is someone to
talk it over with first, while Claude keeps working or waits.

<p align="center"><img src="docs/assets/readme-demo.gif" alt="Talking to a Claude Code session through LiveBridge" width="100%"></p>

<p align="center">The GIF has no sound: <a href="https://getlivebridge.com/assets/livebridge-demo.mp4">watch the 64-second demo with sound</a> on getlivebridge.com.</p>

**Local by design.** No telemetry and no server of its own: LiveBridge is a bridge on your Mac
between your own codex and your own Claude Code. The mod talks to the app over a Unix socket only
your user can open, and the app listens on no network port. Your voice, and what you type in a joined
session, and Claude's answers and summaries go to OpenAI through your codex, only while a line is
open; Claude's work goes to
Anthropic through your Claude Code. The app's only traffic of its own is a usage read through
your codex when you open the menu, and [updates](docs/guide.md#updating) from GitHub, whose automatic check
you can turn off. [Privacy](docs/privacy.md) lists exactly what reaches OpenAI and every request to
GitHub; [SECURITY.md](SECURITY.md) says what this does and does not protect against.

Free and open source under the [MIT license](LICENSE). The voice runs on your ChatGPT plan, so
there is no API key and no separate bill: its minutes come out of your plan's
Codex usage ([Billing](#billing-aware-by-design)).

> **Status:** 0.x, one maintainer. **Unofficial:** not affiliated with, endorsed by or supported by
> Anthropic or OpenAI. LiveBridge uses codex's experimental realtime API on your ChatGPT login,
> which OpenAI does not document as a path for third-party apps, and a codex release can break it.
> Use it at your own risk.
>
> **Needs:** Apple Silicon with macOS 14 or later, Claude Code 2.1.301 or later, and
> [codex](https://github.com/openai/codex) signed in (`codex login`) to a ChatGPT plan whose Codex
> includes voice; the voice's minutes count against that plan. Building the app yourself also needs
> Xcode with Swift 6.0 or later. The details are under [Requirements](#requirements).

## Quick start

```sh
# 1. The app, from LiveBridge's own Homebrew tap
brew install --cask getlivebridge/tap/livebridge

# 2. The mod, from this repository's marketplace
claude plugin marketplace add getLiveBridge/LiveBridge
claude plugin install livebridge@livebridge
```

3. Open LiveBridge from Applications. The first time, macOS asks whether to open an app
   downloaded from the internet; click **Open**. LiveBridge runs in the menu bar.
4. In the Claude Code session you want to talk to, type `/live`. It answers "Joined LiveBridge.",
   and a band appears above the prompt with **Voice off**, the session the call talks to, and
   **Start**.
5. Press **Start**. The first time, macOS asks for the microphone: allow it. It may also ask
   whether LiveBridge may find devices on your local network; the voice line needs that too. The
   band now reads **Listening**: a voice detector on your Mac waits for you to speak, and nothing is
   sent yet.
6. Ask "What is this session working on?". The band shows **Connecting**, then **Live**, and the
   voice answers, from the session's conversation or by handing the question to Claude. Ask for a
   change, and the voice hands it to Claude and tells you the result when Claude is done. When the
   talk goes quiet, the line closes and the band reads **Listening** again
   ([when](#billing-aware-by-design)).

No Homebrew? Each [release](https://github.com/getLiveBridge/LiveBridge/releases/latest) has
the app as a disk image, built and attested by GitHub Actions
([From the disk image](#from-the-disk-image)), or build it yourself
([From source](#from-source)). The mod is installed the same way whichever you choose.

If `/live` is not found in a session that was already open, reopen the session
([why](#known-limitations)). [Install](#install) covers the disk image, building from source and
permissions; [Updating](docs/guide.md#updating), [Uninstall](docs/guide.md#uninstall) and [Use](#use) cover the rest.

## Requirements

- macOS 14 or later on Apple Silicon.
- Claude Code 2.1.301 or later.
- [Codex CLI](https://github.com/openai/codex) (`codex`, tested with 0.172.0), installed with
  Homebrew (`brew install --cask codex`) or npm (`npm install -g @openai/codex`), on the `PATH`
  your shell sets in a Terminal window, and signed in with `codex login` to a ChatGPT plan whose
  Codex includes voice (Plus, Pro, Business, Enterprise or Education, per
  [OpenAI's Codex pricing](https://learn.chatgpt.com/docs/pricing)). LiveBridge refuses a codex
  whose `codex features list` it cannot read, so another version may not start until LiveBridge
  is updated.
- To build the app: Xcode with a Swift 6.0 toolchain or later. The tested versions are in
  [CONTRIBUTING.md](CONTRIBUTING.md#toolchain). The built app runs on macOS 14 or later.

## Install

The mod comes from this repository's marketplace (the [Quick start](#quick-start) commands),
which names the latest release's tag, so the mod you install is that release's. The app goes in
`/Applications` whichever way you install it: with Homebrew, from the disk image, or built from
source. From the first release after 0.4.2, the disk image, which Homebrew installs too, is
signed with LiveBridge's Developer ID and notarized by Apple; 0.4.2 and earlier were signed ad
hoc and not notarized, and a build from source is neither signed with the Developer ID nor
notarized.

### From the disk image

1. Download
   [LiveBridge.dmg](https://github.com/getLiveBridge/LiveBridge/releases/latest/download/LiveBridge.dmg)
   from the latest release.
2. Check it with the [GitHub CLI](https://cli.github.com), in the folder you saved it to:

   ```sh
   gh attestation verify LiveBridge.dmg --repo getLiveBridge/LiveBridge \
     --signer-workflow getLiveBridge/LiveBridge/.github/workflows/release.yml \
     --source-ref refs/tags/vX.Y.Z --deny-self-hosted-runners
   ```

   with `vX.Y.Z` the release's tag, as its page names it. This passes only for an image that
   this repository's [release workflow](.github/workflows/release.yml) built from that tag, on a
   GitHub-hosted runner, and that has not changed since. On a release after 0.4.2, the Developer
   ID signature, which macOS checks by itself, says who signed the image, and this says what it
   was built from; on 0.4.2 and earlier, whose ad hoc signature names no one, this is the image's
   one proof of origin. It does not prove that anyone reviewed the code.
3. Open it and drag LiveBridge to Applications.
4. On first launch, a release after 0.4.2 makes macOS ask whether to open an app downloaded
   from the internet; click **Open**. 0.4.2 and earlier are blocked until you allow them under
   System Settings > Privacy & Security > **Open Anyway**.

### With Homebrew

```sh
brew install --cask getlivebridge/tap/livebridge
```

This installs the same disk image from [LiveBridge's own tap](https://github.com/getLiveBridge/homebrew-tap), which is not one of Homebrew's
casks. Homebrew may ask you to trust the tap first, and macOS asks at the first launch as above. The
app then updates itself, as [Updating](docs/guide.md#updating) says.

### From source

`scripts/build-app.sh --release` builds the app, installs it in `/Applications` (your account
must be able to write there, as an administrator's can) and opens it. Run it again to rebuild.
The build is signed ad hoc, so macOS asks for the microphone again after each rebuild. To keep
the permission, run `scripts/build-app.sh --make-signing-identity` once: it asks first, then
creates a self-signed code-signing certificate in your login keychain, and later release builds
are signed with it.

The marketplace pins the mod to the last release's tag, so an app built from the default branch
runs with that release's mod. To match them, build the release's tag (`git checkout vX.Y.Z`), or
load the working tree's mod with `claude --plugin-dir plugin`.

A build from source checks for updates by itself only if you turn that on in Settings.
Installing an update replaces it with the release's image, which is signed with LiveBridge's
Developer ID, not your self-signed certificate, so macOS asks for the microphone once more;
**Install** says so and asks first.

### Permissions

The first Start asks macOS for the microphone. If it was refused, the call stops with a
sentence and the menu bar menu's **Open Microphone Settings** opens Privacy & Security >
Microphone, where you allow LiveBridge. macOS asks again at the first Start after the first
update from an ad hoc release, and after every rebuild from source signed ad hoc (see above).
macOS may also ask whether LiveBridge may find
devices on your local network. The voice line needs that second permission too; without it the
call stops with a sentence that says where to allow it.

### Updating and uninstalling

LiveBridge updates itself and its mod when you click **Install**, and never on its own;
[Updating](docs/guide.md#updating) says what it checks first and how to update by hand.
[Uninstall](docs/guide.md#uninstall) covers the menu's **Uninstall LiveBridge…**, Homebrew, a
clone and the steps by hand.

## Known limitations

[docs/known-limitations.md](docs/known-limitations.md) has the full list, with the record behind
each measured item. In short:

- **The voice is a language model, and it does not always do what it is told.** It sometimes says
  it is looking without handing the request off, so nothing reaches Claude: if the short sound for
  a queued request does not follow, say it again. It can stay silent when Claude's answer reopens
  the line; the answer then chimes and waits. It may not mention a question or a permission prompt
  Claude waits on, so do not rely on it to announce one when you are away from the Mac. The prompt
  still waits in Claude Code, and LiveBridge never answers it.
- **At your ChatGPT plan's usage limit** the voice stops until the limit resets. Claude Code keeps
  working, and its answers wait.
- **Where an organization manages Claude Code**, nothing in LiveBridge tells you that a permission
  prompt is waiting, and some managed settings keep the mod from loading.
- **`/live`** may need the session reopened if the session was open before the mod loaded.
- **Connect over TCP** prefers TCP but does not force it, and nothing shows which transport a line
  took.
- Whether the voice has said a waiting result is judged by its words, in English and Russian only.
  The full list also covers prompts that were not typed, providers without the summary model, and
  sessions still on an older mod.

## Use

In the Claude Code session you want to talk to, `/live` joins LiveBridge and `/live off` leaves.
**Start**, in the band above the prompt or in the menu bar menu, starts the call; **Mute** releases
the microphone while the call goes on, **Stop** ends the call, and **Talk here** moves it to the
session whose band you press. The menu bar menu lists the joined sessions, the target's conversation
with the voice, your minutes and usage, and **Settings…**: the voice, your own prompt for it, how
long quiet keeps the line open, and how your sessions reach the voice.

[docs/guide.md](docs/guide.md) describes each command, the band, the menu and every setting, and
what the voice does with your requests and with Claude's answers and questions.

## Billing-aware by design

A realtime voice line costs while it is open, so LiveBridge opens it only while someone is talking,
while Claude's answer to your request may still come (up to 2 minutes after each handoff), or to
tell you Claude's answer, a question it asks you, or that it waits for your approval. While the line
is closed, the microphone feeds only a voice detector on your Mac, and no audio is sent. The menu
shows the minutes the line was open and how much of your Codex and Claude usage is used; your
plan's own usage page is the authority. [docs/guide.md](docs/guide.md#billing-aware-by-design) has
each rule.

## Privacy

In short: no telemetry, no server of its own and no network port, and your voice, what you type in
a joined session, and Claude's answers and summaries reach OpenAI through your codex only while a
line is open. [docs/privacy.md](docs/privacy.md) lists each item that reaches OpenAI and its limits,
what the credential redactor covers, each request to GitHub, and what the app keeps on your Mac.

[SECURITY.md](SECURITY.md) has the threat model: in short, anything your microphone can hear
can become a request that Claude runs under the session's own permission mode.

## How it works

[docs/architecture/overview.md](docs/architecture/overview.md) describes the components, the
wire between the mod and the app, and the message flows;
[ADR 0001](docs/adr/0001-platform-findings.md) records the platform facts the design rests on.

## Roadmap and help wanted

LiveBridge today is one Mac app, one worker (Claude Code) and one voice provider (codex on a
ChatGPT login). The three meet at narrow seams, and each direction below is open to
contributors. Issues for them carry the
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
label; [CONTRIBUTING.md](CONTRIBUTING.md#where-to-start) points to the files to read first.

- **Windows and Linux.** The menu bar app, its audio page and the socket server are tied to
  macOS; the wire between the mod and the app, and the mod itself, are portable. A port starts
  with an app for the new platform that speaks the same wire.
- **Other agents as the worker**, such as Codex CLI, Hermes Agent or Gemini CLI: each needs its
  own adapter that speaks the same wire as the Claude Code mod.
- **Other voice providers**, such as the OpenAI Realtime API with your own API key or Google's
  Gemini Live API: each would be another implementation of the app's realtime protocol.

## Contributing

Contributions are welcome. For anything larger than a fix, open an issue first so the shape can
be agreed before the work starts. Good places to begin are the
[help wanted](https://github.com/getLiveBridge/LiveBridge/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)
issues, the [known limitations](#known-limitations) and the directions
[above](#roadmap-and-help-wanted).

You may use coding assistants: say in the pull request which parts a tool generated, run
`scripts/check.sh`, and be ready to explain every changed line
([AI-assisted contributions](CONTRIBUTING.md#ai-assisted-contributions)).

- [CONTRIBUTING.md](CONTRIBUTING.md): the layout, the toolchain, the checks (`scripts/check.sh`)
  and the conventions.
- [Issue forms](https://github.com/getLiveBridge/LiveBridge/issues/new/choose): report a bug or ask for a feature.
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): how we treat each other here.
- [SECURITY.md](SECURITY.md): report a vulnerability privately, not in a public issue.
- [CHANGELOG.md](CHANGELOG.md): what changed in each release.

## Credits

The wire protocol between the mod and the app was inspired by
[claude-code-voice-mod](https://github.com/ldk00315-jpg/claude-code-voice-mod). No code or text
was copied from it.

## License

[MIT](LICENSE).
