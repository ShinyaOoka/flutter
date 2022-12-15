import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../module/res/style.dart';

class AdaptiveUrlImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double scale;
  final BoxFit fit;

  const AdaptiveUrlImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.scale = 1.0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.contains('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => Center(
          child: Container(
            height: 45,
            width: 45,
            child:
            Image.asset('assets/images/placeholder.jpg'),
           /* CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                kColor007bff,
              ),
            ),*/
          ),
        ),
        errorWidget: (context, url, error) {
          return Icon(Icons.error);
        },
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      try {
        return Image.file(
          File(url),
          width: width,
          height: height,
          scale: scale,
          fit: fit,
        );
      } catch (e) {
        return Image.asset('assets/images/ig_logo_grey.webp');
      }
    }
  }
}
