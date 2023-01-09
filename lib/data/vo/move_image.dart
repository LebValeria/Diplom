import 'dart:io';

import 'package:flutter/gestures.dart';

class ScaleAndRotate {
  ///Значения из snapshot
  double scale;
  double scaleX;
  double scaleY;
  double rotate;

  ///Старые значения. Необходимы для корректного рассчета
  double previousScale;
  double previousScaleX;
  double previousScaleY;

  ///Позиция для перемещения
  double top;
  double left;

  ScaleAndRotate({
    this.scale = 1,
    this.scaleX = 1,
    this.scaleY = 1,
    this.rotate = 0,
    this.previousScale = 1,
    this.previousScaleX = 1,
    this.previousScaleY = 1,
    this.top,
    this.left,
  });

  ScaleAndRotate dropToDefault() {
    this.rotate = 0;
    this.scale = 1;
    this.scaleX = 1;
    this.scaleY = 1;
    this.previousScale = 1;
    this.previousScaleX = 1;
    this.previousScaleY = 1;
    this.top = 0;
    this.left = 0;
    return this;
  }

  ScaleAndRotate updateScale(double scale, double scaleX, double scaleY) {
    this.scale = scale;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    return this;
  }

  ScaleAndRotate updateScaleText(
    double scale,
    double scaleX,
    double scaleY,
  ) {
    this.scale = scale * this.previousScale;
    this.scaleX = scaleX * this.previousScaleX;
    this.scaleY = scaleY * this.previousScaleY;
    return this;
  }

  ScaleAndRotate updateRotation(double rotation) {
    this.rotate = rotation;
    return this;
  }

  ScaleAndRotate updatePreviousScale() {
    this.previousScale = this.scale - (1 - this.previousScale);
    this.previousScaleX = this.scaleX - (1 - this.previousScaleX);
    this.previousScaleY = this.scaleY - (1 - this.previousScaleY);
    this.scale = 1;
    this.scaleX = 1;
    this.scaleY = 1;
    return this;
  }

  ScaleAndRotate updatePreviousScaleText() {
    this.previousScale = this.scale;
    this.previousScaleX = this.scaleX;
    this.previousScaleY = this.scaleY;
    return this;
  }

  factory ScaleAndRotate.fromJson(Map<String, dynamic> json) {
    return ScaleAndRotate(
      rotate: json['rotate'],
      scale: json['scale'],
      scaleX: json['scaleX'],
      scaleY: json['scaleY'],
      previousScale: json['previousScale'],
      previousScaleX: json['previousScaleX'],
      previousScaleY: json['previousScaleY'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rotate'] = this.rotate;
    data['scale'] = this.scale;
    data['scaleX'] = this.scaleX;
    data['scaleY'] = this.scaleY;
    data['previousScale'] = this.previousScale;
    data['previousScaleX'] = this.previousScaleX;
    data['previousScaleY'] = this.previousScaleY;
    return data;
  }
}

class PhotoIndex {
  bool borderVisible;

  ///Для смены значений вычета
  bool isLast;
  Offset firstTapScaleOffset;
  Offset delta;
  Offset oldDelta;

  PhotoIndex({
    this.borderVisible = false,
    this.isLast = false,
    this.firstTapScaleOffset,
    this.delta = const Offset(0, 0),
    this.oldDelta = const Offset(0, 0),
  });

  PhotoIndex updateFalseVisible() {
    this.borderVisible = false;
    this.isLast = false;
    return this;
  }

  PhotoIndex updateLastCurrentPhoto() {
    this.borderVisible = true;
    this.isLast = true;
    this.firstTapScaleOffset = null;
    return this;
  }

  PhotoIndex dropToDefault() {
    this.borderVisible = false;
    this.isLast = false;
    this.firstTapScaleOffset = null;
    this.delta = Offset(0, 0);
    this.oldDelta = Offset(0, 0);
    return this;
  }

  factory PhotoIndex.fromJson(Map<String, dynamic> json) {
    return PhotoIndex(
      borderVisible: json['borderVisible'],
      isLast: json['isLast'],
      firstTapScaleOffset: json['firstTapScaleOffset'] == null
          ? null
          : Offset(json['firstTapScaleOffset']['dx'],
              json['firstTapScaleOffset']['dy']),
      delta: Offset(json['delta']['dx'], json['delta']['dy']),
      oldDelta: Offset(json['oldDelta']['dx'], json['oldDelta']['dy']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['borderVisible'] = false;
    data['isLast'] = this.isLast;
    data['firstTapScaleOffset'] = this.firstTapScaleOffset == null
        ? null
        : {
            'dx': this.firstTapScaleOffset.dx,
            'dy': this.firstTapScaleOffset.dy,
          };
    data['delta'] = {
      'dx': this.delta.dx,
      'dy': this.delta.dy,
    };
    data['oldDelta'] = {
      'dx': this.oldDelta.dx,
      'dy': this.oldDelta.dy,
    };
    return data;
  }
}

class CustomFile {
  final File file;
  final int imageHeight;
  final int imageWidth;
  final num relation;

  CustomFile({
    this.file,
    this.imageHeight,
    this.imageWidth,
    this.relation,
  });

  factory CustomFile.fromJson(Map<String, dynamic> json) {
    return CustomFile(
      file: File(json['file']),
      imageHeight: json['imageHeight'],
      imageWidth: json['imageWidth'],
      relation: json['relation'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file.path;
    data['imageHeight'] = this.imageHeight;
    data['imageWidth'] = this.imageWidth;
    data['relation'] = this.relation;
    return data;
  }
}
