import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalk_x11.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final dateFormatter = DateFormat('yyyy-MM-dd hh:mm:ss').format;

final Stdout sink = stderr;

void initLoggers(Level level, bool brief) {
  Chalk.ansiColorLevelForNewInstances = sink.hasTerminal ? 3 : 0;
  Logger.root
    ..level = level
    ..onRecord.listen((record) {
      final message = brief
          ? '[${record.loggerName}] ${record.message}'
          : '[${dateFormatter(record.time)}] [${record.level}] [${record.loggerName}] ${record.message}';
      switch (record.level) {
        case >= Level.SEVERE:
          sink.writeln(chalk.bold.brightRed(message));
        case Level.WARNING:
          sink.writeln(chalk.bold.yellow(message));
        case Level.INFO:
          sink.writeln(chalk.blue(message));
        case < Level.INFO:
          sink.writeln(chalk.darkGray(message));
      }
    });
}
