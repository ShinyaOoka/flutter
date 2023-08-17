import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/downloaded_case/downloaded_case.dart';
import 'package:sqflite/sqflite.dart';

class DownloadedCaseDataSource {
  final Database _db;

  DownloadedCaseDataSource(this._db);

  Future<List<DownloadedCase>> getAllDownloadedCases() async {
    final result = await _db.query(DBConstants.downloadedCaseTable);
    return result.map((e) => DownloadedCase.fromJson(e)).toList();
  }

  Future createDownloadedCase(DownloadedCase myCase) async {
    await _db.insert(DBConstants.downloadedCaseTable, myCase.toJson());
  }

  Future deleteDownloadedCase(List<int> ids) async {
    await _db.delete(DBConstants.downloadedCaseTable,
        where: "ID IN (${List.filled(ids.length, '?').join(',')})",
        whereArgs: ids);
  }
}
