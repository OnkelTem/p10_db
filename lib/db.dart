import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:sqlite3/sqlite3.dart';

final log = Logger('db');

enum Tables {
  ver,
  user,
  preferences;
}

class DbError extends Error {
  final String message;
  DbError(this.message);
  @override
  String toString() {
    return 'DbError: $message';
  }
}

class DbDataError extends DbError {
  final Row row;
  DbDataError(this.row) : super('Unexpected data: ${jsonEncode(row)}');
}

extension type Db._(Database db) implements Database {
  factory Db.openCreate(String dbPath) {
    return Db._(
      sqlite3.open(dbPath, mode: OpenMode.readWriteCreate),
    );
  }

  factory Db.open(String dbPath) {
    return Db._(sqlite3.open(dbPath, mode: OpenMode.readWrite));
  }

  bool getIsEmpty() {
    return db.select("SELECT name FROM sqlite_master WHERE type='table'").isEmpty;
  }

  bool getHasVersion() {
    return db.select("SELECT name FROM sqlite_master WHERE type='table' and name='${Tables.ver.name}'").isNotEmpty;
  }

  int getVersion() {
    final res = db.select("SELECT ver FROM ${Tables.ver.name}");
    if (res.isEmpty) {
      throw DbError('Table "${Tables.ver.name}" cannot be empty.');
    }
    if (res.first case {'ver': final int ver}) {
      return ver;
    }
    throw DbDataError(res.first);
  }

  void updateVersion(int ver) {
    db.execute("UPDATE ${Tables.ver.name} SET ver = ?", [ver]);
  }
}
