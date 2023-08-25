import 'dart:io';

import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/data/parser/case_parser.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/models/downloaded_case/downloaded_case.dart';
import 'package:ak_azm_flutter/stores/downloaded_case/downloaded_case_store.dart';
import 'package:ak_azm_flutter/ui/data_viewer/choose_function_screen/choose_function_screen.dart';
import 'package:ak_azm_flutter/utils/routes/data_viewer.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
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
  bool _sortAsc = false;
  int _sortColumnIndex = 3;

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
              : CustomProgressIndicatorWidget()
        ],
      );
    });
  }

  _formatTime(DateTime? time) {
    // return time;
    if (time == null) return '';
    return AppConstants.dateTimeFormat.format(time);
  }

  _onSort(int columnIndex, bool sortAscending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAsc = sortAscending;
      if (_sortColumnIndex == 0) {
        _downloadedCaseStore.downloadedCases!.sort((a, b) {
          int compare = a.deviceCd!.compareTo(b.deviceCd!);
          if (compare == 0) {
            return a.entryDate!.compareTo(b.entryDate!) *
                (sortAscending ? 1 : -1);
          }
          return compare * (sortAscending ? 1 : -1);
        });
      }
      if (_sortColumnIndex == 1) {
        _downloadedCaseStore.downloadedCases!.sort((a, b) {
          if (a.caseStartDate == null) {
            return sortAscending ? 1 : -1;
          }
          if (a.caseEndDate == null) {
            return sortAscending ? -1 : 1;
          }
          int compare = a.caseStartDate!.compareTo(b.caseStartDate!);
          if (compare == 0) {
            return a.entryDate!.compareTo(b.entryDate!) *
                (sortAscending ? 1 : -1);
          }
          return compare * (sortAscending ? 1 : -1);
        });
      }
      if (_sortColumnIndex == 2) {
        _downloadedCaseStore.downloadedCases!.sort((a, b) {
          if (a.caseEndDate == null) {
            return sortAscending ? 1 : -1;
          }
          if (a.caseEndDate == null) {
            return sortAscending ? -1 : 1;
          }
          int compare = a.caseEndDate!.compareTo(b.caseEndDate!);
          if (compare == 0) {
            return a.entryDate!.compareTo(b.entryDate!) *
                (sortAscending ? 1 : -1);
          }
          return compare * (sortAscending ? 1 : -1);
        });
      }
      if (_sortColumnIndex == 3) {
        _downloadedCaseStore.downloadedCases!.sort((a, b) {
          return a.entryDate!.compareTo(b.entryDate!) *
              (sortAscending ? 1 : -1);
        });
      }
    });
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Table(
          border: TableBorder(horizontalInside: BorderSide(color: Colors.grey)),
          children: [
            TableRow(children: [
              _buildTableHeader(0),
              _buildTableHeader(1),
              _buildTableHeader(2),
              _buildTableHeader(3),
              TableCell(child: Text('')),
            ]),
            ..._downloadedCaseStore.downloadedCases!.map(
              (e) => TableRow(
                children: [
                  _buildTableCell(e, e.deviceCd ?? ''),
                  _buildTableCell(e, _formatTime(e.caseStartDate)),
                  _buildTableCell(e, _formatTime(e.caseStartDate)),
                  _buildTableCell(e, _formatTime(e.entryDate)),
                  TableCell(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("ファイル削除前確認"),
                            content: const Text("ケースファイルを削除しますか？"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("はい")),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("キャンセル"))
                            ],
                          ),
                        );
                        if (shouldDelete == true) {
                          await _downloadedCaseStore
                              .deleteDownloadedCase([e.id!]);
                          await _downloadedCaseStore.getDownloadedCases();
                          await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("ファイル削除後確認"),
                              content: const Text("ケースファイルを削除しました。"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("OK"))
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(int index) {
    String text = '';
    switch (index) {
      case 0:
        text = '端末名';
        break;
      case 1:
        text = '開始日時';
        break;
      case 2:
        text = '終了日時';
        break;
      case 3:
        text = '保存日時';
        break;
    }

    return InkWell(
      onTap: () {
        _onSort(index, index == _sortColumnIndex ? !_sortAsc : false);
      },
      child: TableCell(
        child: Container(
          height: 50,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: _sortColumnIndex == index ? Color(0xff0082C8) : null,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  index == _sortColumnIndex && _sortAsc
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: _sortColumnIndex == index ? Color(0xff0082C8) : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRowInkWell _buildTableCell(DownloadedCase e, String content) {
    return TableRowInkWell(
        child: TableCell(
            child: Container(height: 50, child: Center(child: Text(content)))),
        onTap: () {
          _zollSdkStore.caseOrigin = CaseOrigin.downloaded;
          _loadData(e);
          Navigator.of(context).pushNamed(
              DataViewerRoutes.dataViewerChooseFunction,
              arguments: ChooseFunctionScreenArguments(caseId: e.caseCd!));
        });
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
