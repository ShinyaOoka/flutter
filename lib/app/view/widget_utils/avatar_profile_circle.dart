import 'package:flutter/widgets.dart';

import '../../module/network/network_util.dart';
import 'custom/image_holder.dart';


class AvatarProfileCircle extends StatelessWidget {
  String? avatarUrl;
  double size;

  AvatarProfileCircle({Key? key, this.avatarUrl, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(1000.0)),
      clipBehavior: Clip.hardEdge,
      child: FadeInImage(
        fit: BoxFit.cover,
        width: size,
        height: size,
        fadeInDuration: Duration(milliseconds: 50),
        //ERROR IMAGE WHEN LOAD IMAGE
        imageErrorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return ImageHolder(
            asset: 'assets/images/placeholder_character.png',
            width: size,
            height: size,
          );
        },
        placeholder: AssetImage('assets/images/placeholder_character.png'),
        image: NetworkImage(
          avatarUrl ?? '',
          headers: headers,
        ),
      ),
    );
  }
}


