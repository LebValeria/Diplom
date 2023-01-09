import 'package:flutter/cupertino.dart';
import 'package:instapanoflutter/util/util.dart';

class DynamicTemplateEngine {
  final double height;
  final num defaultWidth;

  static int defaultHeight = 1080;

  final double engineHeight = Constants.height300;

  double _height;
  double _width;

  double _scaleHeight;
  double _scaleWidth;

  ///Для сохранения пропорций все строится относительно высоты бэкграунд изображения
  DynamicTemplateEngine({
    @required this.height,
    @required this.defaultWidth,
  })  : this._height = height,
        this._width = height * (defaultWidth / defaultHeight),
        this._scaleHeight = height / defaultHeight,
        this._scaleWidth =
            height * (defaultWidth / defaultHeight) / defaultWidth;

  double get getMainWidth => _width;

  double get getMainHeight => _height;

  double get _getScaleHeight => _scaleHeight;

  double get _getScaleWidth => _scaleWidth;

  double getHeight(num height) =>
      height == null ? null : height * _getScaleHeight;

  double getWidth(num width) {
    return width == null ? null : width * _getScaleWidth;
  }
}
