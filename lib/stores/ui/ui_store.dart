
import 'package:mobx/mobx.dart';

part 'ui_store.g.dart';

class UiStore = _UiStore with _$UiStore;

abstract class _UiStore with Store {
  _UiStore();

  @observable
  bool showDrawer = true;

  @action
  void setShowDrawer(bool value) {
    showDrawer = value;
  }
}
