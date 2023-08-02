import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/downloaded_case/downloaded_case.dart';
import 'package:ak_azm_flutter/stores/downloaded_case/downloaded_case_store.dart';
import 'package:ak_azm_flutter/ui/data_viewer/choose_function_screen/choose_function_screen.dart';
import 'package:ak_azm_flutter/ui/report/list_event_screen/list_event_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/pigeon.dart';
import 'package:ak_azm_flutter/stores/zoll_sdk/zoll_sdk_store.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';

class ListDownloadedCaseScreen extends StatefulWidget {
  const ListDownloadedCaseScreen({super.key});

  @override
  _ListDownloadedCaseScreenState createState() =>
      _ListDownloadedCaseScreenState();
}

class _ListDownloadedCaseScreenState extends State<ListDownloadedCaseScreen>
    with RouteAware {
  late ZollSdkHostApi _hostApi;
  late ZollSdkStore _zollSdkStore;
  late ScrollController scrollController;
  late DownloadedCaseStore _downloadedCaseStore;

  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  List<CaseListItem>? cases;
  bool hasNewData = false;
  ReactionDisposer? reactionDisposer;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    reactionDisposer?.call();
    _routeObserver.unsubscribe(this);
  }

  @override
  void didPush() {
    _zollSdkStore = context.read();
    _downloadedCaseStore = context.read();
    _downloadedCaseStore.getDownloadedCases();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'データ参照（保存済）'.i18n(),
      body: _buildBody(),
      leadingWidth: 88,
    );
  }

  Widget _buildBody() {
    return Observer(builder: (context) {
      return Stack(
        children: <Widget>[
          // _handleErrorMessage(),
          _downloadedCaseStore.downloadedCases != null
              ? _buildMainContent()
              : const CustomProgressIndicatorWidget()
        ],
      );
    });
  }

  Widget _buildMainContent() {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: scrollController,
        itemCount: _downloadedCaseStore.downloadedCases!.length,
        itemBuilder: (context, index) {
          final myCase = _downloadedCaseStore.downloadedCases![index];
          return ListTile(
            title: Text('${myCase.deviceCd}-${myCase.caseCd}'),
            onTap: () {
              _zollSdkStore.caseOrigin = CaseOrigin.downloaded;
              _loadData(myCase);
              Navigator.of(context).pushNamed(
                  DataViewerRoutes.dataViewerChooseFunction,
                  arguments:
                      ChooseFunctionScreenArguments(caseId: myCase.caseCd!));
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("ファイル削除前確認"),
                    content: Text("ケースファイルを削除しますか？"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("はい")),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("キャンセル"))
                    ],
                  ),
                );
                if (shouldDelete == true) {
                  await _downloadedCaseStore.deleteDownloadedCase([myCase.id!]);
                  await _downloadedCaseStore.getDownloadedCases();
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("ファイル削除後確認"),
                      content: Text("ケースファイルを削除しました。"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("OK"))
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Future<void> _loadData(DownloadedCase downloadedCase) async {
    final appDir = await getApplicationDocumentsDirectory();
    final filepath = '${appDir.path}/${downloadedCase.filename}';
    final parsedCase = CaseParser.parse(await File(filepath).readAsString());
    _zollSdkStore.cases[downloadedCase.caseCd!] = parsedCase;
    parsedCase.startTime = downloadedCase.caseStartDate;
    parsedCase.endTime = downloadedCase.caseEndDate;
  }
}
