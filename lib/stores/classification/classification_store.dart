import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/classification/classification.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';
import 'package:tuple/tuple.dart';

part 'classification_store.g.dart';

class ClassificationStore = _ClassificationStore with _$ClassificationStore;

abstract class _ClassificationStore with Store {
  late final Repository _repository;

  _ClassificationStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableMap<Tuple2<String, String>, Classification> classifications =
      ObservableMap();

  @action
  Future<List<Classification>> getAllClassifications() async {
    try {
      final result = await _repository.getAllClassifications();
      for (var element in result) {
        classifications[Tuple2(
            element.classificationCd!, element.classificationSubCd!)] = element;
      }
      return result;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<List<Classification>> getClassificationsByIds(
      List<Tuple2<String, String>> ids) async {
    try {
      ids.removeWhere((id) => classifications.containsKey(id));
      final result = await _repository.getClassificationsByIds(ids);
      for (var element in result) {
        classifications[Tuple2(
            element.classificationCd!, element.classificationSubCd!)] = element;
      }
      return ids.map((e) => classifications[e]!).toList();
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<Classification> getClassificationById(
      Tuple2<String, String> id) async {
    final result = await getClassificationsByIds([id]);
    return result[0];
  }
}
