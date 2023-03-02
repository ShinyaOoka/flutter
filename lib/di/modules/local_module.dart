import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ak_azm_flutter/data/local/constants/db_constants.dart';
import 'package:ak_azm_flutter/data/local/constants/seed_data.dart';
import 'package:ak_azm_flutter/data/local/db_migrations/db_migrations.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalModule {
  static Future<Database> provideDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, DBConstants.dbName);
    final database = openDatabase(dbPath,
        onCreate: _onCreate, onUpgrade: _onUpgrade, version: 1);
    return database;
  }

  static Future _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final i in Iterable.generate(version)) {
      DBMigrations.upgrades[i](batch);
    }
    SeedData.seedClassifications(batch);
    SeedData.seedFireStations(batch);
    SeedData.seedHospitals(batch);
    SeedData.seedTeams(batch);
    await batch.commit();
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    for (var i = oldVersion; i < newVersion; i++) {
      DBMigrations.upgrades[i](batch);
    }
    await batch.commit();
  }
}
