> [!NOTE]
> This is a repo of a Dart newbie.

# P10_DB Sandbox

This is an example app that proposes an approach for
database versioning and migrations application.

On its own, it doesn't do much except for printing
some database values to the console.

## Basic usage

Initially there is no database, so we must create one:

```
$ dart run p10_db init
[init] Database created: "db.sqlite3"
```

Now we can start it:

```
$ dart run d10_db start
[start] Using database: "db.sqlite3"
[start] Running the app, database version: 3
user: id=1 name=alice
        preferences: color=red
user: id=2 name=bob
        preferences: color=blue
```

That's pretty much all it does as an app.

Now to the interesting part.

## Applying migrations

As you've may noticed, the app reported that it is using _version 3_ of the database.
That's because database is versioned.

In the `demo/` directory, there are a few previous versions of the database, so let's try them.

Creating the demo set:

```
$ dart demo/demo.dart
Creating demo database: "db_v1.sqlite3"
Creating demo database: "db_v2.sqlite3"
```

Trying the app with one of them:

```
$ dart run p10_db start --db db_v1.sqlite3
[start] Using database: "db_v1.sqlite3"
[start] The database version is 1, which is behind the current version 3.
[main] Exception: Database version doesn't match. Please run the "migrate" command.
```

Oops!

So the app detected that we're using an outdated database and demands its update.

Let's run the **migrate** command:

```
$ dart run p10_db migrate --db db_v1.sqlite3
[migrate] Updating the database: "db_v1.sqlite3"
[migrate] Applying version v2 migration
[migrate] Applying version v3 migration
[migrations] Can't find color value for user "2", skipping. Data were: {user_id: 2, data: null}
[migrate] Successfully applied 2 updates. Current version is 3

```

The migration command has applied two migrations from `lib/migrations.dart` file.
There was also _a warning_ about some data inconsistency (invented for demo purposes),
but it wasn't critical and hence - ignored.


## `--help`

```
An example CLI app that demonstrates data migrations.

Usage: p10_db <command> [arguments]

Global options:
-h, --help          Print this usage information.
    --db            Path the the database.
                    (defaults to "db.sqlite3")
    --[no-]brief    Make output less detailed.
                    (defaults to on)
-v, --verbosity     Verbosity level.
                    [all, finest, finer, fine, config, info (default), warning, severe, shout, off]

Available commands:
  init      Initializes the database.
  migrate   Updates the database via applying migrations.
  start     Runs the service.

Run "p10_db help <command>" for more information about a command.
```

## Contributing

You may consider activating git hooks by running:

```
$ dart run husky install

```
