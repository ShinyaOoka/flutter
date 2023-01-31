import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:sqflite/sqflite.dart';

class HospitalDataSource {
  final Database _db;

  HospitalDataSource(this._db);

  Future<List<Hospital>> getHospitals() async {
    final List<Map<String, dynamic>> hospitalMaps =
        await _db.query(DBConstants.hospitalTable);

    return hospitalMaps
        .map((hospitalMap) => Hospital.fromJson(hospitalMap))
        .toList();
  }
}
