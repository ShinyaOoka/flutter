import 'package:ak_azm_flutter/data/local/data_sources/fire_station/fire_station_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/hospital/hospital_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/report/report_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/team/team_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/team_member/team_member_data_source.dart';
import 'package:ak_azm_flutter/data/local/data_sources/classification/classification_data_source.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/models/fire_station/fire_station.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:ak_azm_flutter/models/team_member/team_member.dart';
import 'package:tuple/tuple.dart';

class Repository {
  final ReportDataSource _reportDataSource;
  final HospitalDataSource _hospitalDataSource;
  final TeamDataSource _teamDataSource;
  final TeamMemberDataSource _teamMemberDataSource;
  final FireStationDataSource _fireStationDataSource;
  final ClassificationDataSource _classificationDataSource;

  Repository(
    this._hospitalDataSource,
    this._reportDataSource,
    this._teamDataSource,
    this._teamMemberDataSource,
    this._fireStationDataSource,
    this._classificationDataSource,
  );

  Future<List<Report>> getReports() {
    return _reportDataSource.getReports();
  }

  Future<void> createReport(Report report) {
    return _reportDataSource.createReport(report);
  }

  Future<void> editReport(Report report) {
    return _reportDataSource.editReport(report);
  }

  Future<List<Hospital>> getHospitals() {
    return _hospitalDataSource.getHospitals();
  }

  Future<List<Team>> getAllTeams() {
    return _teamDataSource.getAllTeams();
  }

  Future<List<Team>> getTeamsByIds(List<String> ids) {
    return _teamDataSource.getTeamsByIds(ids);
  }

  Future<List<TeamMember>> getAllTeamMembers() {
    return _teamMemberDataSource.getAllTeamMembers();
  }

  Future<List<TeamMember>> getTeamMembersByIds(List<String> ids) {
    return _teamMemberDataSource.getTeamMembersByIds(ids);
  }

  Future<List<FireStation>> getAllFireStations() {
    return _fireStationDataSource.getAllFireStations();
  }

  Future<List<FireStation>> getFireStationsByIds(List<String> ids) {
    return _fireStationDataSource.getFireStationsByIds(ids);
  }

  Future<List<Classification>> getAllClassifications() {
    return _classificationDataSource.getAllClassifications();
  }

  Future<List<Classification>> getClassificationsByIds(
      List<Tuple2<String, String>> ids) {
    return _classificationDataSource.getClassificationsByIds(ids);
  }
}
