import 'package:logging/logging.dart';
import 'package:p10_db/app.dart';
import 'package:p10_db/db.dart';
import 'package:p10_db/version.dart';
import 'package:sqlite3/sqlite3.dart';

final log = Logger('start');

startCommand(String dbPath) {
  try {
    final db = Db.open(dbPath);
    log.info('Using database: "$dbPath"');

    if (db.getIsEmpty()) {
      throw Exception("Database is empty");
    }

    if (!db.getHasVersion()) {
      log.shout("'ver' table not found");
      throw Exception("Database is either empty or not ours.");
    }

    final ver = db.getVersion();

    if (ver < currentDbVersion) {
      log.shout('The database version is $ver, which is behind the current version $currentDbVersion.');
      throw Exception('Database version doesn\'t match. Please run the "migrate" command.');
    } else if (ver > currentDbVersion) {
      log.shout('The database version is $ver, which is ahead of the current version $currentDbVersion.');
      throw Exception('Database version doesn\'t match. Please use a newer executable or an older database.');
    }

    // Enabling RI!
    db.execute('PRAGMA foreign_keys = ON');

    log.info('Running the app, database version: $ver');
    app(db);
    db.dispose();
  } on SqliteException catch (e) {
    if (e.resultCode == SqlError.SQLITE_CANTOPEN) {
      throw Exception('Can\'t open the database: "$dbPath". Run "p10_db init" to create one.');
    }
    rethrow;
  }
}
