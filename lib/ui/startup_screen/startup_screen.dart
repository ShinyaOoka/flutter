import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/startup_screen/delete_previous_report_dialog.dart';
import 'package:ak_azm_flutter/utils/routes/app.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  late ReportStore _reportStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_showPopup);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _showPopup(_) async {
    final prefs = await SharedPreferences.getInstance();
    final now = Jiffy(DateTime.now());
    final lastDoNotShowAgainDate =
        prefs.getInt(AppConstants.doNotShowDeleteDialogAgainDate);
    if (lastDoNotShowAgainDate == now.clone().startOf(Units.DAY).unix() ||
        AppConstants.autoDeleteReportAfterDays == 0) {
      Navigator.pushReplacementNamed(context, ReportRoutes.reportListReport);
      return;
    }
    _reportStore = context.read();
    await _reportStore.getReports();
    final reportIds = _reportStore.reports!
        .where((e) =>
            e.entryDate == null ||
            Jiffy(now).diff(Jiffy(e.entryDate), Units.DAY) >=
                AppConstants.autoDeleteReportAfterDays)
        .map((e) => e.id!)
        .toList();
    if (reportIds.isNotEmpty) {
      final result = await showDialog(
          context: context,
          builder: (BuildContext context) =>
              const DeletePreviousReportDialog());
      if (result == true) {
        await _reportStore.deleteReports(reportIds);
      }
    }
    Navigator.pushReplacementNamed(context, ReportRoutes.reportListReport);
  }
}
