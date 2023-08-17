import 'package:flutter/material.dart';

Future<bool> showLeaveCreateReportDialog(BuildContext context) async {
  return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("未登録終了確認"),
                content: const Text("入力内容を保存せずに戻ります。よろしいですか？"),
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
              )) ??
      false;
}
