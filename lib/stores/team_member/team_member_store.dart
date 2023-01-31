import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/team_member/team_member.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'team_member_store.g.dart';

class TeamMemberStore = _TeamMemberStore with _$TeamMemberStore;

abstract class _TeamMemberStore with Store {
  late final Repository _repository;

  _TeamMemberStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableMap<String, TeamMember> teamMembers = ObservableMap();

  @action
  Future<List<TeamMember>> getAllTeamMembers() async {
    try {
      final result = await _repository.getAllTeamMembers();
      for (var element in result) {
        teamMembers[element.teamMemberCd!] = element;
      }
      return result;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<List<TeamMember>> getTeamMembersByIds(List<String> ids) async {
    try {
      ids.removeWhere((id) => teamMembers.containsKey(id));
      final result = await _repository.getTeamMembersByIds(ids);
      for (var element in result) {
        teamMembers[element.teamMemberCd!] = element;
      }
      return ids.map((e) => teamMembers[e]!).toList();
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<TeamMember> getTeamMemberById(String id) async {
    final result = await getTeamMembersByIds([id]);
    return result[0];
  }
}
