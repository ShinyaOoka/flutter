import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final AppBar appBar;
  final String? title;
  final List<Widget>? actions;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    Widget result = appBar;
    if (title != null) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar,
          PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child:
                    Text(title!, style: Theme.of(context).textTheme.titleLarge),
              ),
              preferredSize: Size.fromHeight(40))
        ],
      );
    }
    return result;
  }

  CustomAppBar(
      {super.key, this.leading, this.title, this.actions, this.leadingWidth})
      : appBar = AppBar(
          toolbarHeight: 60,
          title: Image(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.fitHeight,
            height: 60,
          ),
          centerTitle: true,
          leading: leading,
          leadingWidth: leadingWidth,
          actions: actions,
        );

  @override
  Size get preferredSize {
    return Size(appBar.preferredSize.width,
        appBar.preferredSize.height + (title != null ? 40 : 0));
  }
}
