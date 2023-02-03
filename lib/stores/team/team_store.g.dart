// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamStore on _TeamStore, Store {
  late final _$teamsAtom = Atom(name: '_TeamStore.teams', context: context);

  @override
  ObservableMap<String, Team> get teams {
    _$teamsAtom.reportRead();
    return super.teams;
  }

  @override
  set teams(ObservableMap<String, Team> value) {
    _$teamsAtom.reportWrite(value, super.teams, () {
      super.teams = value;
    });
  }

  late final _$getTeamsAsyncAction =
      AsyncAction('_TeamStore.getTeams', context: context);

  @override
  Future<List<Team>> getTeams() {
    return _$getTeamsAsyncAction.run(() => super.getTeams());
  }

  late final _$getTeamsByIdsAsyncAction =
      AsyncAction('_TeamStore.getTeamsByIds', context: context);

  @override
  Future<List<Team>> getTeamsByIds(List<String> ids) {
    return _$getTeamsByIdsAsyncAction.run(() => super.getTeamsByIds(ids));
  }

  late final _$getTeamByIdAsyncAction =
      AsyncAction('_TeamStore.getTeamById', context: context);

  @override
  Future<Team> getTeamById(String id) {
    return _$getTeamByIdAsyncAction.run(() => super.getTeamById(id));
  }

  @override
  String toString() {
    return '''
teams: ${teams}
    ''';
  }
}
