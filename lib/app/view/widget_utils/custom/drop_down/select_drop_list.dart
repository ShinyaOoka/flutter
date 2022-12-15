import 'package:flutter/material.dart';

import '../../../../module/res/style.dart';

class SelectDropList extends StatefulWidget {
  final dynamic itemSelected;
  final List<dynamic> listOptionItems;
  final Function(dynamic optionItem) onItemSelected;
 // Function(dynamic item, BuildContext context) childItem;
  Function(dynamic item, BuildContext context) childItem;

  SelectDropList({required this.itemSelected, required this.listOptionItems, required this.onItemSelected, required this.childItem});

  @override
  _SelectDropListState createState() =>
      _SelectDropListState(itemSelected, listOptionItems);
}

class _SelectDropListState extends State<SelectDropList>
    with SingleTickerProviderStateMixin {
  dynamic optionItemSelected;
  final List<dynamic> listOptionItems;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  _SelectDropListState(this.optionItemSelected, this.listOptionItems);

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Colors.black26, offset: Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.card_travel,
                  color: Color(0xFF307DF1),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    this.isShow = !this.isShow;
                    _runExpandCheck();
                    setState(() {});
                  },
                  child: Text(
                    optionItemSelected,
                    style: TextStyle(color: Color(0xFF307DF1), fontSize: 16),
                  ),
                )),
                Align(
                  alignment: Alignment(1, 0),
                  child: Icon(
                    isShow ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: Color(0xFF307DF1),
                    size: size_16_w,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black26,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    children: widget.listOptionItems.map((item) => buildSubMenu(item, context)).toList(),
                  ))),
//          Divider(color: Colors.grey.shade300, height: 1,)
        ],
      ),
    );
  }

  Widget buildSubMenu(dynamic item, BuildContext context) {
    return GestureDetector(
      child: widget.childItem(item, context),
      onTap: () {
        this.optionItemSelected = item;
        isShow = false;
        expandController.reverse();
        widget.onItemSelected(item);
      },
    );
  }
}
