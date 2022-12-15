import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../module/res/colors.dart';
import '../../module/res/dimens.dart';
import '../../viewmodel/base_viewmodel.dart';
import '../widget_utils/base_scaffold.dart';
import 'splash_viewmodel.dart';

class SplashPage extends PageProvideNode<SplashViewModel> {
  SplashPage() : super();

  @override
  Widget buildContent(BuildContext context) {
    return _SplashContentPage(viewModel);
  }
}

class _SplashContentPage extends StatefulWidget {
  final SplashViewModel _splashViewModel;

  _SplashContentPage(this._splashViewModel);

  @override
  State<StatefulWidget> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContentPage> {
  SplashViewModel get splashViewModel => widget._splashViewModel;

  @override
  void initState() {
    if (context != null) splashViewModel.startApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      transparentStatusBar: 0.0,
      isAppBar: false,
      backgroundColor: kColor875a7b,
      body: Stack(
        children: [
          /* Image.asset(
            'assets/images/bkg_gt.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),*/
          Center(
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: size_200_w,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
