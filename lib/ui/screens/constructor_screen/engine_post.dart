import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class EnginePost extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double width;
  final double height;
  final double rotate;
  final double backgroundHeight;
  final double backgroundWidth;
  final String backgroundImagePath;
  final double opacity;
  final Widget child;

  EnginePost({
    this.rotate = 0,
    @required this.height,
    @required this.width,
    this.top,
    this.left,
    this.bottom,
    this.right,
    @required this.backgroundHeight,
    @required this.backgroundWidth,
    this.opacity = 1,
    @required this.backgroundImagePath,
    @required this.child,
  })  : assert(height != null),
        assert(width != null),
        assert(backgroundWidth != null),
        assert(backgroundHeight != null),
        assert(backgroundImagePath != null),
        assert(child != null);

  DynamicTemplateEngine _templateEngine;

  @override
  Widget build(BuildContext context) {
    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);

    return Positioned(
      left: _templateEngine.getWidth(left),
      top: _templateEngine.getHeight(top),
      bottom: _templateEngine.getHeight(bottom),
      right: _templateEngine.getWidth(right),
      child: Container(
        width: _templateEngine.getWidth(width),
        height: _templateEngine.getHeight(height),
        child: Transform.rotate(
          angle: rotate * pi / 180,
          child: Center(
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: opacity,
                  child: Container(
                    height: _templateEngine.getHeight(backgroundHeight),
                    width: _templateEngine.getWidth(backgroundWidth),
                    child: Image.asset(
                      backgroundImagePath,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                child
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnginePostChild extends StatelessWidget {
  final double stackLeft;
  final double stackTop;
  final double stackBottom;
  final double stackRight;
  final double photoWidth;
  final double photoHeight;
  final double plusPaddingTop;
  final double plusPaddingLeft;
  final int photoNumber;
  final double plusSize;
  final double textSize;
  final double textRightPadding;
  final double textBottomPadding;
  final double whiteSize;
  final double angle;

  EnginePostChild({
    this.stackTop,
    @required this.photoHeight,
    @required this.photoWidth,
    this.stackLeft,
    this.stackRight,
    this.stackBottom,
    @required this.textSize,
    this.textRightPadding,
    this.textBottomPadding = 0,
    this.whiteSize = 176,
    this.plusSize = 65.31,
    @required this.plusPaddingTop,
    this.plusPaddingLeft = 0,
    @required this.photoNumber,
    this.angle = 0,
  })  : assert(photoWidth != null),
        assert(photoHeight != null),
        assert(textSize != null),
        assert(plusPaddingTop != null),
        assert(photoNumber != null);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: Provider.of<DynamicTemplateEngine>(context).getWidth(stackLeft),
      top: Provider.of<DynamicTemplateEngine>(context).getHeight(stackTop),
      child: Transform.rotate(
        angle: angle * pi / 180,
        child: PostButton(
          photoHeight: photoHeight,
          photoWidth: photoWidth,
          photoNumber: photoNumber,
          plusPaddingTop: plusPaddingTop,
          plusPaddingLeft: plusPaddingLeft,
          plusSize: plusSize,
          textSize: textSize,
          whiteSize: whiteSize,
          textRightPadding: textRightPadding,
          textBottomPadding: textBottomPadding,
        ),
      ),
    );
  }
}

class TransparentEnginePost extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double width;
  final double height;
  final Widget child;

  TransparentEnginePost({
    this.left,
    this.bottom,
    this.top,
    this.right,
    @required this.height,
    @required this.width,
    @required this.child,
  })  : assert(height != null),
        assert(width != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: Provider.of<DynamicTemplateEngine>(context).getWidth(left),
      top: Provider.of<DynamicTemplateEngine>(context).getHeight(top),
      bottom: Provider.of<DynamicTemplateEngine>(context).getHeight(bottom),
      right: Provider.of<DynamicTemplateEngine>(context).getWidth(right),
      child: child,
    );
  }
}

class TransparentEnginePostChild extends StatelessWidget {
  final double photoWidth;
  final double photoHeight;
  final double plusPaddingTop;
  final double plusPaddingLeft;
  final int photoNumber;
  final double plusSize;
  final double textSize;
  final double textRightPadding;
  final double textBottomPadding;
  final double whiteSize;
  final double angle;

  TransparentEnginePostChild({
    @required this.photoHeight,
    @required this.photoWidth,
    @required this.textSize,
    this.textRightPadding = 10,
    this.textBottomPadding = 0,
    this.whiteSize = 176,
    this.plusSize = 65.31,
    @required this.plusPaddingTop,
    this.plusPaddingLeft = 0,
    @required this.photoNumber,
    this.angle = 0,
  })  : assert(photoWidth != null),
        assert(photoHeight != null),
        assert(textSize != null),
        assert(plusPaddingTop != null),
        assert(photoNumber != null);

  @override
  Widget build(BuildContext context) {
    return PostButton(
      photoWidth: photoWidth,
      photoHeight: photoHeight,
      transparent: true,
      photoNumber: photoNumber,
      plusPaddingTop: plusPaddingTop,
      plusPaddingLeft: plusPaddingLeft,
      plusSize: plusSize,
      textSize: textSize,
      whiteSize: whiteSize,
      textRightPadding: textRightPadding,
      textBottomPadding: textBottomPadding,
    );
  }
}
