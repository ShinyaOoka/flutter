import 'package:ak_azm_flutter/models/report/report.dart';
import 'package:ak_azm_flutter/widgets/layout/app_scaffold.dart';
import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:ak_azm_flutter/widgets/report_list_tile.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/utils/routes/report.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:tuple/tuple.dart';

enum SelectionMode { none, copy, delete }

class ListReportScreen extends StatefulWidget {
  const ListReportScreen({super.key});

  @override
  _ListReportScreenState createState() => _ListReportScreenState();
}

class _ListReportScreenState extends State<ListReportScreen> with RouteAware {
  late ReportStore _reportStore;
  late TeamStore _teamStore;
  late ClassificationStore _classificationStore;
  late ScrollController scrollController;
  final RouteObserver<ModalRoute<void>> _routeObserver =
      getIt<RouteObserver<ModalRoute<void>>>();
  SelectionMode mode = SelectionMode.none;
  Set<int>? selectingReports;
  bool initialized = false;

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
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _reportStore = context.read();
    _teamStore = context.read();
    _classificationStore = context.read();

    Future.wait([
      _reportStore.getReports(),
      _teamStore.getTeams(),
      _classificationStore.getAllClassifications(),
    ]).then((_) {
      _reportStore.reports?.forEach((element) {
        element.teamStore = _teamStore;
        element.classificationStore = _classificationStore;
      });
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  void didPopNext() {
    _reportStore.getReports().then((_) {
      _reportStore.reports?.forEach((element) {
        element.teamStore = _teamStore;
        element.classificationStore = _classificationStore;
      });
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _buildBody(),
      floatingActionButton:
          mode == SelectionMode.none ? _buildCreateReportButton() : null,
      actions: _buildActions(context),
      title: 'list_report'.i18n(),
      leadings: mode != SelectionMode.none ? [_buildBackButton()] : null,
      leadingWidth: mode != SelectionMode.none ? 102 : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'list_report'.i18n(),
      actions: _buildActions(context),
      leading: mode != SelectionMode.none ? _buildBackButton() : null,
      leadingWidth: mode != SelectionMode.none ? 102 : null,
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.cancel),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('ｷｬﾝｾﾙ'.i18n()),
      onPressed: () {
        setState(() {
          mode = SelectionMode.none;
        });
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (mode) {
      case SelectionMode.none:
        return [_buildSelectButton()];
      case SelectionMode.copy:
        return [_buildCopyButton()];
      case SelectionMode.delete:
        return [_buildDeleteButton()];
    }
  }

  Widget _buildSelectButton() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
              value: 0,
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.content_copy),
                  title: Text('複写登録'))),
          const PopupMenuItem(
              value: 1,
              child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.delete),
                  title: Text('選択削除'))),
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case 0:
            setState(() {
              mode = SelectionMode.copy;
              selectingReports = {};
            });
            break;
          case 1:
            setState(() {
              mode = SelectionMode.delete;
              selectingReports = {};
            });
            break;
        }
      },
    );
  }

  Widget _buildDeleteButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () async {
          if (selectingReports?.isEmpty == true) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除対象無エラー'),
                content: const Text('削除対象が選択されていません。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }
          final result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('選択削除確認'),
                  content: const Text('選択したデータを削除します。よろしいですか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'はい',
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    ),
                  ],
                );
              });
          if (result != true) {
            return;
          }
          final reportIds = selectingReports!
              .map((e) => _reportStore.reports![e].id!)
              .toList();
          await _reportStore.deleteReports(reportIds);
          await _reportStore.getReports();
          if (!mounted) return;
          FlushbarHelper.createInformation(
            message: '削除処理を完了しました。',
            duration: const Duration(seconds: 3),
          ).show(context);
          setState(() {
            mode = SelectionMode.none;
          });
        },
        icon: const Icon(Icons.delete),
        label: Text(
          '削除',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () async {
          if (selectingReports?.isEmpty == true) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('複写対象無エラー'),
                content: const Text('複写対象が選択されていません。'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }

          final result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('複写対象確認'),
                  content: const Text('「3.時間経過」「4.発生状況」「9.通報状況」のみ複写します。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
              barrierDismissible: false);
          if (result != true) {
            return;
          }

          final fromReport =
              _reportStore.reports![selectingReports!.first].toJson();
          final toReport = Report().toJson();

          for (var field in AppConstants.reportCopyFields) {
            toReport[field] = fromReport[field];
          }

          _reportStore.selectingReport = Report.fromJson(toReport);
          Navigator.of(context).pushNamed(ReportRoutes.reportCreateReport);
          setState(() {
            mode = SelectionMode.none;
          });
        },
        icon: const Icon(Icons.note_add),
        label: Text(
          '複写',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateReportButton() {
    return FloatingActionButton(
      onPressed: () {
        _reportStore.selectingReport = Report();
        _reportStore.selectingReport!.approver1 = _reportStore.lastApprover1;
        _reportStore.selectingReport!.approver2 = _reportStore.lastApprover2;
        _reportStore.selectingReport!.approver3 = _reportStore.lastApprover3;
        Navigator.of(context).pushNamed(ReportRoutes.reportCreateReport);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return initialized
            ? Material(child: _buildListView())
            : const CustomProgressIndicatorWidget();
      },
    );
  }

  Widget _buildListView() {
    return Observer(builder: (context) {
      return _reportStore.reports != null
          ? Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: scrollController,
                itemCount: _reportStore.reports!.length,
                separatorBuilder: (context, position) {
                  return const Divider(height: 1, color: Colors.black45);
                },
                itemBuilder: (context, position) {
                  return _buildListItem(position);
                },
              ),
            )
          : Center(child: Text('no_report_found'.i18n()));
    });
  }

  Widget _buildListTileTitle(int position) {
    final item = _reportStore.reports![position];
    final team = _teamStore.teams[item.teamCd];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                children: [
              TextSpan(
                  text: '発生日時：',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                style: const TextStyle(fontWeight: FontWeight.bold),
                text:
                    '${item.dateOfOccurrence != null ? AppConstants.dateFormat.format(item.dateOfOccurrence!) : '----/--/--'} ${item.timeOfOccurrence?.format(context) ?? '--:--'}',
              ),
            ])),
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: '${'list_report_team_name'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: team?.name ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ],
    );
  }

  Widget _buildListTileSubtitle(int position) {
    final item = _reportStore.reports![position];
    final typeOfAccident = item.typeOfAccident != null
        ? _classificationStore.classifications[
            Tuple2(AppConstants.typeOfAccidentCode, item.typeOfAccident!)]
        : null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${'type_of_accident'.i18n()} : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: typeOfAccident?.value ?? 'なし',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '作成日 : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: item.entryDate != null
                      ? AppConstants.dateTimeHmFormat.format(item.entryDate!)
                      : '----/--/-- --:--',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '${'accident_summary'.i18n()} : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: item.accidentSummary ?? 'なし',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '更新日 : ',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              TextSpan(
                  text: item.updateDate != null
                      ? AppConstants.dateTimeHmFormat.format(item.updateDate!)
                      : '----/--/-- --:--',
                  style: Theme.of(context).textTheme.bodyMedium)
            ])),
          ],
        )
      ],
    );
  }

  Widget _buildListItem(int position) {
    final item = _reportStore.reports![position];
    switch (mode) {
      case SelectionMode.none:
        return ReportListTile(
          report: item,
          onTap: () {
            _reportStore.setSelectingReport(item);
            Navigator.of(context).pushNamed(ReportRoutes.reportConfirmReport);
          },
        );
      case SelectionMode.delete:
        return CheckboxListTile(
          value: selectingReports?.contains(position),
          onChanged: (value) {
            setState(() {
              if (selectingReports?.contains(position) == true) {
                selectingReports?.remove(position);
              } else {
                selectingReports?.add(position);
              }
            });
          },
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: const Color(0xFFF5F5F5),
          title: _buildListTileTitle(position),
          subtitle: _buildListTileSubtitle(position),
        );
      case SelectionMode.copy:
        return RadioListTile(
          value: position,
          groupValue: selectingReports?.isNotEmpty == true
              ? selectingReports?.single
              : null,
          onChanged: (value) {
            setState(() {
              if (selectingReports?.contains(position) == true) {
                selectingReports?.clear();
              } else {
                selectingReports?.clear();
                selectingReports?.add(position);
              }
            });
          },
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: const Color(0xFFF5F5F5),
          title: _buildListTileTitle(position),
          subtitle: _buildListTileSubtitle(position),
        );
    }
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_reportStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_reportStore.errorStore.errorMessage);
        }

        return const SizedBox.shrink();
      },
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
