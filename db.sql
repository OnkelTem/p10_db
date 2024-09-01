PRAGMA locking_mode = EXCLUSIVE;

PRAGMA foreign_keys = ON;

BEGIN EXCLUSIVE;

DROP TABLE IF EXISTS ver;

DROP TABLE IF EXISTS preferences;

DROP TABLE IF EXISTS user;

CREATE TABLE
  IF NOT EXISTS ver (ver INTEGER NOT NULL);

INSERT INTO
  ver
VALUES
  (3);

CREATE TABLE
  IF NOT EXISTS user (id INTEGER PRIMARY KEY, name TEXT);

INSERT INTO
  user (name)
VALUES
  ('alice'),
  ('bob');

CREATE TABLE
  IF NOT EXISTS preferences (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    color TEXT,
    FOREIGN KEY (user_id) REFERENCES user (id)
  );

INSERT INTO
  preferences (user_id, color)
VALUES
  (1, 'red'),
  (2, 'blue');

COMMIT;
