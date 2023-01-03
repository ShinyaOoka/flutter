import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../module/res/style.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../../viewmodel/life_cycle_base.dart';
import '../widget_utils/base_scaffold_safe_area.dart';
import 'edit_report_viewmodel.dart';

class EditReportPage extends PageProvideNode<EditReportViewModel> {
  EditReportPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return EditReportContent(viewModel);
  }
}

class EditReportContent extends StatefulWidget {
  final EditReportViewModel _editReportViewModel;

  EditReportContent(this._editReportViewModel);

  @override
  EditReportState createState() => EditReportState();
}

class EditReportState extends LifecycleState<EditReportContent>
    with SingleTickerProviderStateMixin {
  EditReportViewModel get editReportViewModel => widget._editReportViewModel;
  late AnimationController _animationController;

  @override
  void initState() {
    editReportViewModel.initData();
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
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => editReportViewModel.back(),
        child: BaseScaffoldSafeArea(
          customAppBar: AppBar(
            backgroundColor: kColor4472C4,
            centerTitle: true,
            title: Text(
              'EDIT REPORT',
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
              onPressed: () => editReportViewModel.back(),
            ),
            actions: [
              TextButton(
                child: Text('Preview',
                    // style: Theme.of(context).appBarTheme.titleTextStyle,
                    style: TextStyle(
                      fontSize: text_16,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    )),
                onPressed: () => editReportViewModel.openConfirmReport(),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          transparentStatusBar: 0.0,
          title: '',
          hideBackButton: false,
          /*body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        LocaleKeys.x_series_data_acquisition.tr(),
                        // style: Theme.of(context).appBarTheme.titleTextStyle,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    color: kColor4472C4,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: _buildPanel(),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
        ));
  }
}
