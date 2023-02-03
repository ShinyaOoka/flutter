// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClassificationStore on _ClassificationStore, Store {
  late final _$classificationsAtom =
      Atom(name: '_ClassificationStore.classifications', context: context);

  @override
  ObservableMap<Tuple2<String, String>, Classification> get classifications {
    _$classificationsAtom.reportRead();
    return super.classifications;
  }

  @override
  set classifications(
      ObservableMap<Tuple2<String, String>, Classification> value) {
    _$classificationsAtom.reportWrite(value, super.classifications, () {
      super.classifications = value;
    });
  }

  late final _$getAllClassificationsAsyncAction = AsyncAction(
      '_ClassificationStore.getAllClassifications',
      context: context);

  @override
  Future<List<Classification>> getAllClassifications() {
    return _$getAllClassificationsAsyncAction
        .run(() => super.getAllClassifications());
  }

  late final _$getClassificationsByIdsAsyncAction = AsyncAction(
      '_ClassificationStore.getClassificationsByIds',
      context: context);

  @override
  Future<List<Classification>> getClassificationsByIds(
      List<Tuple2<String, String>> ids) {
    return _$getClassificationsByIdsAsyncAction
        .run(() => super.getClassificationsByIds(ids));
  }

  late final _$getClassificationByIdAsyncAction = AsyncAction(
      '_ClassificationStore.getClassificationById',
      context: context);

  @override
  Future<Classification> getClassificationById(Tuple2<String, String> id) {
    return _$getClassificationByIdAsyncAction
        .run(() => super.getClassificationById(id));
  }

  @override
  String toString() {
    return '''
classifications: ${classifications}
    ''';
  }
}
