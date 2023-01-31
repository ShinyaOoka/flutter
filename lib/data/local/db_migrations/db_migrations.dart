import 'package:ak_azm_flutter/data/local/db_migrations/versions/version_1.dart';

class DBMigrations {
  DBMigrations._();

  static const upgrades = [upgradeVersion1];

  static const downgrades = [downgradeVersion1];
}
