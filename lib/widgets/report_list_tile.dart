import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReportListTile extends StatelessWidget {
  final Report report;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap?.call();
      },
      dense: true,
      tileColor: const Color(0xFFF5F5F5),
      title: _buildListTileTitle(context),
      subtitle: _buildListTileSubtitle(context),
    );
  }

  const ReportListTile({
    super.key,
    required this.report,
    this.onTap,
  });

  Widget _buildListTileTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
              TextSpan(
                  text: '発生日時：',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                style: const TextStyle(fontWeight: FontWeight.bold),
                text:
                    '${report.dateOfOccurrence != null ? AppConstants.dateFormat.format(report.dateOfOccurrence!) : '----/--/--'} ${report.timeOfOccurrence?.format(context) ?? '--:--'}',
              ),
            ])),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${'list_report_team_name'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: report.team?.name ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ],
    );
  }

  Widget _buildListTileSubtitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${'type_of_accident'.i18n()} : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: report.accidentType?.value ?? 'なし',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '作成日 : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: report.entryDate != null
                      ? AppConstants.dateTimeHmFormat.format(report.entryDate!)
                      : '----/--/-- --:--',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${'accident_summary'.i18n()} : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: report.accidentSummary ?? 'なし',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '更新日 : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: report.updateDate != null
                      ? AppConstants.dateTimeHmFormat.format(report.updateDate!)
                      : '----/--/-- --:--',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
          ],
        )
      ],
    );
  }
}
