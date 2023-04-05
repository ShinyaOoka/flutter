import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeletePreviousReportDialog extends StatefulWidget {
  const DeletePreviousReportDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeletePreviousReportDialog> createState() =>
      _DeletePreviousReportDialogState();
}

class _DeletePreviousReportDialogState
    extends State<DeletePreviousReportDialog> {
  bool doNotShowAgain = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('起動時自動削除確認'),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              '${AppConstants.autoDeleteReportAfterDays}日以上前のデータを削除します。よろしいですか？'),
          CheckboxListTile(
            value: doNotShowAgain,
            onChanged: (value) {
              setState(() {
                doNotShowAgain = true;
              });
            },
            title: Text('今日は自動削除確認を表示しない'),
            controlAffinity: ListTileControlAffinity.leading,
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text("はい"),
          onPressed: () async {
            if (doNotShowAgain) {
              final prefs = await SharedPreferences.getInstance();
              prefs.setInt(AppConstants.doNotShowDeleteDialogAgainDate,
                  Jiffy(DateTime.now()).startOf(Units.DAY).unix());
            }
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () async {
            if (doNotShowAgain) {
              final prefs = await SharedPreferences.getInstance();
              prefs.setInt(AppConstants.doNotShowDeleteDialogAgainDate,
                  Jiffy(DateTime.now()).startOf(Units.DAY).unix());
            }
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}
