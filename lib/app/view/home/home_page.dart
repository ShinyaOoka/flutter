import 'package:flutter/material.dart';

import '../../viewmodel/base_viewmodel.dart';
import 'home_viewmodel.dart';
class HomePage extends PageProvideNode<HomeViewModel> {
  HomePage({Key? key}) : super(key: key, params: []);

  @override
  Widget buildContent(BuildContext context) {
    return _HomePage(viewModel);
  }
}

class _HomePage extends StatefulWidget {
  final HomeViewModel _homeViewModel;

  _HomePage(this._homeViewModel);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<_HomePage> {
  HomeViewModel get homeViewModel => widget._homeViewModel;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => homeViewModel.onDoubleBackToExit(),
      child: Container(),
    );
  }
}
