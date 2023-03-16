import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';

class ReportSectionMixin {
  Widget lineLayout({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cloned = [...children];
        final isMobile = constraints.maxWidth < 640;
        if (isMobile) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cloned,
          );
        } else {
          final List<Widget> widgets = [];
          final last = cloned.removeLast();
          for (final child in cloned) {
            widgets.add(Expanded(child: child));
            widgets.add(Expanded(
              flex: 0,
              child: Container(width: 16),
            ));
          }
          widgets.add(Expanded(child: last));
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
        }
      },
    );
  }

  Widget optional({required Widget child, required BuildContext context}) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(
          left: -16,
          right: -16,
          top: -5,
          bottom: 0,
          child: Container(color: optionalColor(context))),
      child,
    ]);
  }

  Color optionalColor(BuildContext context) {
    return Theme.of(context).secondaryHeaderColor;
  }

  Widget linePadding() {
    return Expanded(
      flex: 0,
      child: Container(
        height: 16,
      ),
    );
  }

  String? formatBool(value) {
    return value != null ? (value! ? 'yes'.i18n() : 'no'.i18n()) : null;
  }

  void syncControllerValue(TextEditingController controller, dynamic value) {
    final newValue = value != null ? value.toString() : '';
    if (newValue != controller.text) {
      controller.text = newValue;
    }
  }

  TextInputFormatter maxLineFormatter(int line) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      int newLines = newValue.text.split('\n').length;
      if (newLines > line) {
        return oldValue;
      } else {
        return newValue;
      }
    });
  }

  String yearToWareki(int year, int month, int day) {
    DateTime date = DateTime(year, month, day);

    for (final era in AppConstants.eras) {
      if (era.start != null && era.start!.isAfter(date)) continue;
      if (era.end != null && era.end!.isBefore(date)) continue;
      return '${era.name} ${date.year - era.start!.year + 1}';
    }

    return "エラー";
  }
}
