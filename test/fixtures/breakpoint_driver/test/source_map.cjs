'use strict';

// Hand-rolled Source Map v3 mappings decoding (base64 VLQ) so the driver can
// run inside the pinned Extension Host with zero npm dependencies.

const BASE64 =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
const CHAR_TO_INTEGER = new Map(
  [...BASE64].map((char, index) => [char, index]),
);

/**
 * Decodes a Source Map v3 `mappings` string into flat segments.
 *
 * Every returned segment carries 0-based `generatedLine`, `generatedColumn`,
 * `sourceIndex`, `originalLine`, and `originalColumn`. Segments without
 * source information (1-value VLQ groups) are skipped; name indices are
 * ignored because breakpoint binding only needs positions.
 */
function decodeMappings(mappings) {
  const segments = [];
  let sourceIndex = 0;
  let originalLine = 0;
  let originalColumn = 0;
  let generatedLine = 0;
  for (const lineText of mappings.split(';')) {
    let generatedColumn = 0;
    for (const segmentText of lineText.split(',')) {
      if (segmentText === '') {
        continue;
      }
      const values = [];
      let value = 0;
      let shift = 0;
      for (const char of segmentText) {
        const integer = CHAR_TO_INTEGER.get(char);
        if (integer === undefined) {
          throw new Error(`Invalid VLQ character in mappings: ${char}`);
        }
        value += (integer & 31) << shift;
        if ((integer & 32) !== 0) {
          shift += 5;
        } else {
          values.push((value & 1) === 1 ? -(value >>> 1) : value >>> 1);
          value = 0;
          shift = 0;
        }
      }
      generatedColumn += values[0];
      if (values.length >= 4) {
        sourceIndex += values[1];
        originalLine += values[2];
        originalColumn += values[3];
        segments.push({
          generatedLine,
          generatedColumn,
          sourceIndex,
          originalLine,
          originalColumn,
        });
      }
    }
    generatedLine += 1;
  }
  return segments;
}

/**
 * Finds the segment covering a generated position: the segment on the same
 * generated line with the greatest column that does not exceed the queried
 * column (standard source-map lookup semantics). Returns null when the line
 * has no covering segment.
 */
function findOriginal(segments, generatedLine, generatedColumn) {
  let best = null;
  for (const segment of segments) {
    if (
      segment.generatedLine === generatedLine &&
      segment.generatedColumn <= generatedColumn &&
      (best === null || segment.generatedColumn > best.generatedColumn)
    ) {
      best = segment;
    }
  }
  return best;
}

module.exports = {decodeMappings, findOriginal};
