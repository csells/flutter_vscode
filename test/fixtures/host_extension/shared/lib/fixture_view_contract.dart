/// Exact name of the fixture's single Host Dart operation.
const readHostValueOperationName = 'fixture.readHostValue';

/// Typed input accepted by the fixture's Host Dart operation.
final class ReadHostValueRequest {
  /// Creates a request for the host value identified by [key].
  const ReadHostValueRequest(this.key);

  /// Host-owned value to read.
  final String key;
}

/// Encodes a typed fixture request as an exact protocol snapshot.
Object? encodeReadHostValueRequest(ReadHostValueRequest request) {
  return <String, Object?>{'key': request.key};
}

/// Validates and decodes the exact fixture request schema.
ReadHostValueRequest decodeReadHostValueRequest(Object? value) {
  if (value case <Object?, Object?>{
    'key': final String key,
  } when value.length == 1) {
    return ReadHostValueRequest(key);
  }
  throw const FormatException('Expected exactly one string key.');
}

/// Encodes the typed Host Dart result.
Object? encodeReadHostValueResult(String value) => value;

/// Validates and decodes the typed Host Dart result.
String decodeReadHostValueResult(Object? value) {
  if (value is String) {
    return value;
  }
  throw const FormatException('Expected a string host value.');
}
