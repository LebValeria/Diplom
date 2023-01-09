import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';

class PhotoCalculationValues {
  final ConstructorBloc constructorBloc;

  PhotoCalculationValues({
    @required this.constructorBloc,
  }) : assert(constructorBloc != null);

  Offset startPosition;

  double deltaRotate;
  double deltaRotateSnapshot;

  Offset dragStartPosition;

  ///Расстояния до конечных точек
  double diagonal;
  double diagonalX;
  double diagonalY;

  /// Конечные точки масштабов
  Offset end;
  Offset endX;
  Offset endY;
  Offset difference;

  ///Коэффициенты для уравнения прямой по двум точкам по оси X, используется, если прямоугольник наклонен
  double leftA;
  double leftB;
  double leftC;

  ///Коэффициенты для уравнения прямой по двум точкам по оси Y, используется, если прямоугольник наклонен
  double topA;
  double topB;
  double topC;

  void updateDragPhoto({int photoNumber, Offset localPosition}) {
    if (dragStartPosition == null) {
      dragStartPosition = localPosition;
      return;
    }

    Offset delta = localPosition - dragStartPosition;
    constructorBloc.updatePhotoPosition(photoNumber, delta);
  }

  void endDragPhoto({int photoNumber}) {
    dragStartPosition = null;

    constructorBloc.updateOldPhotoPosition(
      photoNumber,
    );
  }

  void deleteImage({int photoNumber}) {
    constructorBloc.deleteImage(photoNumber);
    constructorBloc.dropPhotoScaleAndRotateToDefault(photoNumber);
    constructorBloc.dropPhotoPositionToDefault(photoNumber);
  }

  void pressRotateStart({
    DragStartDetails data,
    int photoNumber,
    double height,
    double width,
  }) {
    if (startPosition == null)
      calculateStartPositionRotate(data.globalPosition, height, width);

    deltaRotate = constructorBloc.computeRotation(
        data.globalPosition, data.globalPosition - startPosition);
    constructorBloc.updateFalseVisible(photoNumber);
  }

  void rotateUpdate({DragUpdateDetails data, int photoNumber}) {
    double rotation = constructorBloc.computeRotation(
        data.globalPosition, data.globalPosition - startPosition);

    rotation -= deltaRotate;
    if (deltaRotateSnapshot == null) {
      deltaRotateSnapshot = constructorBloc.getSnapshotRotate(photoNumber) - rotation;
      return;
    }

    rotation += deltaRotateSnapshot;
    constructorBloc.updateRotate(rotation, photoNumber);
  }

  void rotateEnd({int photoNumber}) {
    deltaRotateSnapshot = null;
    constructorBloc.updateLastCurrentPhoto(photoNumber);
  }

  void calculateStartPositionRotate(
      Offset currentTap, double height, double width) {
    double x = currentTap.dx;
    double y = currentTap.dy;

    startPosition = Offset(x + width / 2, y - height / 2);
  }

  void pressScaleStart({int photoNumber}) {
    constructorBloc.updateFalseVisible(photoNumber);
  }

  void scaleUpdate({
    Offset globalPosition,
    Offset firstTapScaleOffset,
    double angle,
    int photoNumber,
    double height,
    double width,
  }) {
    if (firstTapScaleOffset == null) {
      calculateValues(
        position: globalPosition,
        haveAngle: angle != null,
        angle: angle,
        height: height,
        width: width,
      );
      constructorBloc.updateFirstTapScale(globalPosition, photoNumber);
      return;
    }

    ///Текущее расстояние по диагонали
    double scale = calculateDistance(currentPosition: globalPosition, end: end);

    ///Текущее расстояние для изменения размера по X
    double xScale =
        calculateDistanceToLeft(currentPosition: globalPosition, angle: angle);

    ///Текущее расстояние для изменения размера по Y
    double yScale =
        calculateDistanceToTop(currentPosition: globalPosition, angle: angle);

    constructorBloc.updateScale(scale, xScale, yScale, photoNumber);
  }

