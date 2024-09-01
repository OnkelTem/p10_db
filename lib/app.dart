import 'package:logging/logging.dart';
import 'package:p10_db/db.dart';

final log = Logger('app');

void app(Db db) {
  final selectUserPreferences = db.prepare("SELECT color FROM ${Tables.preferences.name} WHERE user_id = ?");

  for (final rowUser in db.select("SELECT id, name FROM ${Tables.user.name}")) {
    if (rowUser case {'id': final int id, 'name': final String? name}) {
      print('user: id=$id name=$name');
      for (final rowPref in selectUserPreferences.select([id])) {
        if (rowPref case {'color': final String? color}) {
          print('\tpreferences: color=$color');
        }
      }
    }
  }
}
