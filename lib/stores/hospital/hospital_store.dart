import 'package:mobx/mobx.dart';
import 'package:ak_azm_flutter/data/repository.dart';
import 'package:ak_azm_flutter/models/hospital/hospital.dart';
import 'package:ak_azm_flutter/stores/error/error_store.dart';

part 'hospital_store.g.dart';

class HospitalStore = _HospitalStore with _$HospitalStore;

abstract class _HospitalStore with Store {
  late final Repository _repository;

  _HospitalStore(Repository repository) : _repository = repository;

  final ErrorStore errorStore = ErrorStore();

  @observable
  ObservableMap<String, Hospital> hospitals = ObservableMap();

  @observable
  bool success = false;

  @action
  Future getHospitals() async {
    try {
      final result = await _repository.getHospitals();
      for (var element in result) {
        hospitals[element.hospitalCd!] = element;
      }
      return result;
    } catch (e) {
      errorStore.errorMessage = e.toString();
      rethrow;
    }
  }
}
