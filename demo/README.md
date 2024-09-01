# Demo

This folder contains files for recreating historical states
of the database to see how migrations work.

## Usage

Create demo databases:

```
$ dart demo/demo.dart
Creating demo database: "db_v1.sqlite3"
Creating demo database: "db_v2.sqlite3"
```

They represent previous versions of the current database,
so if you run the app against them you will be able to
apply the migrations.

## Database Schema History

### Version 1 [db_v1.sql](db_v1.sql)

Initially we have only one **user** table with user names.

### Version 2 [db_v2.sql](db_v2.sql)

Adding a new **preferences** table that's referencing
the **user** table via `user_id`.

It also has a `data` field that stores user data in JSON.

### Version 3 (current) [db.sql](../db.sql)

Getting rid of the complex `data` JSON field and replacing
it with the `color` field.
