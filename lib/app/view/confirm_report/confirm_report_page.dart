import 'dart:async';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/default_loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import 'confirm_report_viewmodel.dart';

class ConfirmReportPage extends PageProvideNode<ConfirmReportViewModel> {
  ConfirmReportPage({Key? key, DTReport? dtReport})
      : super(key: key, params: [dtReport]);

  @override
  Widget buildContent(BuildContext context) {
    return ConfirmReportContent(viewModel);
  }
}

class ConfirmReportContent extends StatefulWidget {
  final ConfirmReportViewModel _confirmReportViewModel;

  ConfirmReportContent(this._confirmReportViewModel);

  @override
  ConfirmReportState createState() => ConfirmReportState();
}

class ConfirmReportState extends LifecycleState<ConfirmReportContent>
    with SingleTickerProviderStateMixin {
  ConfirmReportViewModel get confirmReportViewModel =>
      widget._confirmReportViewModel;
  late AnimationController _animationController;

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
    confirmReportViewModel.initData();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => confirmReportViewModel.back(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              LocaleKeys.report_confirmation.tr(),
              // style: Theme.of(context).appBarTheme.titleTextStyle,
              style: TextStyle(
                fontSize: text_16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: TextButton(
              child: Text(LocaleKeys.back_report.tr(),
                  style: TextStyle(
                    fontSize: text_16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
              onPressed: () => confirmReportViewModel.back(),
            ),
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      LocaleKeys.edit.tr(),
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      LocaleKeys.PDF_transmission_printing.tr(),
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
                onSelected: (value) => {
                  if (value == 1)
                    {confirmReportViewModel.openEditReport()}
                  else
                    {confirmReportViewModel.openSendReport(confirmReportViewModel.dtReport)}
                },
                offset: const Offset(0, 56),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              )
            ],
            automaticallyImplyLeading: false,
          ),
          transparentStatusBar: 0.0,
          title: '',
          hideBackButton: false,
          body: Consumer<ConfirmReportViewModel>(
              builder: (context, value, child) {
            return value.generatedPdfFilePath.isEmpty
                ? const BuildProgressLoading()
                : PDFView(
                    filePath: value.generatedPdfFilePath,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onRender: (_pages) {
                      setState(() {
                        pages = _pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                  );
          }),
        ));
  }
}
