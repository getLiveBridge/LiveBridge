/// The speech since the last request a session took, word for word, which the next request
/// carries. codex's own `active_transcript` cannot be that: past 4 KiB of speech it moves the
/// finished lines into its thread's history at a line's end and leaves them out of the next
/// handoff (codex 0.172 `take_completed_transcript`), so a long turn reached the session as its
/// tail. The app hears every line, so it keeps them itself.
struct HandoffSpeech: Sendable {
  private var said: [Utterance] = []
  /// What a request took of each line still being said; that line's final text adds the rest.
  private var taken: [Role: String] = [:]

  /// `speaker`'s line ended as `text`. A line a request took part of adds only its words past
  /// that part; a final text that does not start with it is kept whole, as nothing tells the two
  /// apart.
  mutating func finish(_ speaker: Conversation.Line.Speaker, with text: String) {
    guard let role = speaker.role else { return }
    var rest = Substring(text)
    if let part = taken.removeValue(forKey: role) {
      if text.hasPrefix(part) {
        rest = text.dropFirst(part.count)
      } else if part.hasPrefix(text) {
        rest = ""
      }
    }
    let words = rest.trimmingCharacters(in: .whitespaces)
    if !words.isEmpty { said.append(Utterance(role: role, text: words)) }
  }

  /// The speech for a request: the finished lines, then the lines still being said
  /// (`growing`). What follows starts afresh.
  mutating func handOff(with growing: [Conversation.Line]) -> [Utterance] {
    let open = growing.compactMap { line in
      line.speaker.role.map { Utterance(role: $0, text: line.text) }
    }
    defer { said = [] }
    for line in open { taken[line.role] = line.text }
    return said + open
  }

  /// The line closed: no final text comes for what it was saying.
  mutating func lineClosed() { taken = [:] }
}
