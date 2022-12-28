import 'dart:async';

import 'package:ak_azm_flutter/app/view/widget_utils/custom/default_loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import 'preview_report_viewmodel.dart';

class PreviewReportPage extends PageProvideNode<PreviewReportViewModel> {
  PreviewReportPage({Key? key, String assetFile = '', String pdfName = ''})
      : super(key: key, params: [assetFile, pdfName]);

  @override
  Widget buildContent(BuildContext context) {
    return PreviewReportContent(
      viewModel,
      key: key,
    );
  }
}

class PreviewReportContent extends StatefulWidget {
  final PreviewReportViewModel _previewReportViewModel;

  PreviewReportContent(this._previewReportViewModel, {Key? key})
      : super(key: key);

  @override
  PreviewReportState createState() => PreviewReportState();
}

class PreviewReportState extends LifecycleState<PreviewReportContent>
    with SingleTickerProviderStateMixin {
  PreviewReportViewModel get previewReportViewModel =>
      widget._previewReportViewModel;
  TapDownDetails? _doubleTapDetails;
  late AnimationController _animationController;
  final pdf = pw.Document();

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
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
                LocaleKeys.report_PDF_preview.tr(),
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
              automaticallyImplyLeading: false,
            ),
            transparentStatusBar: 0.0,
            title: LocaleKeys.server_config.tr(),
            hideBackButton: false,
            body: Stack(
              children: [
                Consumer<PreviewReportViewModel>(
                    builder: (context, value, child) {
                  return value.generatedPdfFilePath.isEmpty
                      ? const BuildProgressLoading()
                      : PDFView(
                          filePath: value.generatedPdfFilePath,
                          enableSwipe: true,
                          swipeHorizontal: true,
                          autoSpacing: true,
                          pageFling: false,
                          fitPolicy: FitPolicy.BOTH,
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
                Container(
                  height: kToolbarHeight,
                  color: Colors.black12,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: InkWell(
                          child: Ink(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kColor4472C4,
                                borderRadius: BorderRadius.circular(size_4_r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size_12_w, vertical: size_6_w),
                                child: Text(
                                  LocaleKeys.send.tr(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: text_12),
                                ),
                              ),
                            ),
                          ),
                          onTap: () => null,
                        ),
                      ),
                      Expanded(
                        child: previewReportViewModel.pdfName.isEmpty
                            ? Container()
                            : Center(
                                child: Text(
                                  previewReportViewModel.pdfName,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: text_16),
                                ),
                              ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          child: Ink(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kColor4472C4,
                                borderRadius: BorderRadius.circular(size_4_r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size_12_w, vertical: size_6_w),
                                child: Text(
                                  LocaleKeys.printing.tr(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: text_12),
                                ),
                              ),
                            ),
                          ),
                          onTap: () => null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
