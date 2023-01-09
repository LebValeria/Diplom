import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:rxdart/rxdart.dart';

class DragTextBloc extends Bloc {
  final _scaleAndRotateSubject = BehaviorSubject<ScaleAndRotate>.seeded(ScaleAndRotate());

  final _showKeyboard = BehaviorSubject<bool>();

  final _textMaxScrollExtent = BehaviorSubject<double>.seeded(0);

  ///Для выравнивания прыжка в начале изменения зума. Для нормализации к единице
  /// используется первое значение callback изменения зума, которое скипается и
  /// обновления зума не происходит
  ScaleAndRotate constScale;

  Offset startPointOffset;
  Offset endPointOffset;

  Offset startPosition;
  double deltaRotate;
  double deltaRotateSnapshot;

  double diagonal;
  double diagonalX;
  double diagonalY;

  double _height;
  double _width;

  ///Коэффициенты для уравнения прямой по двум точкам по оси X
  double leftA;
  double leftB;
  double leftC;

  ///Коэффициенты для уравнения прямой по двум точкам по оси Y
  double topA;
  double topB;
  double topC;

  Offset deltaDrag;

  var copyKey = RectGetter.createGlobalKey();
  var deleteKey = RectGetter.createGlobalKey();
  var scaleKey = RectGetter.createGlobalKey();
  var rotateKey = RectGetter.createGlobalKey();
  var centerKey = RectGetter.createGlobalKey();
  var dragKey = RectGetter.createGlobalKey();

  DragTextBloc() {
    subjects = [
      _scaleAndRotateSubject,
      _showKeyboard,
      _textMaxScrollExtent,
    ];
  }

  Stream<ScaleAndRotate> get getScaleAndRotate => _scaleAndRotateSubject.stream;

  Stream<double> get getMaxScroll => _textMaxScrollExtent.stream;

  Stream<bool> get getShowKeyboard => _showKeyboard.stream;

  double get height => _height;

  double get width => _width;

  ///Функции для сохранения картинки

  double getSaveMaxScrollPosition() {
    return _textMaxScrollExtent.value;
  }

  ScaleAndRotate getSaveScaleAndRotate() {
    return _scaleAndRotateSubject.value;
  }

  ///endregion

  void updateMaxScroll(double value) {
    _textMaxScrollExtent.add(value);
  }

  void updateShowKeyboard(bool showKeyboard) {
    _showKeyboard.add(showKeyboard);
  }

  void initSize(BuildContext context, double height, double width) {
    _width = Provider.of<DynamicTemplateEngine>(context).getHeight(width);
    _height = Provider.of<DynamicTemplateEngine>(context).getHeight(height);
  }

  void updateScale(double scale, double scaleX, double scaleY) {
    _scaleAndRotateSubject.add(
      _scaleAndRotateSubject.value.updateScaleText(scale, scaleX, scaleY),
    );
  }

  void updatePreviousScale() {
    _scaleAndRotateSubject.add(
      _scaleAndRotateSubject.value.updatePreviousScaleText(),
    );
  }

  void dropScaleToDefault() {
    this.updatePreviousScale();

    constScale = null;
  }

  void _updateRotate(double rotation) {
    _scaleAndRotateSubject.add(
      _scaleAndRotateSubject.value.updateRotation(rotation),
    );
  }

  void initCopy(ScaleAndRotate scaleAndRotate) {
    _scaleAndRotateSubject.add(ScaleAndRotate(
      scale: scaleAndRotate.scale,
      scaleX: scaleAndRotate.scaleX,
      scaleY: scaleAndRotate.scaleY,
      previousScale: scaleAndRotate.previousScale,
      previousScaleX: scaleAndRotate.previousScaleX,
      previousScaleY: scaleAndRotate.previousScaleY,
      rotate: scaleAndRotate.rotate
    ));
    //_updateRotate(scaleAndRotate.rotate);
  }


  void pressRotateStart(BuildContext context, Offset globalPosition) {
    var testRect = RectGetter.getRectFromKey(centerKey);

    startPosition = Offset(testRect.left, testRect.top);

    deltaRotate = Provider.of<ConstructorBloc>(context, listen: false)
        .computeRotation(globalPosition, globalPosition - startPosition);
  }

  void rotateUpdate(BuildContext context, Offset globalPosition) {
    double rotation = Provider.of<ConstructorBloc>(context, listen: false)
        .computeRotation(globalPosition, globalPosition - startPosition);

    rotation -= deltaRotate;
    if (deltaRotateSnapshot == null) {
      deltaRotateSnapshot = _scaleAndRotateSubject.value.rotate - rotation;
      return;
    }
    rotation += deltaRotateSnapshot;
    _updateRotate(rotation);
  }

