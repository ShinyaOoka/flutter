import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/fire_station/fire_station.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'fire_station_store.g.dart';

class FireStationStore = _FireStationStore with _$FireStationStore;

abstract class _FireStationStore with Store {
  late final Repository _repository;

  _FireStationStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableMap<String, FireStation> fireStations = ObservableMap();

  @action
  Future<List<FireStation>> getAllFireStations() async {
    try {
      final result = await _repository.getAllFireStations();
      for (var element in result) {
        fireStations[element.fireStationCd!] = element;
      }
      return result;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<List<FireStation>> getFireStationsByIds(List<String> ids) async {
    try {
      ids.removeWhere((id) => fireStations.containsKey(id));
      final result = await _repository.getFireStationsByIds(ids);
      for (var element in result) {
        fireStations[element.fireStationCd!] = element;
      }
      return ids.map((e) => fireStations[e]!).toList();
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<FireStation> getFireStationById(String id) async {
    final result = await getFireStationsByIds([id]);
    return result[0];
  }
}
