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

  static ObservableFuture<List<Hospital>?> emptyHospitalResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<List<Hospital>?> fetchHospitalsFuture =
      ObservableFuture<List<Hospital>?>(emptyHospitalResponse);

  @observable
  ObservableList<Hospital>? hospitals;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchHospitalsFuture.status == FutureStatus.pending;

  @action
  Future getHospitals() async {
    final future = _repository.getHospitals();
    fetchHospitalsFuture = ObservableFuture(future);

    future.then((hospitalList) {
      hospitals = ObservableList.of(hospitalList);
    }).catchError((error) {
      errorStore.errorMessage = error.toString();
    });
  }
}
