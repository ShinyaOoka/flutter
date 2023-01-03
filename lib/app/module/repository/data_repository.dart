import 'package:ak_azm_flutter/app/module/common/navigator_screen.dart';

import '../../di/injection.dart';
import '../local_storage/shared_pref_manager.dart';

class DataRepository {
  final UserSharePref userSharePref;
  final NavigationService _navigationService = getIt<NavigationService>();

  DataRepository(
    this.userSharePref,
  );
}
