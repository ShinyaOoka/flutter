import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/team_member/team_member.dart';
import 'package:sqflite/sqflite.dart';

class TeamMemberDataSource {
  final Database _db;

  TeamMemberDataSource(this._db);

  Future<List<TeamMember>> getAllTeamMembers() async {
    final result = await _db.query(DBConstants.teamMemberTable);
    return result.map((e) => TeamMember.fromJson(e)).toList();
  }

  Future<List<TeamMember>> getTeamMembersByIds(List<String> ids) async {
    final result = await _db.query(DBConstants.teamMemberTable,
        where: 'TeamMemberCD IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids);
    return result.map((e) => TeamMember.fromJson(e)).toList();
  }
}
