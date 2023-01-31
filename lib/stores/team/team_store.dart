import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/team/team.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'team_store.g.dart';

class TeamStore = _TeamStore with _$TeamStore;

abstract class _TeamStore with Store {
  late final Repository _repository;

  _TeamStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableMap<String, Team> teams = ObservableMap();

  @action
  Future<List<Team>> getTeams() async {
    try {
      final result = await _repository.getAllTeams();
      for (var element in result) {
        teams[element.teamCd!] = element;
      }
      return result;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<List<Team>> getTeamsByIds(List<String> ids) async {
    try {
      ids.removeWhere((id) => teams.containsKey(id));
      final result = await _repository.getTeamsByIds(ids);
      for (var element in result) {
        teams[element.teamCd!] = element;
      }
      return ids.map((e) => teams[e]!).toList();
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<Team> getTeamById(String id) async {
    final result = await getTeamsByIds([id]);
    return result[0];
  }
}
