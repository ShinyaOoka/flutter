import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:sqflite/sqflite.dart';

class TeamDataSource {
  final Database _db;

  TeamDataSource(this._db);

  Future<List<Team>> getAllTeams() async {
    final result = await _db.query(DBConstants.teamTable);
    return result.map((e) => Team.fromJson(e)).toList();
  }

  Future<List<Team>> getTeamsByIds(List<String> ids) async {
    final result = await _db.query(DBConstants.teamTable,
        where: 'TeamCD IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids);
    return result.map((e) => Team.fromJson(e)).toList();
  }
}
