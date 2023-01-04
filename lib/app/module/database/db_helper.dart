import 'dart:async';
import 'dart:io';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/module/database/column_name.dart';
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String dbName = 'ak_azm.db';
  static const int dbVersion = 3;

  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DBHelper.internal();

  /// Initialize DB
  Future<Database?> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    var theDb = await openDatabase(path, version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }



  /// Creates All Table
  Future _onCreate(Database db, int version) async {
    // When creating the db, create the table
    Batch? batch = db.batch();
    batch.execute(CREATE_TABLE_DTReport);
    batch.execute(CREATE_TABLE_MSTeamMember);
    batch.execute(CREATE_TABLE_MSTeam);
    batch.execute(CREATE_TABLE_MSFireStation);
    batch.execute(CREATE_TABLE_MSHospital);
    batch.execute(CREATE_TABLE_MSClassification);
    batch.execute(CREATE_TABLE_MSMessage);
    List<dynamic>? res = await batch.commit();
    print('onCreate Database: version $version ====================================\n');
    return res;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print('onUpgrade Database: oldversion $oldversion - newversion $newversion ====================================\n');
    if (oldversion < newversion) {
      // you can execute drop table and create table
      Batch? batch = db.batch();
      batch.execute(DROP_TABLE_DTReport);
      batch.execute(CREATE_TABLE_DTReport);
      batch.execute(DROP_TABLE_MSClassification);
      batch.execute(CREATE_TABLE_MSClassification);
      batch.execute(DROP_TABLE_MSMessage);
      batch.execute(CREATE_TABLE_MSMessage);
      List<dynamic>? res = await batch.commit();
      return res;
    }
  }



  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await DBHelper().db;
    var res =
    await dbClient?.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table' 
         AND name != 'android_metadata' 
         AND name != 'sqlite_sequence';""");
    print('Table count: ${res?[0]['count']}');
    return res?[0]['count'];
  }

  Future<List<DTReport>?> getAllReport() async {
    var dbClient = await DBHelper().db;
    List<Map<String, Object?>>? datas = await dbClient?.query(tableDTReport);
    return datas?.map((e) => DTReport.fromJson(e)).toList();
  }

  Future<int?> insertReport(Map<String, dynamic> row) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.insert(tableDTReport, row);
  }

  /// Get all
  Future<List<Map<String, Object?>>?> getAllData(String tableName) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.query(tableName);
  }

  //Get data where
  Future<List<Map<String, Object?>>?> getDatas(String tableName, List<String> columns, String where,
      List<Object> whereArgs) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.query(tableName, columns: columns, where: '$where > ?', whereArgs: whereArgs);
  }

  Future update(String tableName, String where, List<Object> whereArgs,
      dynamic newData) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.update(tableName, newData,
        where: '$where = ?', whereArgs: whereArgs);
  }

  Future delete(String tableName, String column, int columnValue) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.delete(tableName, where: '$column = ?', whereArgs: [columnValue]);
  }

  Future<int?> deleteTable(String tableName) async {
    var dbClient = await DBHelper().db;
    return await dbClient?.delete(tableName);
  }

  Future putDataToDTReportDb(String table, List<dynamic> datas) async {
    var dbClient = await DBHelper().db;
    // Initialize batch
    final batch = dbClient?.batch();
    for (var i in datas) {
      batch?.insert(table, i.toJson());
    }
    // Commit
    await batch?.commit(noResult: true);
    return "success";
  }

  Future putDataToDB(String table, List<dynamic> datas, {bool firstWrite = true}) async {
    var dbClient = await DBHelper().db;
    // Initialize batch
    final batch = dbClient?.batch();
    // Batch insert
    bool isData = await hasData(table);
    if(!isData){
      for (var i in datas) {
        batch?.insert(table, i.toJson());
      }
    }
    // Commit
    await batch?.commit(noResult: true);
    return "success";
  }

  Future<bool> hasData(String table) async {
    var dbClient = await DBHelper().db;
    List<Map<String, Object?>>? data = await dbClient?.query(table);
    bool hasData = data != null && data.isNotEmpty;
    print('$table hasData: $hasData');
    return hasData;
  }

  //Transaction
  Future transaction() async {
    var dbClient = await DBHelper().db;
    await dbClient?.transaction((trans) async {
      /*await trans.execute("DELETE FROM User");*/
    });
  }
}
