import 'dart:io';

import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ListEventScreenArguments {
  final XSeriesDevice device;
  final String caseId;

  ListEventScreenArguments({required this.device, required this.caseId});
}

class ListEventScreen extends StatefulWidget {
  const ListEventScreen({super.key});

  @override
  _ListEventScreenState createState() => _ListEventScreenState();
}

class _ListEventScreenState extends State<ListEventScreen> with RouteAware {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late XSeriesDevice device;
  late String caseId;
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
    final args =
        ModalRoute.of(context)!.settings.arguments as ListEventScreenArguments;
    device = args.device;
    caseId = args.caseId;

    _hostApi = Provider.of<ZollSdkHostApi>(context);
    _zollSdkStore = context.read();
    final tempDir = await getTemporaryDirectory();
    await File(tempDir.path + '/demo.json')
        .writeAsString(await rootBundle.loadString("assets/example/demo.json"));
    _hostApi.deviceDownloadCase(device, caseId, tempDir.path, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('get_xseries_data'.i18n()),
      actions: _buildActions(),
      centerTitle: true,
      leading: _buildBackButton(),
      leadingWidth: 100,
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      // _buildCreateReportButton(),
    ];
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.arrow_back),
      style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor),
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
        Observer(
            builder: (context) => _zollSdkStore.cases[caseId]?.nativeCase != null
                ? _buildMainContent()
                : CustomProgressIndicatorWidget()),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Container(
          child: Text("please_choose_case".i18n(),
              style: Theme.of(context).textTheme.titleLarge),
          padding: EdgeInsets.all(16),
        ),
        Expanded(
          child: Observer(
            builder: (context) {
              final caseData = _zollSdkStore.cases[caseId]!;
              print(caseData.events.length);
              return ListView.separated(
                itemCount: caseData.events.length,
                itemBuilder: (context, index) => ListTile(
                    title: Text(
                        '${caseData.events[index]?.date} ${caseData.events[index]?.type}'),
                    onTap: () {}),
                separatorBuilder: (context, index) => const Divider(),
              );
            },
          ),
        ),
      ],
    );
  }

  _showErrorMessage(String message) {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: 'error_occurred'.i18n(),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    });

    return const SizedBox.shrink();
  }
}
