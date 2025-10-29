import 'local_store.dart';

class SchemaMigrations {
  SchemaMigrations({required this.localStore, this.targetVersion = 10});

  final LocalStore localStore;
  final int targetVersion;

  static const String _versionKey = 'schema_version';

  Future<void> ensure() async {
    final data = localStore.readJson(_versionKey);
    final currentVersion = data?['version'] as int? ?? 0;
    if (currentVersion < targetVersion) {
      await localStore.writeJson(_versionKey, <String, Object>{'version': targetVersion});
    }
  }
}
