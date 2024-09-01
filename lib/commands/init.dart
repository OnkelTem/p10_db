import 'dart:io';

import 'package:logging/logging.dart';
import 'package:p10_db/db.dart';

final log = Logger('init');

const dbSqlPath = 'db.sql';

initCommand(String dbPath, bool overwrite) {
  final db = Db.openCreate(dbPath);

  if (!db.getIsEmpty()) {
    log.warning('The target database is not empty: "$dbPath".');
    if (!overwrite) {
      log.info("Use --force to overwrite.");
      return;
    }
  }
  log.fine('Initializing database');
  final sql = File(dbSqlPath).readAsStringSync();
  db.execute(sql);
  log.info('Database created: "$dbPath"');
}
