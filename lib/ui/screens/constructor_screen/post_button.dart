import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui.dart';

class PostButton extends StatefulWidget {
  final double photoHeight;
  final double photoWidth;
  final bool transparent;
  final int photoNumber;
  final double plusPaddingTop;
  final double plusPaddingLeft;
  final double whiteSize;
  final double plusSize;
  final double textSize;
  final double textRightPadding;
  final double textBottomPadding;

  PostButton({
    @required this.photoHeight,
    @required this.photoWidth,
    this.transparent = false,
    @required this.photoNumber,
    @required this.plusPaddingTop,
    this.plusPaddingLeft = 0,
    this.plusSize,
    this.whiteSize,
    @required this.textSize,
    this.textRightPadding = 0,
    this.textBottomPadding = 0,
  })  : assert(photoHeight != null),
        assert(photoWidth != null),
        assert(photoNumber != null),
        assert(plusPaddingTop != null),
        assert(textSize != null);

  @override
  _PostButtonState createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  ///Нужно для того, чтобы начальное значение отрисовки после нажатия не менялось
  double _previousScale;
  CustomFile _image;

  DynamicTemplateEngine _templateEngine;
  ConstructorBloc _constructorBloc;
  num multiplyIndexWidth = 1;
  num multiplyIndexHeight = 1;
  BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    _constructorBloc ??= Provider.of<ConstructorBloc>(context);
    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);

    return StreamBuilder<CustomFile>(
      stream: _constructorBloc.getStreamPhotoId(widget.photoNumber),
      builder: (context, snapshot) {
        _image = snapshot.data;
        if (Provider.of<Key>(context) == Key('save'))
          _image = _constructorBloc.getSaveImageFromIndex(widget.photoNumber);
        return GestureDetector(
          onTap: () => _image != null && !Provider.of<bool>(context)
              ? _constructorBloc.changeButtonFocus(widget.photoNumber, true)
              : null,
          child: StreamBuilder<List>(
            stream: _constructorBloc.getPhotoList,
            initialData: [],
            builder: (context, snapshot) {
              var snap = snapshot.data;
              if (Provider.of<Key>(context) == Key('save'))
                snap = _constructorBloc.getSavePhotoList();

              if (snap.isNotEmpty)
                return buildStreamCurrentPhoto();
              else
                return buildPhotoContainer(PhotoIndex());
            },
          ),
        );
      },
    );
  }

  Widget buildStreamCurrentPhoto() {
    return StreamBuilder<List<BehaviorSubject<PhotoIndex>>>(
      stream: _constructorBloc.getListPhotoIndex,
      initialData: [],
      builder: (context, snapshot) {
        var snap = snapshot.data;
        if (Provider.of<Key>(context) == Key('save'))
          snap = _constructorBloc.getSaveListPhotoIndex();

        if (snap.isNotEmpty) {
          return StreamBuilder<PhotoIndex>(
            stream: snap[widget.photoNumber].stream,
            initialData: PhotoIndex(),
            builder: (context, snapshot) {
              var snap = snapshot.data;
              if (Provider.of<Key>(context) == Key('save'))
                snap = _constructorBloc
                    .getSavePhotoIndexFromIndex(widget.photoNumber);
              return Stack(
                children: <Widget>[
                  Container(
                    width: _templateEngine.getWidth(widget.photoWidth),
                    height: _templateEngine.getHeight(widget.photoHeight),
                    color: Color(0xffe2e2e2),
                  ),
                  _image == null
                      ? buildEmptyImageForeground()
                      : buildFutureImage(snap),
                  Visibility(
                    visible: _image != null,
                    child: Container(
                      width: _templateEngine.getWidth(widget.photoWidth),
                      height: _templateEngine.getHeight(widget.photoHeight),
                      decoration: widget.transparent
                          ? BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(249, 225, 219, 0.69),
                                width: _templateEngine.getWidth(18),
                              ),
                            )
                          : null,
                    ),
                  ),
                  Visibility(
                    visible: snap.borderVisible,
                    child: buildDotterBorder(),
                  ),
                ],
              );
            },
          );
        } else
          return Container();
      },
    );
  }

  Widget buildFutureImage(PhotoIndex snap) {
    double width = 0;
    double height = 0;
    if (_image.imageHeight > _image.imageWidth) {
      num K = 1;
      if (widget.photoWidth * _image.relation <
          widget.photoHeight) {
        K = widget.photoHeight / (widget.photoWidth * _image.relation);
      }

      multiplyIndexWidth = K;
      multiplyIndexHeight = K * _image.relation;
      if (widget.photoWidth > widget.photoHeight)
        multiplyIndexHeight *= widget.photoWidth / widget.photoHeight;

      height = (_templateEngine.getWidth(widget.photoHeight) *
              multiplyIndexHeight /
              2) -
          (_templateEngine.getWidth(widget.photoHeight) / 2);
      boxFit = BoxFit.fitWidth;
    } else {
      multiplyIndexHeight = 1;
      if (widget.photoWidth > widget.photoHeight) {
        multiplyIndexWidth = _image.imageWidth / _image.imageHeight;
        boxFit = BoxFit.fitWidth;
      } else {
        multiplyIndexWidth = (_image.imageWidth / _image.imageHeight) *
            widget.photoHeight /
            widget.photoWidth;
        boxFit = BoxFit.fitHeight;
      }
    }
    width =
        (_templateEngine.getWidth(widget.photoWidth) * multiplyIndexWidth / 2) -
            (_templateEngine.getWidth(widget.photoWidth) / 2);
    return Positioned(
      top: snap.delta.dy *
              (_templateEngine.height / _templateEngine.engineHeight) -
          height.toDouble(),
      left: snap.delta.dx *
              (_templateEngine.height / _templateEngine.engineHeight) -
          width.toDouble(),
      child: buildPhotoContainer(snap),
    );
  }

  Widget buildDotterBorder() {
    return DottedBorder(
      padding: EdgeInsets.zero,
      strokeCap: StrokeCap.round,
      color: Color(0xff838383),
      strokeWidth: 1,
      dashPattern: [16, 16, 16, 16],
      child: Container(
        width: _templateEngine.getWidth(widget.photoWidth),
        height: _templateEngine.getHeight(widget.photoHeight),
        child: GestureDetector(
          onPanUpdate: (data) {
            Provider.of<ConstructorBloc>(context, listen: false)
                .getPhotoCalculationValuesList[widget.photoNumber]
                .updateDragPhoto(
                  photoNumber: widget.photoNumber,
                  localPosition: data.localPosition,
                );
          },
          onPanEnd: (data) {
            Provider.of<ConstructorBloc>(context, listen: false)
                .getPhotoCalculationValuesList[widget.photoNumber]
                .endDragPhoto(
                  photoNumber: widget.photoNumber,
                );
          },
        ),
      ),
    );
  }

  Widget buildPhotoContainer(PhotoIndex photoIndex) {
    return Container(
      width: _templateEngine.getWidth(widget.photoWidth) * multiplyIndexWidth,
      height:
          _templateEngine.getWidth(widget.photoHeight) * multiplyIndexHeight,
      child: Center(
        child: StreamBuilder<List<BehaviorSubject<ScaleAndRotate>>>(
          stream: _constructorBloc.getListScaleAndRotate,
          initialData: [],
          builder: (context, snapshot) {
            var snap = snapshot.data;
            if (Provider.of<Key>(context) == Key('save'))
              snap = _constructorBloc.getSaveListScaleAndRotate();

            if (snap.isNotEmpty)
              return StreamBuilder<ScaleAndRotate>(
                stream: snap[widget.photoNumber].stream,
                builder: (context, snapshot) {
                  var snap = snapshot.data;
                  if (Provider.of<Key>(context) == Key('save'))
                    snap = _constructorBloc
                        .getSaveScaleAndRotateFromIndex(widget.photoNumber);

                  if (snap != null)
                    return buildImage(photoIndex, snap);
                  else
                    return Container();
                },
              );
            else
              return Container();
          },
        ),
      ),
    );
  }

  Widget buildImage(PhotoIndex photoIndex, ScaleAndRotate scaleAndRotate) {
    bool useWidgetValue = photoIndex.borderVisible || photoIndex.isLast;
    bool _isUpdate = false;
    if (photoIndex.isLast && !Provider.of<bool>(context)) {
      if (scaleAndRotate.scale != _previousScale) {
        _isUpdate = true;
        _previousScale = scaleAndRotate.scale;
        _constructorBloc.updatePreviousScale(widget.photoNumber);
      }
    }
    //double finalScale;
    double finalScaleX;
    double finalScaleY;
    //snapshot.data.scale == previousScale нужно чтобы не было прыжка зума при ротейте, т.к. значение зума не меняется
    if ((scaleAndRotate.scale == scaleAndRotate.previousScale ||
            scaleAndRotate.scale == _previousScale ||
            useWidgetValue) &&
        !_isUpdate) {
      // finalScale = snapshot.data.previousScale;
      finalScaleX = scaleAndRotate.previousScaleX;
      finalScaleY = scaleAndRotate.previousScaleY;
    } else {
      // finalScale = snapshot.data.scale - (1 - snapshot.data.previousScale);
      finalScaleX = scaleAndRotate.scaleX - (1 - scaleAndRotate.previousScaleX);
      finalScaleY = scaleAndRotate.scaleY - (1 - scaleAndRotate.previousScaleY);
    }
    return Container(
      width: _templateEngine.getWidth(widget.photoWidth) * multiplyIndexWidth,
      height:
          _templateEngine.getWidth(widget.photoHeight) * multiplyIndexHeight,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          finalScaleX - (1 - finalScaleY),
          finalScaleY - (1 - finalScaleX),
          1,
        ),
        child: Transform.rotate(
          angle: scaleAndRotate.rotate,
          alignment: Alignment.center,
          child: Image.file(
            _image.file,
            fit: boxFit,
            filterQuality: FilterQuality.high,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  Widget buildEmptyImageForeground() {
    return Container(
      width: _templateEngine.getWidth(widget.photoWidth),
      height: _templateEngine.getHeight(widget.photoHeight),
      decoration: widget.transparent
          ? BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(249, 225, 219, 0.69),
                width: _templateEngine.getWidth(18),
              ),
              //color: Color(0xffE5E5E5),
            )
          : null,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _templateEngine.getHeight(widget.plusPaddingTop),
            left: _templateEngine.getWidth(widget.plusPaddingLeft),
            child: GestureDetector(
              onTap: () => Provider.of<ConstructorBloc>(context, listen: false)
                  .pickImageId(widget.photoNumber),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                width: _templateEngine.getWidth(widget.whiteSize),
                height: _templateEngine.getWidth(widget.whiteSize),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/plus.svg',
                    width: _templateEngine.getWidth(widget.plusSize),
                    height: _templateEngine.getWidth(widget.plusSize),
                    color: AppColors.pink,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: _templateEngine.getWidth(widget.textRightPadding),
            bottom: _templateEngine.getHeight(widget.textBottomPadding),
            child: Text(
              (widget.photoNumber + 1).toString(),
              style:
                  AppTypography.photoNumber.copyWith(fontSize: widget.textSize),
            ),
          ),
        ],
      ),
    );
  }
}
