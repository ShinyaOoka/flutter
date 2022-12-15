import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

import '../../../di/injection.dart';
import '../../../module/common/navigator_screen.dart';
import '../../../module/local_storage/shared_pref_manager.dart';
import '../../../module/res/colors.dart';
import '../../../module/res/dimens.dart';
import '../../home/home_page.dart';

void entryBottomSheet({String? message, String? url}) {
  BuildContext context = getIt<NavigationService>().navigatorKey.currentContext!;

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: transparent,
    context: context,
    builder: (BuildContext builderContext) {
      return FractionallySizedBox(
        heightFactor: 1.0,
        child: EntryBottomSheet(
          url: url,
        ),
      );
    },
  );
}

class EntryBottomSheet extends StatefulWidget {
  final String? url;

  const EntryBottomSheet({Key? key, required this.url}) : super(key: key);

  @override
  _EntryBottomSheetState createState() => _EntryBottomSheetState();
}

class _EntryBottomSheetState extends State<EntryBottomSheet> {
  late WebViewController _controller;
  String curURL = "https://";
  bool isFinishLoad = false;
  final String appToken = getIt<UserSharePref>().getAppToken();
  NavigationService _navigationService = getIt<NavigationService>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            color: kColor202330,
            padding: EdgeInsets.only(
              top: size_30_h,
            ),
            child: WebView(
              initialUrl: widget.url! + (widget.url!.contains("?") ? "&" : "?") + 'device=flutter&app_token=$appToken',
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                  name: "close",
                  onMessageReceived: (JavascriptMessage result) {
                    Navigator.pop(context);
                  },
                ),
                JavascriptChannel(
                  name: "showTournamentList",
                  onMessageReceived: (JavascriptMessage result) {
                    getIt<NavigationService>().currentHomeIndex = 1;
                    _navigationService.pushReplacementScreenWithFade(HomePage());
                  },
                ),
                JavascriptChannel(
                    name: "rp_pickfile",
                    onMessageReceived: (JavascriptMessage result) async {
                      FilePickerResult? fpresult = await FilePicker.platform.pickFiles(type: FileType.any);
                      if (fpresult != null) {
                        String fpath = fpresult.files.single.path ?? "";
                        File file = File(fpath);
                        Uint8List bindata = await file.readAsBytes();
                        List<int> binlist = bindata.buffer.asUint8List();
                        String dataURI = Uri.dataFromBytes(binlist).toString();

                        // mime type
                        String mimeType = "application/octet-stream";
                        String fileExt = extension(fpath);
                        fileExt = fileExt.replaceAll('.', '');
                        if (fileExt == "png") {
                          mimeType = "image/png";
                        } else if (fileExt == "jpg" || fileExt == "jpeg") {
                          mimeType = "image/jpeg";
                        }

                        _controller.runJavascript(
                            """
                  var dataURI = "$dataURI";
                  var byteString = atob( dataURI.split( "," )[1] ) ;
                  var mimeType = "${mimeType}";
                  for( var i=0, l=byteString.length, content=new Uint8Array( l ); l>i; i++ ) {
                    content[i] = byteString.charCodeAt( i ) ;
                  }
                  var blob = new Blob( [ content ], {
                    type: mimeType ,
                  } ) ;
                  var imgFile = new File([blob], '${basename(fpath)}', {type: "${mimeType}"});
 
                  var inputtag = document.getElementById("${result.message}");
                  var dt = new DataTransfer();
                  dt.items.add(imgFile);
                  inputtag.files = dt.files;
                  var event = new Event("change");
                  inputtag.dispatchEvent(event);
                  """
                        );
                      }
                    }),
              ]),
              gestureRecognizers: Set()
                ..add(Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())),
              onPageFinished: (value) async {
                await Future.delayed(const Duration(milliseconds: 500 ));
                _controller.runJavascript("""
                  var ftlist = document.getElementsByTagName("input");
                  for( var n=0; n < ftlist.length; ++n ){
                    var ft = ftlist[n];
                    if(ft.type=="file"){
                      var ftid=ft.id;
                      if(ftid==""){
                      // idが付いてないときは、そのページに存在しないidをinputタグに付与
                        for( var i=0; i < 100; ++i){
                          ftid="ftid"+i;
                          if( document.getElementById(ftid)==null ){
                            break;
                          }
                        }
                        ft.id = ftid;
                      }
                      ft.addEventListener("click",(event)=>{ rp_pickfile.postMessage(event.target.id); });
                    }
                  }
                  """);
                setState(() {
                  isFinishLoad = true;
                  curURL = value;
                });
              },
              onWebViewCreated: (WebViewController webViewController) async {
                _controller = webViewController;
              },
            ),
          ),
          Visibility(
            visible: !isFinishLoad,
            child: Container(
              color: kColor202330,
            ),
          ),
        ],
      ),
    );
  }
}
