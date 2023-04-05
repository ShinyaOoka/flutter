import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/ui/data_viewer/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/ui/data_viewer/mock_screen/mock_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ChooseFunctionScreenArguments {
  final XSeriesDevice device;
  final String caseId;

  ChooseFunctionScreenArguments({required this.device, required this.caseId});
}

class ChooseFunctionScreen extends StatefulWidget {
  const ChooseFunctionScreen({super.key});

  @override
  _ChooseFunctionScreenState createState() => _ChooseFunctionScreenState();
}

class _ChooseFunctionScreenState extends State<ChooseFunctionScreen>
    with RouteAware {
  XSeriesDevice? device;
  String? caseId;
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
  void didPush() {
    final args = ModalRoute.of(context)!.settings.arguments
        as ChooseFunctionScreenArguments;
    device = args.device;
    caseId = args.caseId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: _buildBackButton(),
      leadingWidth: 88,
      title: '機能選択',
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
    return ListView(children: [
      ListTile(
        title: Text("イベント選択"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerListEvent,
              arguments:
                  ListEventScreenArguments(device: device!, caseId: caseId!));
        },
      ),
      ListTile(
        title: Text("CPR選択"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerMock,
              arguments: MockScreenArguments(title: 'CPR選択'));
        },
      ),
      ListTile(
        title: Text("12Lead選択"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerMock,
              arguments: MockScreenArguments(title: '12Lead選択'));
        },
      ),
      ListTile(
        title: Text("スナップショット選択"),
        onTap: () {
          Navigator.of(context).pushNamed(DataViewerRoutes.dataViewerMock,
              arguments: MockScreenArguments(title: 'スナップショット選択'));
        },
      )
    ]);
  }
}
