// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UiStore on _UiStore, Store {
  late final _$showDrawerAtom =
      Atom(name: '_UiStore.showDrawer', context: context);

  @override
  bool get showDrawer {
    _$showDrawerAtom.reportRead();
    return super.showDrawer;
  }

  @override
  set showDrawer(bool value) {
    _$showDrawerAtom.reportWrite(value, super.showDrawer, () {
      super.showDrawer = value;
    });
  }

  late final _$_UiStoreActionController =
      ActionController(name: '_UiStore', context: context);

  @override
  void setShowDrawer(bool value) {
    final _$actionInfo =
        _$_UiStoreActionController.startAction(name: '_UiStore.setShowDrawer');
    try {
      return super.setShowDrawer(value);
    } finally {
      _$_UiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showDrawer: ${showDrawer}
    ''';
  }
}
