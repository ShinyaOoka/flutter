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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          appBar,
          PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 40, top: 6),
                  child: Text(title!,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ))
        ],
      );
    }
    return result;
  }

  CustomAppBar(
      {super.key, this.leading, this.title, this.actions, this.leadingWidth})
      : appBar = AppBar(
          toolbarHeight: 60,
          title: const Image(
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
        appBar.preferredSize.height + (title != null ? 44 : 0));
  }
}
