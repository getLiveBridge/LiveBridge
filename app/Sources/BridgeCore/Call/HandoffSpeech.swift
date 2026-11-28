/// The speech since the last request a session took, word for word, which the next request
/// carries. codex's own `active_transcript` cannot be that: past 4 KiB of speech it moves the
/// finished lines into its thread's history at a line's end and leaves them out of the next
/// handoff (codex 0.172 `take_completed_transcript`), so a long turn reached the session as its
/// tail. The app hears every line, so it keeps them itself.
struct HandoffSpeech: Sendable {
  private var said: [Utterance] = []
  /// What a request took of each line still being said: that line's text at the last handoff.
  /// The next request, the conversation and the menu all leave it out.
  private var taken: [Role: String] = [:]

  /// `speaker`'s line ended as `text`. Returns the words it adds past what a request took; a
  /// final text that neither starts with that part nor is part of it is kept whole, as nothing
  /// tells the two apart. A part that ran on into the next line stays taken of that line.
  mutating func finish(_ speaker: Conversation.Line.Speaker, with text: String) -> String {
    guard let role = speaker.role else { return text }
    var rest = Substring(text)
    if let part = taken.removeValue(forKey: role) {
      if text.hasPrefix(part) {
        rest = text.dropFirst(part.count)
      } else if part.hasPrefix(text) {
        rest = ""
        let next = part.dropFirst(text.count).drop(while: \.isWhitespace)
        if !next.isEmpty { taken[role] = String(next) }
      }
    }
    let words = rest.trimmingCharacters(in: .whitespaces)
    if !words.isEmpty { said.append(Utterance(role: role, text: words)) }
    return words
  }

  /// The lines still being said (`growing`), without what a request took of them.
  func untaken(_ growing: [Conversation.Line]) -> [Conversation.Line] {
    growing.compactMap { line in
      guard let role = line.speaker.role, let part = taken[role], line.text.hasPrefix(part)
      else { return line }
      let rest = line.text.dropFirst(part.count).trimmingCharacters(in: .whitespaces)
      return rest.isEmpty ? nil : Conversation.Line(speaker: line.speaker, text: rest)
    }
  }

  /// The speech for a request: the finished lines, then what is new of the lines still being
  /// said (`growing`). What follows starts afresh.
  mutating func handOff(with growing: [Conversation.Line]) -> [Utterance] {
    let open = untaken(growing).compactMap { line in
      line.speaker.role.map { Utterance(role: $0, text: line.text) }
    }
    defer { said = [] }
    for line in growing { if let role = line.speaker.role { taken[role] = line.text } }
    return said + open
  }

  /// The line closed: no final text comes for what it was saying.
  mutating func lineClosed() { taken = [:] }
}
