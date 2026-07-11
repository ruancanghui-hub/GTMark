class BackupParseFailure implements Exception {
  BackupParseFailure(this.message);
  final String message;

  @override
  String toString() => message;
}
