// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeamMemberStore on _TeamMemberStore, Store {
  late final _$teamMembersAtom =
      Atom(name: '_TeamMemberStore.teamMembers', context: context);

  @override
  ObservableMap<String, TeamMember> get teamMembers {
    _$teamMembersAtom.reportRead();
    return super.teamMembers;
  }

  @override
  set teamMembers(ObservableMap<String, TeamMember> value) {
    _$teamMembersAtom.reportWrite(value, super.teamMembers, () {
      super.teamMembers = value;
    });
  }

  late final _$getAllTeamMembersAsyncAction =
      AsyncAction('_TeamMemberStore.getAllTeamMembers', context: context);

  @override
  Future<List<TeamMember>> getAllTeamMembers() {
    return _$getAllTeamMembersAsyncAction.run(() => super.getAllTeamMembers());
  }

  late final _$getTeamMembersByIdsAsyncAction =
      AsyncAction('_TeamMemberStore.getTeamMembersByIds', context: context);

  @override
  Future<List<TeamMember>> getTeamMembersByIds(List<String> ids) {
    return _$getTeamMembersByIdsAsyncAction
        .run(() => super.getTeamMembersByIds(ids));
  }

  late final _$getTeamMemberByIdAsyncAction =
      AsyncAction('_TeamMemberStore.getTeamMemberById', context: context);

  @override
  Future<TeamMember> getTeamMemberById(String id) {
    return _$getTeamMemberByIdAsyncAction
        .run(() => super.getTeamMemberById(id));
  }

  @override
  String toString() {
    return '''
teamMembers: ${teamMembers}
    ''';
  }
}
