import 'package:ak_azm_flutter/widgets/layout/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class MockScreenArguments {
  final String title;

  MockScreenArguments({required this.title});
}

class MockScreen extends StatefulWidget {
  const MockScreen({super.key});

  @override
  _MockScreenState createState() => _MockScreenState();
}

class _MockScreenState extends State<MockScreen> with RouteAware {
  String title = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as MockScreenArguments;
    setState(() {
      title = args.title;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
      title: title,
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
      children: const <Widget>[
        // _handleErrorMessage(),
      ],
    );
  }
}
