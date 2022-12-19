import 'dart:async';
import 'dart:io';

import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const dbName = "ak_azm.db";
  static const dbVersion = 1;

  //table DTReport
  final String tableDTReport = 'DTReport';


  //table MSTeam
  final String tableMSTeam = 'MSTeam';



  //table MSTeamMember
  final String tableMSTeamMember = 'MSTeamMember';


  //table MSFireStation
  final String tableMSFireStation = 'MSFireStation';


  //table MSHospital
  final String tableMSHospital = 'MSHospital';


  //table PRMessage
  final String tablePRMessage = 'PRMessage';


  //table MSClassification
  final String tableMSClassification = 'MSClassification';





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
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    var taskDb = await openDatabase(path, version: dbVersion);
    return taskDb;
  }

  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await db;
    var res =
        await dbClient?.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table' 
         AND name != 'android_metadata' 
         AND name != 'sqlite_sequence';""");
    print('Table count: ${res?[0]['count']}');
    return res?[0]['count'];
  }

  /// Creates All Table
  Future<List<dynamic>?> createAllTable() async {
    var dbClient = await DBHelper().db;
    Batch? batch = dbClient?.batch();
    batch?.execute("Your query-> Create table if not exists");
    batch?.execute("Your query->Create table if not exists");
    List<dynamic>? res = await batch?.commit();
    return res;
  }
}
