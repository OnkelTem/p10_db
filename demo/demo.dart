import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

void main() {
  for (final v in ['1', '2']) {
    final dbPath = 'db_v$v.sqlite3';
    print('Creating demo database: "$dbPath"');
    final sql = File('demo/db_v$v.sql').readAsStringSync();
    final db = sqlite3.open(dbPath);
    // Clear the database first
    db.execute('''

      PRAGMA writable_schema = 1;
      DELETE FROM sqlite_master WHERE TYPE IN ('table', 'index', 'trigger');
      PRAGMA writable_schema = 0;

    ''');
    db.execute(sql);
  }
}
