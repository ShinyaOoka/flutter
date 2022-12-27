import 'dart:async';

import 'package:ak_azm_flutter/app/view/widget_utils/bottom_sheet/bottom_sheet_utils.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/default_loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import 'preview_report_viewmodel.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreviewReportPage extends PageProvideNode<PreviewReportViewModel> {
  PreviewReportPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return PreviewReportContent(viewModel);
  }
}

class PreviewReportContent extends StatefulWidget {
  final PreviewReportViewModel _previewReportViewModel;

  PreviewReportContent(this._previewReportViewModel);

  @override
  PreviewReportState createState() => PreviewReportState();
}

class PreviewReportState extends LifecycleState<PreviewReportContent>
    with SingleTickerProviderStateMixin {
  PreviewReportViewModel get previewReportViewModel => widget._previewReportViewModel;
  TapDownDetails? _doubleTapDetails;
  late AnimationController _animationController;
  final pdf = pw.Document();


  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  final Completer<PDFViewController> _controller = Completer<PDFViewController>();




  @override
  void initState()  {
    previewReportViewModel.initData();
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );
   // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  void dispose() {
    super.dispose();
    previewReportViewModel.serverFC.dispose();
    previewReportViewModel.portFC.dispose();
    _animationController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => previewReportViewModel.back(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              LocaleKeys.report_confirmation.tr(),
              // style: Theme.of(context).appBarTheme.titleTextStyle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: TextButton(
              child: Text(LocaleKeys.back_report.tr(),
                  // style: Theme.of(context).appBarTheme.titleTextStyle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
              onPressed: () => previewReportViewModel.back(),
            ),
            actions: [
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      LocaleKeys.edit.tr(),
                      style:
                      TextStyle( fontWeight: FontWeight.normal),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      LocaleKeys.PDF_transmission_printing.tr(),
                      style:
                      TextStyle( fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
                onSelected: (value) => {
                    if(value == 1){
                      previewReportViewModel.openEditReport()
                    } else {
                      previewReportViewModel.openSendReport()
                    }
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
          title: LocaleKeys.server_config.tr(),
          hideBackButton: false,
          body: Consumer<PreviewReportViewModel>(
              builder: (context, value, child) {
                return value.generatedPdfFilePath.isEmpty ? const BuildProgressLoading(): PDFView(
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

