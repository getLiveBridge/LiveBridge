import assert from 'node:assert/strict';
import { test } from 'node:test';
import { voiceRms } from '../../Sources/LiveBridge/Resources/audio/voice.js';

const report = (totalAudioEnergy, totalSamplesDuration) => ({ totalAudioEnergy, totalSamplesDuration });

test('theLevelIsTheRmsOfWhatPlayedSinceTheLastReport', () => {
  // 0.1 s at a level of 0.1 adds 0.1² × 0.1 to the energy
  const level = voiceRms(report(1, 10), report(1 + 0.001, 10.1));
  assert.ok(Math.abs(level - 0.1) < 1e-9);
});

test('theFirstReportHasNoLevel', () => {
  assert.equal(voiceRms(null, report(1, 10)), null);
});

test('noSamplesSinceTheLastReportIsSilence', () => {
  assert.equal(voiceRms(report(1, 10), report(1, 10)), 0);
});

test('withoutEnergyTheInstantLevelStandsIn', () => {
  assert.equal(voiceRms(null, { audioLevel: 0.2 }), 0.2);
});
