import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ReportSectionMixin {
  Widget lineLayout({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 640;
        if (isMobile) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        } else {
          final List<Widget> widgets = [];
          final last = children.removeLast();
          for (final child in children) {
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
          child: Container(
            color: Theme.of(context).secondaryHeaderColor,
          )),
      child,
    ]);
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
}
