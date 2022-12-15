

import 'package:url_launcher/url_launcher.dart';

import '../../view/widget_utils/dialog/alert_gt_dialog.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showGeneralDialog(
      message: 'Could not Launch $url',
    );
    throw 'Could not Launch $url';
  }
}

launchScheme(String scheme, String? url) async {
  if (await canLaunch(scheme)) {
    await launch(scheme);
  } else if (url != null && await canLaunch(url)) {
    await launch(url);
  } else {
    showGeneralDialog(
      message: 'Could not Launch $url',
    );
    throw 'Could not Launch $url';
  }
}