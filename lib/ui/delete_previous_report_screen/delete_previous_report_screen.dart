import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/local/constants/report_type.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/ui/preview_report_screen/preview_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class DeletePreviousReportScreen extends StatefulWidget {
  const DeletePreviousReportScreen({super.key});

  @override
  _DeletePreviousReportScreenState createState() =>
      _DeletePreviousReportScreenState();
}

class _DeletePreviousReportScreenState
    extends State<DeletePreviousReportScreen> {
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
    _reportStore = context.read();
    await _reportStore.getReports();
    final now = Jiffy(DateTime.now());
    final reportIds = _reportStore.reports!
        .where((e) =>
            e.entryDate == null ||
            Jiffy(now)
                    .startOf(Units.DAY)
                    .diff(Jiffy(e.entryDate).startOf(Units.DAY), Units.DAY) >
                AppConstants.autoDeleteReportAfterDays)
        .map((e) => e.id!)
        .toList();
    if (reportIds.isNotEmpty) {
      final result = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('起動時自動削除確認'),
                contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${AppConstants.autoDeleteReportAfterDays}日以上前のデータを削除します。よろしいですか？'),
                    CheckboxListTile(
                      value: false,
                      onChanged: (value) {},
                      title: Text('今日は自動削除確認を表示しない'),
                      controlAffinity: ListTileControlAffinity.leading,
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text("はい"),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  TextButton(
                    child: const Text("キャンセル"),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ));
      if (result == true) {
        await _reportStore.deleteReports(reportIds);
      }
    }
    Navigator.pushReplacementNamed(context, Routes.listReport);
  }
}
