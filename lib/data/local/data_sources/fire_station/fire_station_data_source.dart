import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/fire_station/fire_station.dart';
import 'package:sqflite/sqflite.dart';

class FireStationDataSource {
  final Database _db;

  FireStationDataSource(this._db);

  Future<List<FireStation>> getAllFireStations() async {
    final result = await _db.query(DBConstants.fireStationTable);
    return result.map((e) => FireStation.fromJson(e)).toList();
  }

  Future<List<FireStation>> getFireStationsByIds(List<String> ids) async {
    final result = await _db.query(DBConstants.fireStationTable,
        where: 'FireStationCD IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids);
    return result.map((e) => FireStation.fromJson(e)).toList();
  }
}
