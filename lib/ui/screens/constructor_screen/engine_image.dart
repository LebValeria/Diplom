import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class EngineImage extends StatelessWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double width;
  final double height;
  final String pathToImage;
  final double opacity;
  final double rotate;
  final bool color;

  EngineImage({
    @required this.height,
    @required this.width,
    this.opacity = 1,
    this.left,
    this.bottom,
    this.top,
    this.right,
    @required this.pathToImage,
    this.rotate,
    this.color,
  })  : assert(width != null),
        assert(height != null),
        assert(pathToImage != null);

  DynamicTemplateEngine _templateEngine;

  @override
  Widget build(BuildContext context) {
    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);
    return Positioned(
      top: _templateEngine.getHeight(top),
      left: _templateEngine.getWidth(left),
      right: _templateEngine.getWidth(right),
      bottom: _templateEngine.getHeight(bottom),
      child: Opacity(
        opacity: opacity,
        child: rotate == null
            ? buildImage(context)
            : Transform.rotate(
                angle: rotate * pi / 180,
                child: buildImage(context),
              ),
      ),
    );
  }

  Widget buildImage(context) {
    return Container(
      color: color != null ? Colors.red : Colors.transparent,
      child: Image.asset(
        pathToImage,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.high,
        width: _templateEngine.getWidth(width),
        height: _templateEngine.getHeight(height),
      ),
    );
  }
}
