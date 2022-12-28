import 'package:ak_azm_flutter/app/module/common/config.dart';
import 'package:ak_azm_flutter/app/module/common/toast_util.dart';
import 'package:ak_azm_flutter/app/view/widget_utils/buttons/filled_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import '../widget_utils/expansion_panel_custom.dart';
import '../widget_utils/outline_text_form_field.dart';
import 'send_report_viewmodel.dart';

class SendReportPage extends PageProvideNode<SendReportViewModel> {
  SendReportPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return SendReportContent(viewModel);
  }
}

class SendReportContent extends StatefulWidget {
  final SendReportViewModel _sendReportViewModel;

  SendReportContent(this._sendReportViewModel);

  @override
  SendReportState createState() => SendReportState();
}

class SendReportState extends LifecycleState<SendReportContent>
    with SingleTickerProviderStateMixin {
  SendReportViewModel get sendReportViewModel => widget._sendReportViewModel;
  late AnimationController _animationController;

  @override
  void initState() {
    sendReportViewModel.initData();
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
    sendReportViewModel.serverFC.dispose();
    sendReportViewModel.portFC.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () => sendReportViewModel.back(),
          child: BaseScaffoldSafeArea(
            customAppBar: AppBar(
              backgroundColor: kColor4472C4,
              centerTitle: true,
              title: Text(
                LocaleKeys.report_PDF_sending_printing.tr(),
                // style: Theme.of(context).appBarTheme.titleTextStyle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: TextButton(
                child: Text(LocaleKeys.list.tr(),
                    // style: Theme.of(context).appBarTheme.titleTextStyle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => sendReportViewModel.openListReport(),
              ),
              /*actions: [
                TextButton(
                  child: Text('List',
                      // style: Theme.of(context).appBarTheme.titleTextStyle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      )),
                  onPressed: () => sendReportViewModel.openListReport(),
                ),
              ],*/
              automaticallyImplyLeading: false,
            ),
            transparentStatusBar: 0.0,
            title: LocaleKeys.server_config.tr(),
            hideBackButton: false,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: size_20_w,),
                        Padding(
                          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: FilledButton(
                            borderRadius: size_4_r,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                            color: kColor4472C4,
                            text: LocaleKeys.injured_person_transport_certificate.tr(),
                            onPress: () => sendReportViewModel.openPreviewReport(assetInjuredPersonTransportCertificate, pdfName: '傷病者輸送証'),
                          ),
                        ),
                        SizedBox(height: size_20_w,),
                        Padding(
                          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                          child: FilledButton(
                            borderRadius: size_4_r,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                            color: kColor4472C4,
                            text: LocaleKeys.ambulance_service_implementation_report.tr(),
                            onPress: () => sendReportViewModel.openPreviewReport(assetInjuredPersonTransportCertificate, pdfName: '傷病者輸送証'),
                          ),
                        ),

                        //More view
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
  }


}

