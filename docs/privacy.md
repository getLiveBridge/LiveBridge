# Privacy

What reaches OpenAI and GitHub, and what LiveBridge keeps on your Mac. The
[README](../README.md#privacy) has the summary, and [SECURITY.md](../SECURITY.md) the threat
model.

LiveBridge has no telemetry and listens on no network port; the mod talks to the app over a Unix
socket in a folder only your user can open. What goes to OpenAI, through codex's realtime
session:

- microphone audio while the line is open, from 2 seconds before you started speaking (or, for a
  line Claude's answer, question or approval notice opened, from when it opened) until it closes
  (while muted LiveBridge captures nothing, so none goes; speech you said before pressing Mute, on a
  line that was already connecting, may still go);
- the voice's instructions: LiveBridge's own rules, then your Settings **Prompt** if you wrote
  one;
- the target session's recent conversation (up to the last 64 lines, and no more than codex takes:
  128 items and about 8,192 tokens with the context and open tasks) to continue it in a new realtime
  session. It holds what you typed in that session and Claude's final answer to each turn that was
  not a voice request, whatever started it (a turn you typed, a schedule, another agent, a
  background task), as well as the mod's notes and your speech and the voice's, so typing in a
  session sends it to OpenAI once a line opens with that session. While a line is open, each new
  line of the target goes in at once. Another session's synced lines go only when a line opens with
  it as the target; its results, questions and approval notices go into the open line whichever
  session it is;
- the target session's requests still open, as their one-line briefs;
- each result, question, update, approval notice, typed text, answer to a turn that was not a voice
  request, voice answer a newer request superseded and note of the mod's, as one line of at most
  2,000 characters, with code blocks and tables removed (typed text that is only code or a table is
  replaced by a sentence saying that code was typed). The mod's notes name the tool of a permission
  prompt that was allowed or settled, and say that a question was closed or that a turn ended
  without an answer. A question Claude asks mid-turn, and the approval notice for a permission
  prompt of Claude's main loop (not a subagent's), also carry what Claude wrote just before asking.
  An update is Claude's answer in a later turn started by a background task's notification, for up
  to 10 minutes after a voice request and until any other turn starts in the session;
- the target session's context summary, as one line of at most 1,500 characters. It is saved
  when it is loaded and sent every time the line opens while that session is the target, across
  Stop and Start and app restarts. The menu's Conversation submenu shows that line exactly as it
  is sent;
- with every line above, its session's label: the Claude Code session title (up to 80 characters),
  or the session folder's name when it has none. The label is not redacted and the pause does not
  touch it, so a title written from text you paused goes out on every line;
- the WebRTC offer, which lists the Mac's local network addresses as connection candidates.

With **Connect over TCP** on, the audio still goes to OpenAI's media server, and may go over TCP
(port 443 in the answers seen) instead of UDP.

Results, questions, updates, summaries and the lines of typed turns pass through a redactor of
known credential shapes first (private keys, JWTs, common API tokens, URL passwords,
`password=`-style fields). It is a list of patterns, not a guarantee: anything else you type
goes as typed.

The codex thread that carries the voice is ephemeral and read-only, with every codex feature
turned off except where it keeps your login and how it uses your proxy, and every MCP server
off; it is there only to talk. Claude's work goes to Anthropic as your Claude Code session
always does.

Opening the menu makes LiveBridge start a short-lived codex that asks OpenAI, with your ChatGPT
login, how much of your Codex usage is used (each window's percent and reset time). It happens at
most once a minute, also while the call is off, and sends no audio or text. Claude's figures reach
the app from the mod over the socket and go nowhere else; the app keeps both only in memory.

For updates the app talks to GitHub. With **Check for updates automatically** on, once a day
(and at each launch while a release it announced is not installed) it asks GitHub's API, without
credentials, which release is the latest; GitHub sees your Mac's IP address. **Check for update**
in Settings sends the same request when you press it. When the automatic check finds a newer
release, the app runs `gh auth status` to say whether the image can be verified. Only when you
click **Install** does it download the image and run `gh attestation verify` and
`claude plugin`, which reach GitHub, and Sigstore for `gh`'s trust root, under your own logins.
[SECURITY.md](../SECURITY.md#what-leaves-the-mac) lists each request.

On your Mac the app keeps its settings, the usage meter, when it last checked for an update and
which versions it announced, what the last update did and, for each of the 20 sessions used
last, its recent conversation (up to 64 lines, what you typed in it included, recorded with no
call running unless you turned on **Pause sync**) and the context line last loaded from it, in
`~/Library/Application Support/LiveBridge`, a folder only your user can open
([how it is kept](../SECURITY.md#residual-risk-by-design)). A session's lines go when you press **New
conversation** with it as the target or remove it with ×. A session that has left keeps them
until 20 sessions used since push them out; to erase them sooner, run `/live` in it again and
press **New conversation**. Uninstalling removes them all; the menu's Uninstall LiveBridge moves
them to the Trash, so they are gone once you empty it. The mod keeps a snapshot of its own in Claude Code's plugin store ([what it holds](../SECURITY.md#residual-risk-by-design)).
**Debug mode**, off by default, writes the voice's network numbers during a call to a file in that
folder, and nothing more ([Settings](guide.md#settings)).
