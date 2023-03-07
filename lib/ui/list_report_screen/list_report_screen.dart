import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ak_azm_flutter/data/local/constants/app_constants.dart';
import 'package:ak_azm_flutter/di/components/service_locator.dart';
import 'package:ak_azm_flutter/stores/classification/classification_store.dart';
import 'package:ak_azm_flutter/stores/report/report_store.dart';
import 'package:ak_azm_flutter/stores/team/team_store.dart';
import 'package:ak_azm_flutter/utils/routes.dart';
import 'package:ak_azm_flutter/widgets/progress_indicator_widget.dart';
import 'package:localization/localization.dart';
import 'package:tuple/tuple.dart';

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
  List<bool?>? selectingReports;

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

    _reportStore.getReports();
    _teamStore.getTeams();
    _classificationStore.getAllClassifications();
  }

  @override
  void didPopNext() {
    _reportStore.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton:
          selectingReports == null ? _buildCreateReportButton() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'list_report'.i18n(),
      actions: _buildActions(context),
      leading: selectingReports != null ? _buildBackButton() : null,
      leadingWidth: 140,
    );
  }

  Widget _buildBackButton() {
    return TextButton.icon(
      icon: const Icon(Icons.cancel),
      style:
          TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
      label: Text('キャンセル'.i18n()),
      onPressed: () {
        setState(() {
          selectingReports = null;
        });
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      selectingReports != null ? _buildDeleteButton() : _buildSelectButton(),
    ];
  }

  Widget _buildSelectButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          selectingReports = List.filled(_reportStore.reports!.length, false);
        });
      },
      icon: const Icon(Icons.task_alt),
      color: Theme.of(context).primaryColor,
    );
  }

  Widget _buildDeleteButton() {
    return TextButton(
      onPressed: () async {
        if (selectingReports?.contains(true) == false) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('削除対象無エラー'),
              content: Text('削除対象が選択されていません。'),
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
                title: Text('選択削除確認'),
                content: Text('選択したデータを削除します。よろしいですか？'),
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
          setState(() {
            selectingReports = null;
          });
          return;
        }
        final reportIds = selectingReports!
            .asMap()
            .entries
            .where((e) => e.value != null && e.value!)
            .map((e) => _reportStore.reports![e.key].id!)
            .toList();
        await _reportStore.deleteReports(reportIds);
        await _reportStore.getReports();
        if (!mounted) return;
        FlushbarHelper.createInformation(
          message: '削除処理を完了しました。',
          duration: const Duration(seconds: 3),
        ).show(context);
        setState(() {
          selectingReports = null;
        });
      },
      child: Text(
        '削除',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildCreateReportButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.createReport);
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
        return _reportStore.loading
            ? const CustomProgressIndicatorWidget()
            : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return Observer(builder: (context) {
      print(_reportStore.reports?.length);
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
                style: TextStyle(fontWeight: FontWeight.bold),
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
              text: '${'accident_summary'.i18n()} : ',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          TextSpan(
              text: item.accidentSummary ?? 'なし',
              style: Theme.of(context).textTheme.bodyMedium)
        ]))
      ],
    );
  }

  Widget _buildListItem(int position) {
    final item = _reportStore.reports![position];
    return selectingReports != null
        ? CheckboxListTile(
            value: selectingReports?[position],
            onChanged: (value) {
              setState(() {
                selectingReports?[position] = value;
              });
            },
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: Color(0xFFF5F5F5),
            title: _buildListTileTitle(position),
            subtitle: _buildListTileSubtitle(position),
          )
        : ListTile(
            onTap: () {
              _reportStore.setSelectingReport(item);
              Navigator.of(context).pushNamed(Routes.confirmReport);
            },
            dense: true,
            tileColor: Color(0xFFF5F5F5),
            title: _buildListTileTitle(position),
            subtitle: _buildListTileSubtitle(position),
          );
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
