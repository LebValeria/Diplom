import 'package:flutter/cupertino.dart';

class ImageData {
  final double angle;
  final double photoHeight;
  final double photoWidth;

  ImageData({
    @required this.photoHeight,
    this.angle,
    @required this.photoWidth,
  });
}
