import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:p10_db/db.dart';

final log = Logger('migrations');

final migrations = {
  2: (Db db) {
    db.execute('''

      PRAGMA foreign_keys = ON;

    ''');

    db.execute('''

      CREATE TABLE preferences (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        data TEXT,
        FOREIGN KEY (user_id) REFERENCES user (id)
      );

    ''');

    // Manually insert default data for existing users

    final prefData = {
      1: '{"color":"red"}',
      2: null,
      3: '{"color":"green"}',
    };

    final stmtInsert = db.prepare('INSERT INTO preferences (user_id, data) VALUES (?, ?)');

    for (final row in db.select('SELECT id FROM user')) {
      final userId = row['id'] as int;
      if (prefData.containsKey(userId)) {
        stmtInsert.execute([userId, prefData[userId]]);
      }
    }

    return true;
  },
  3: (Db db) {
    db.execute('''

      PRAGMA foreign_keys = ON;

    ''');

    db.execute('''

      ALTER TABLE preferences RENAME TO preferences_;

      CREATE TABLE preferences (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        color TEXT,
        FOREIGN KEY (user_id) REFERENCES user (id)
      );

    ''');

    final stmtInsert = db.prepare('INSERT INTO preferences (user_id, color) VALUES (?, ?)');

    for (final row in db.select('SELECT user_id, data FROM preferences_')) {
      if (row case {'user_id': final int userId, 'data': final String? jsonData}) {
        final data = jsonData != null ? jsonDecode(jsonData) : {};
        if (data case {'color': final String color}) {
          stmtInsert.execute([userId, color]);
        } else {
          log.warning('Can\'t find color value for user "$userId", skipping. Data were: $row');
        }
      } else {
        throw DbError('Unexpected data in the database: $row');
      }
    }

    db.execute('''

      DROP TABLE preferences_;

    ''');

    return true;
  },
};