  void scaleEnd({int photoNumber}) {
    constructorBloc.updateLastCurrentPhoto(photoNumber);
  }

  ///Ищет диагональную точку для нулевого зума и считает диагональ
  ///(нужна для принятия ее как единицы масштаба).
  ///Левую верхнюю точку ищем по двум трегольникам
  void calculateValues(
      {Offset position,
      bool haveAngle,
      double angle,
      double height,
      double width}) {
    if (haveAngle) {
      double rad = angle * math.pi / 180;

      ///Верхняя правая точка прямоугольника
      double ex;
      double ey;

      ///Левая верхняя точка прямоугольника
      double zx;
      double zy;

      ///Левая нижняя точка прямоугольника
      double mx;
      double my;

      ///Синус угла
      double sinA = math.sin(rad.abs());

      ///Косинус угла
      double cosA = math.cos(rad.abs());

      ///В зависимости от угла значения ситаются по разному
      if (angle.isNegative) {
        ex = position.dx - height * sinA;
        ey = position.dy - height * cosA;

        zx = ex - width * cosA;
        zy = ey + width * sinA;

        mx = zx + width * sinA;
        my = zy + width * cosA;
      } else {
        ex = position.dx + height * sinA;
        ey = position.dy - height * cosA;

        zx = ex - width * cosA;
        zy = ey - width * sinA;

        mx = zx - width * sinA;
        my = zy - width * cosA;
      }

      end = Offset(zx, zy);
      endX = Offset(ex, ey);
      endY = Offset(mx, my);

      //z 1 e 2
      topA = ey - zy;
      topB = ex - zx;
      topC = ex * zy - zx * ey;
      //z 2 m 1
      leftA = zy - my;
      leftB = zx - mx;
      leftC = zx * my - mx * zy;
    } else {
      end = Offset(position.dx - width, position.dy - height);
      endX = Offset(position.dx - width, position.dy);
      endY = Offset(position.dx, position.dy - height);
    }

    diagonal = math.sqrt(width * width + height * height);
    diagonalX = width;
    diagonalY = height;
  }

  ///Инициализируем [Offset] разницу для вычитания с самым первым нажатием
  ///для избежания скачка из-за разницы в положении пальца на кнопке
  void calculateDifference(Offset startPosition, Offset firstScaleTap) {
    difference = Offset(firstScaleTap.dx - startPosition.dx,
        firstScaleTap.dy - startPosition.dy);
  }

  double calculateDistance({
    Offset currentPosition,
    Offset end,
  }) {
    double distance = math.sqrt(
      (currentPosition.dx - end.dx) * (currentPosition.dx - end.dx) +
          (currentPosition.dy - end.dy) * (currentPosition.dy - end.dy),
    );
    return (distance / diagonal).abs();
  }

  ///Рассчитывает расстояние до прямой сверху
  double calculateDistanceToTop({
    Offset currentPosition,
    double angle,
  }) {
    double distance;
    if (angle != null) {
      distance =
          (topA * currentPosition.dx - topB * currentPosition.dy + topC).abs() /
              math.sqrt(
                math.pow(topA, 2) + math.pow(topB, 2),
              ) /
              diagonalY;
    } else {
      distance = (currentPosition.dy - end.dy) / diagonalY;
    }
    return distance;
  }

  ///Рассчитывает расстояние до прямой слева
  double calculateDistanceToLeft({
    Offset currentPosition,
    double angle,
  }) {
    double distance;
    if (angle != null) {
      distance =
          (leftA * currentPosition.dx - leftB * currentPosition.dy + leftC)
                  .abs() /
              math.sqrt(
                math.pow(leftA, 2) + math.pow(leftB, 2),
              ) /
              diagonalX;
    } else {
      distance = (currentPosition.dx - end.dx) / diagonalX;
    }
    return distance;
  }
}
