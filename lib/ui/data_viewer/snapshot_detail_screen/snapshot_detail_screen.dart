import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:ak_azm_flutter/widgets/ecg_chart.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report/section/report_section_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class SnapshotDetailScreenArguments {
  final Snapshot snapshot;

  SnapshotDetailScreenArguments({required this.snapshot});
}

class SnapshotDetailScreen extends StatefulWidget {
  const SnapshotDetailScreen({super.key});

  @override
  _SnapshotDetailScreenState createState() => _SnapshotDetailScreenState();
}

class _SnapshotDetailScreenState extends State<SnapshotDetailScreen>
    with RouteAware, ReportSectionMixin {
  late Snapshot snapshot;

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
        as SnapshotDetailScreenArguments;
    snapshot = args.snapshot;
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
      title: "スナップショット",
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
        _buildMainContent()
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                Text(
                    "| Etco2 ${snapshot.trend.etco2.value} ${snapshot.trend.etco2.unit}"),
                Text(
                    "| Fico2 ${snapshot.trend.fico2.value} ${snapshot.trend.fico2.unit}"),
                Text("HR ${snapshot.trend.hr.value} ${snapshot.trend.hr.unit}"),
                Text(
                    "| nibpDia ${snapshot.trend.nibpDia.value} ${snapshot.trend.nibpDia.unit}"),
                Text(
                    "| nibpMap ${snapshot.trend.nibpMap.value} ${snapshot.trend.nibpMap.unit}"),
                Text(
                    "| nibpSys ${snapshot.trend.nibpSys.value} ${snapshot.trend.nibpSys.unit}"),
                Text("PI ${snapshot.trend.pI.value} ${snapshot.trend.pI.unit}"),
                Text(
                    "| PVI ${snapshot.trend.pVI.value} ${snapshot.trend.pVI.unit}"),
                Text(
                    "| resp ${snapshot.trend.resp.value} ${snapshot.trend.resp.unit}"),
                Text(
                    "| spCo ${snapshot.trend.spCo.value} ${snapshot.trend.spCo.unit}"),
                Text(
                    "| spHb ${snapshot.trend.spHb.value} ${snapshot.trend.spHb.unit}"),
                Text(
                    "| spMet ${snapshot.trend.spMet.value} ${snapshot.trend.spMet.unit}"),
                Text(
                    "| spOC ${snapshot.trend.spOC.value} ${snapshot.trend.spOC.unit}"),
                Text(
                    "| spo2 ${snapshot.trend.spo2.value} ${snapshot.trend.spo2.unit}"),
              ],
            ),
          ),
          Container(
            child: Text('Pads'),
            padding: EdgeInsets.all(16),
          ),
          EcgChart(
            samples: snapshot.waveforms['Pads']!.samples,
            initTimestamp: snapshot.waveforms['Pads']!.samples.first.timestamp,
            segments: 1,
            showGrid: true,
          ),
          Container(
            child: Text('CO2 mmHg, Waveform'),
            padding: EdgeInsets.all(16),
          ),
          EcgChart(
            samples: snapshot.waveforms['CO2 mmHg, Waveform']!.samples,
            initTimestamp: snapshot
                .waveforms['CO2 mmHg, Waveform']!.samples.first.timestamp,
            segments: 1,
            showGrid: true,
            maxY: 1000,
            minY: 0,
            gridHorizontal: 200,
            height: 100,
          ),
          Container(
            child: Text('SpO2 %, Waveform'),
            padding: EdgeInsets.all(16),
          ),
          EcgChart(
            samples: snapshot.waveforms['SpO2 %, Waveform']!.samples,
            initTimestamp:
                snapshot.waveforms['SpO2 %, Waveform']!.samples.first.timestamp,
            segments: 1,
            showGrid: true,
            maxY: 150,
            minY: -150,
            height: 100,
            gridHorizontal: 60,
          )
        ],
      ),
    );
  }
}
