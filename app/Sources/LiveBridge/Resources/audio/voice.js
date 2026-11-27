// How loud the voice is, from the peer's `inbound-rtp` audio stats. The voice's words reach the
// app as text many seconds after it starts saying them (ADR 0001 (s)), so its sound is what tells
// the line it speaks. Pure: tested with node --test.

/**
 * The RMS (linear, 0 to 1) of what the voice played between two reports of its inbound audio:
 * the square root of the energy added over the seconds played. Null for the first report, 0 when
 * nothing played in between; a report without energy gives its instant `audioLevel`.
 */
export function voiceRms(previous, report) {
  if (report.totalAudioEnergy === undefined) return report.audioLevel ?? 0;
  if (!previous) return null;
  const seconds = report.totalSamplesDuration - previous.totalSamplesDuration;
  if (!(seconds > 0)) return 0;
  return Math.sqrt(Math.max(0, report.totalAudioEnergy - previous.totalAudioEnergy) / seconds);
}
