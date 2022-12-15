import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../flavors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../module/res/style.dart';

class DialogGeneralTwoAction extends StatelessWidget {
  String? title;
  String? message;
  String? textCancel;
  String? textOk;
  Color? colorTextOk;
  Color? colorTextCancel;
  VoidCallback? onOkClick;
  VoidCallback? onCancelClick;

  DialogGeneralTwoAction({
    Key? key,
    this.title,
    this.message,
    this.textCancel,
    this.textOk,
    this.colorTextOk,
    this.colorTextCancel,
    this.onOkClick,
    this.onCancelClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.all(30.0),
      backgroundColor: transparent,
      child: Wrap(
        children: [
          Container(
            //height: MediaQuery.of(context).size.height / 2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: Text(
                      title ?? F.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: text_16),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 20.0, bottom: 30.0),
                    child: Text(
                      message ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: text_14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: kColorCACACA,
                  height: 1.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0)),
                          onTap: () {
                            onCancelClick?.call();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: heightButton,
                            child: Center(
                              child: Text(
                                textCancel ?? LocaleKeys.dialog_cancel.tr(),
                                style: TextStyle(
                                  color: colorTextCancel ?? kColor027AFF,
                                  fontSize: text_16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: kColorCACACA,
                      width: 1.0,
                      height: heightButton,
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: transparent,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0)),
                          onTap: () {
                            onOkClick?.call();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: heightButton,
                            child: Center(
                              child: Text(
                                textOk ?? LocaleKeys.dialog_ok.tr(),
                                style: TextStyle(
                                    color: colorTextOk ?? kColorFF4136,
                                    fontSize: text_16,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
