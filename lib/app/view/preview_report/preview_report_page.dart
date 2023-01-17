import 'dart:async';

import 'package:ak_azm_flutter/app/model/dt_report.dart';
import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/custom/default_loading_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import 'preview_report_viewmodel.dart';

class PreviewReportPage extends PageProvideNode<PreviewReportViewModel> {
  PreviewReportPage({Key? key, String assetFile = '', String pdfName = '', DTReport? dtReport})
      : super(key: key, params: [assetFile, pdfName, dtReport]);

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
  PreviewReportViewModel get previewReportViewModel => widget._previewReportViewModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PreviewReportContent oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void onResume() {
    init();
    super.onResume();
  }

  void init(){
    previewReportViewModel.initData();
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
                  fontSize: text_16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: TextButton(
                child: Text(LocaleKeys.back_report.tr(),
                    // style: Theme.of(context).appBarTheme.titleTextStyle,
                    style: TextStyle(
                      fontSize: text_16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => previewReportViewModel.back(),
              ),
              automaticallyImplyLeading: false,
            ),
            transparentStatusBar: 0.0,
            title: '',
            hideBackButton: false,
            body: Column(
              children: [
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
                Expanded(
                  child: Consumer<PreviewReportViewModel>(
                      builder: (context, value, child) {
                    return value.generatedPdfFilePath.isEmpty
                        ? const BuildProgressLoading()
                        : PdfView(
                      controller: PdfController(
                        document: PdfDocument.openFile(previewReportViewModel.generatedPdfFilePath),
                      ),
                      renderer: (PdfPage page) => page.render(
                        width: page.width * 2,
                        height: page.height * 2,
                        format: PdfPageImageFormat.webp,
                        backgroundColor: strColorWhite,
                      ),
                    );
                  }),
                ),

              ],
            )));
  }
}
