import 'package:flutter/material.dart';



class AppBarInputReport extends StatelessWidget implements PreferredSizeWidget {
  final Widget? iconLeft, iconRight;
  final bool enableCopyPaste;
  final int badgeCount;
  final String avatarUrl;
  final Function? leftIconOnPress;
  final Function? rightIconOnPress;
  VoidCallback? onClickAvatar;
  VoidCallback? onClickTicKet;

  AppBarInputReport({
    Key? key,
    this.iconLeft,
    this.iconRight,
    this.enableCopyPaste = false,
    this.leftIconOnPress,
    this.rightIconOnPress,
    this.badgeCount = 0,  this.avatarUrl = '',
    this.onClickAvatar,
    this.onClickTicKet
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('レポート新規入力',
            // style: Theme.of(context).appBarTheme.titleTextStyle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      leading: TextButton(
        child:  Text('戻る',
            // style: Theme.of(context).appBarTheme.titleTextStyle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () => {},
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.0);
}
