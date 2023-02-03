import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

class ClassificationDataSource {
  final Database _db;

  ClassificationDataSource(this._db);

  Future<List<Classification>> getAllClassifications() async {
    final result = await _db.query(DBConstants.classificationTable);
    return result.map((e) => Classification.fromJson(e)).toList();
  }

  Future<List<Classification>> getClassificationsByIds(
      List<Tuple2<String, String>> ids) async {
    final result = await _db.query(DBConstants.classificationTable,
        where: List.filled(ids.length,
                '(ClassificationCD = ? AND ClassificationSubCD = ?)')
            .join('OR'),
        whereArgs: ids.expand((e) => [e.item1, e.item2]).toList());
    return result.map((e) => Classification.fromJson(e)).toList();
  }
}
