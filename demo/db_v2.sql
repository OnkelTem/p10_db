PRAGMA foreign_keys = ON;

PRAGMA locking_mode = EXCLUSIVE;

BEGIN EXCLUSIVE;

DROP TABLE IF EXISTS ver;

DROP TABLE IF EXISTS preferences;

DROP TABLE IF EXISTS user;

CREATE TABLE
  IF NOT EXISTS ver (ver INTEGER NOT NULL);

INSERT INTO
  ver
VALUES
  (2);

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
    data TEXT,
    FOREIGN KEY (user_id) REFERENCES user (id)
  );

INSERT INTO
  preferences (user_id, data)
VALUES
  (1, '{"color":"red"}'),
  (2, '{"color":"blue"}');

COMMIT;
