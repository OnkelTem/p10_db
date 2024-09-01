import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logging/logging.dart';
import 'package:p10_db/commands/init.dart';
import 'package:p10_db/commands/migrate.dart';
import 'package:p10_db/commands/start.dart';
import 'package:p10_db/loggers.dart';

final log = Logger('main');

void main(List<String> args) async {
  try {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    final runner = CommandRunner("p10_db", "An example CLI app that demonstrates data migrations.")
      ..addCommand(StartCommand())
      ..addCommand(InitCommand())
      ..addCommand(MigrateCommand());

    runner.argParser.addOption('db', help: 'Path the the database.', defaultsTo: env['DB_PATH']);

    runner.argParser.addFlag('brief', help: 'Make output less detailed.', defaultsTo: env['BRIEF'] == 'true');

    runner.argParser.addOption('verbosity',
        abbr: 'v',
        help: 'Verbosity level.',
        allowed: Level.LEVELS.map((level) => level.name.toLowerCase()),
        defaultsTo: env['VERBOSITY'] ?? 'info');

    await runner.run(args);
  } on Exception catch (e) {
    log.shout(e);
    exit(1);
  }
}

abstract class BaseCommand extends Command<void> {
  String get dbPath {
    final dbPath = globalResults?.option('db');
    if (dbPath == null || dbPath.isEmpty) {
      throw Exception('Path to the database is not set');
    }
    return dbPath;
  }

  @override
  void run() {
    final brief = globalResults?.flag('brief');
    final verbosity = globalResults?.option('verbosity');
    final level = Level.LEVELS.firstWhere((level) => level.name.toLowerCase() == verbosity, orElse: () => Level.INFO);
    initLoggers(level, brief ?? false);
  }
}

class StartCommand extends BaseCommand {
  @override
  final name = 'start';
  @override
  final description = "Runs the service.";

  @override
  void run() {
    super.run();
    startCommand(dbPath);
  }
}

class InitCommand extends BaseCommand {
  @override
  final name = 'init';
  @override
  final description = "Initializes the database.";

  InitCommand() {
    argParser.addFlag('force', abbr: 'f', help: 'Forces overwriting tables in existing database.');
  }

  @override
  void run() async {
    super.run();
    await initCommand(dbPath, argResults?.flag('force') ?? false);
  }
}

class MigrateCommand extends BaseCommand {
  @override
  final name = 'migrate';
  @override
  final description = "Updates the database via applying migrations.";

  MigrateCommand() {
    argParser.addFlag('one', help: 'Perform only one migration at a time.');
  }

  @override
  void run() async {
    super.run();
    await migrateCommand(dbPath, argResults?.flag('one') ?? false);
  }
}
