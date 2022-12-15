import 'package:flutter/material.dart';
class ImageHolder extends StatelessWidget {
  final String asset;
  final width;
  final height;

  const ImageHolder({Key? key, required this.asset, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}
