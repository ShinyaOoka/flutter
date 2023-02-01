import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:sqflite/sqflite.dart';

class ReportDataSource {
  final Database _db;

  ReportDataSource(this._db);

  Future<List<Report>> getReports() async {
    final List<Map<String, dynamic>> reportMaps =
        await _db.query(DBConstants.reportTable, orderBy: "ID DESC");

    return reportMaps.map((reportMap) => Report.fromJson(reportMap)).toList();
  }

  Future createReport(Report report) async {
    await _db.insert(DBConstants.reportTable, report.toJson());
  }
}
