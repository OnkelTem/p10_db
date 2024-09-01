import 'package:logging/logging.dart';
import 'package:p10_db/version.dart';
import 'package:p10_db/migrations.dart';
import 'package:p10_db/db.dart';

final log = Logger('migrate');

migrateCommand(String dbPath, bool one) async {
  log.info('Updating the database: "$dbPath"');

  int count = 0;
  int currentVersion = 0;

  for (final MapEntry(key: ver, value: applyUpdate) in migrations.entries) {
    final db = Db.open(dbPath);

    final dbVersion = db.getVersion();

    if (dbVersion >= currentDbVersion) break;

    if (dbVersion < ver) {
      // Applying the migration
      log.info('Applying version v$ver migration');

      db.execute('''

        PRAGMA foreign_keys = ON;
        PRAGMA locking_mode = EXCLUSIVE;
        BEGIN EXCLUSIVE;

      ''');

      final updateRes = applyUpdate(db);
      if (updateRes) {
        db.updateVersion(ver);
      }

      db.execute('''

      COMMIT;

      ''');

      count++;
      currentVersion = ver;

      db.dispose();

      if (one) break;
    }
  }

  if (count > 0) {
    log.info('Successfully applied $count updates. Current version is $currentVersion');
  } else {
    log.info("You already use the latest database of version $currentDbVersion");
  }
}
