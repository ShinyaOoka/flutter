import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../model/ms_classification.dart';
import '../../module/res/style.dart';

class ItemReport extends StatelessWidget {
  DTReport report;
  List<MSClassification> msClassifications;
  VoidCallback onClickItem;
  VoidCallback onDeleteItem;

  ItemReport({
    Key? key,
    required this.report,
    required this.msClassifications,
    required this.onClickItem,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () => onClickItem.call(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: size_10_w, horizontal: size_10_w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${report.DateOfOccurrence ?? ''} ${report.TimeOfOccurrence ?? ''}',
                            textAlign: TextAlign.start,
                            style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: text_12, fontWeight: FontWeight.normal),
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            LocaleKeys.corps_name.tr(namedArgs: {'corps_name': report.TeamName ?? ''}),
                            textAlign: TextAlign.start,
                            style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: text_12, fontWeight: FontWeight.normal),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size_3_w,
                    ),
                    Text(
                      LocaleKeys.accident_type.tr(namedArgs: {'accident_type': finMSClassification()?.Value ?? ''}),
                      textAlign: TextAlign.start,
                      style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: text_12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: size_3_w,
                    ),
                    Text(
                      LocaleKeys.description.tr(namedArgs: {'description': report.AccidentSummary ?? ''}),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: text_12, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MSClassification? finMSClassification() {
    if (msClassifications.isEmpty) return null;
    return msClassifications.firstWhereOrNull((element) => report.TypeOfAccident == element.ClassificationSubCD && element.ClassificationCD == '002');
  }
}