  void rotateEnd() {
    deltaRotateSnapshot = null;
  }

  void pressScaleStart(data, double scale, double scaleX, double scaleY) {
    var startRect = RectGetter.getRectFromKey(scaleKey);
    var endRect = RectGetter.getRectFromKey(copyKey);
    startPointOffset = Offset(startRect.left, startRect.top);
    endPointOffset = Offset(endRect.left, endRect.top);

    this.calculateCoefficients(scale, scaleX, scaleY);

    diagonal = math.sqrt(
      math.pow(startPointOffset.dx - endPointOffset.dx, 2) +
          math.pow(startPointOffset.dy - endPointOffset.dy, 2),
    );
  }

  void scaleUpdate(data) {
    double scaleX = calculateDistanceToLeft(data.globalPosition);
    double scaleY = calculateDistanceToTop(data.globalPosition);

    double scale = math.sqrt(math.pow((scaleX), 2) + math.pow(scaleY, 2));

    if (constScale == null) {
      ///Первый Callback изспользуется для вычисления дельты между ним и
      ///единицей, чтобы избежать рывка, т.к. палец в центре кнопки не будет
      ///в момент первого срабатывания
      constScale = ScaleAndRotate(
          scale: scale - 1, scaleX: scaleX - 1, scaleY: scaleY - 1);
    } else {
      ///Вычитаем дельту
      scale -= constScale.scale;
      scaleX -= constScale.scaleX;
      scaleY -= constScale.scaleY;
      this.updateScale(scale, scaleX, scaleY);
    }
  }

  void calculateCoefficients(double scale, double scaleX, double scaleY) {
    var rotateRect = RectGetter.getRectFromKey(rotateKey);
    var deleteRect = RectGetter.getRectFromKey(deleteKey);
    var copyRect = RectGetter.getRectFromKey(copyKey);

    topA = deleteRect.top - copyRect.top;
    topB = deleteRect.left - copyRect.left;
    topC = deleteRect.left * copyRect.top - copyRect.left * deleteRect.top;

    leftA = copyRect.top - rotateRect.top;
    leftB = copyRect.left - rotateRect.left;
    leftC = copyRect.left * rotateRect.top - rotateRect.left * copyRect.top;

    diagonalX = width * scaleX;
    diagonalY = height * scaleY;
  }

  ///Рассчитывает расстояние до прямой сверху
  double calculateDistanceToTop(Offset currentPosition) {
    double distance;
    distance =
        (topA * currentPosition.dx - topB * currentPosition.dy + topC).abs() /
            math.sqrt(
              math.pow(topA, 2) + math.pow(topB, 2),
            ) /
            diagonalY;
    return distance;
  }

  ///Рассчитывает расстояние до прямой слева
  double calculateDistanceToLeft(Offset currentPosition) {
    double distance;
    distance = (leftA * currentPosition.dx - leftB * currentPosition.dy + leftC)
            .abs() /
        math.sqrt(
          math.pow(leftA, 2) + math.pow(leftB, 2),
        ) /
        diagonalX;
    return distance;
  }

  void initDelta(BuildContext templateContext) {
    RenderBox renderBox = templateContext.findRenderObject();
    var local =
        renderBox.globalToLocal(RectGetter.getRectFromKey(centerKey).topLeft);
    deltaDrag = local;
  }

  void updatePosition(BuildContext context, BuildContext templateContext,
      DragUpdateDetails data, int index) {
    if (deltaDrag == null) {
      RenderBox renderBox = templateContext.findRenderObject();
      var local =
          renderBox.globalToLocal(RectGetter.getRectFromKey(dragKey).topLeft);
      deltaDrag = renderBox.globalToLocal(data.globalPosition) - local;
      return;
    }
    RenderBox renderBox = templateContext.findRenderObject();
    var local = renderBox.globalToLocal(data.globalPosition - deltaDrag);
    Provider.of<ConstructorBloc>(context).updatePositions(local, index);
  }

  void endDrag() {
    deltaDrag = null;
  }

  void fromJson(ScaleAndRotate scaleAndRotate, double maxScroll) {
    this.initCopy(scaleAndRotate);

    _textMaxScrollExtent.add(maxScroll);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scaleAndRotate'] = _scaleAndRotateSubject.value.toJson();
    data['maxScroll'] = _textMaxScrollExtent.value;
    return data;
  }
}
