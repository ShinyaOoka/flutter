import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:ak_azm_flutter/widgets/twelve_lead_chart.dart';
import 'package:flutter/material.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class TwelveLeadChartScreenArguments {
  final Ecg12Lead twelveLead;

  TwelveLeadChartScreenArguments({required this.twelveLead});
}

class TwelveLeadChartScreen extends StatefulWidget {
  const TwelveLeadChartScreen({super.key});

  @override
  _TwelveLeadChartScreenState createState() => _TwelveLeadChartScreenState();
}

class _TwelveLeadChartScreenState extends State<TwelveLeadChartScreen>
    with RouteAware, ReportSectionMixin {
  Ecg12Lead? twelveLead;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    _routeObserver.unsubscribe(this);
  }

  @override
  Future<void> didPush() async {
    final args = ModalRoute.of(context)!.settings.arguments
        as TwelveLeadChartScreenArguments;
    setState(() {
      twelveLead = args.twelveLead;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: "12誘導表示",
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const SizedBox(
        width: 12,
        child: Icon(Icons.arrow_back_ios),
      ),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('back'.i18n()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        // _handleErrorMessage(),
        twelveLead != null
            ? _buildMainContent()
            : const CustomProgressIndicatorWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Name: ${twelveLead!.patientData.firstName}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Age: ${twelveLead!.patientData.age}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Sex: ${twelveLead!.patientData.sex}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("Patient Id: ${twelveLead!.patientData.patientId}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("HR: ${twelveLead!.heartRate}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("PR Interval: ${twelveLead!.prInt} ms"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text("QRS Duration: ${twelveLead!.qrsDur} ms"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child:
                Text("QT/QTc: ${twelveLead!.qtInt}/${twelveLead!.corrQtInt}"),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
                "P-R-T Axis: ${twelveLead!.pAxis} ${twelveLead!.qrsAxis} ${twelveLead!.tAxis}"),
          ),
          ...twelveLead!.statements.map((x) => Container(
                padding: EdgeInsets.all(8),
                child: Text(x),
              )),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
                "STJ: I: ${twelveLead!.stValues[0] / 100} II: ${twelveLead!.stValues[1] / 100} III: ${twelveLead!.stValues[2] / 100} aVR: ${twelveLead!.stValues[3] / 100} aVL: ${twelveLead!.stValues[4] / 100} aVF: ${twelveLead!.stValues[5] / 100} V1: ${twelveLead!.stValues[6] / 100} V2: ${twelveLead!.stValues[7] / 100} V3: ${twelveLead!.stValues[8] / 100} V4: ${twelveLead!.stValues[9] / 100} V5: ${twelveLead!.stValues[10] / 100} V6: ${twelveLead!.stValues[11] / 100}"),
          ),
          TwelveLeadChart(
            data: twelveLead!,
          ),
        ],
      ),
    );
  }
}
