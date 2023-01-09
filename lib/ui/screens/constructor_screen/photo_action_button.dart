import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui.dart';

class PhotoActionButton extends StatefulWidget {
  final int photoNumber;
  final ButtonClass buttonClass;
  final double left;
  final double top;
  final double bottom;
  final double angle;
  final double photoHeight;
  final double photoWidth;

  PhotoActionButton({
    @required this.photoNumber,
    @required this.buttonClass,
    this.top,
    this.bottom,
    this.left,
    this.angle,
    this.photoHeight,
    this.photoWidth,
  })  : assert(photoNumber != null),
        assert(buttonClass != null);

  @override
  _PhotoActionButtonState createState() => _PhotoActionButtonState();
}

class _PhotoActionButtonState extends State<PhotoActionButton> {
  ConstructorBloc _constructorBloc;
  DynamicTemplateEngine _templateEngine;

  @override
  Widget build(BuildContext context) {
    _constructorBloc ??= Provider.of<ConstructorBloc>(context);
    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);

    return StreamBuilder<List>(
      stream: _constructorBloc.getPhotoList,
      initialData: [],
      builder: (context, snapshotPhotoList) {
        if (snapshotPhotoList.data.isNotEmpty)
          return StreamBuilder<List<BehaviorSubject<bool>>>(
            stream: _constructorBloc.getButtonFocusList,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.data.isNotEmpty)
                return StreamBuilder(
                  stream: snapshot.data[widget.photoNumber].stream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: snapshot.data,
                      child: buildButton(snapshotPhotoList.data),
                    );
                  },
                );
              else
                return Container();
            },
          );
        else
          return Container();
      },
    );
  }

  Widget buildButton(List photoList) {
    return StreamBuilder<CustomFile>(
      stream: photoList[widget.photoNumber].stream,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Positioned(
            left: _templateEngine.getWidth(widget.left),
            top: _templateEngine.getHeight(widget.top),
            bottom: _templateEngine.getHeight(widget.bottom),
            child: StreamBuilder<List<BehaviorSubject<PhotoIndex>>>(
              stream: _constructorBloc.getListPhotoIndex,
              initialData: [],
              builder: (context, snapshot) {
                if (snapshot.data.isNotEmpty) {
                  return StreamBuilder<PhotoIndex>(
                    stream: snapshot.data[widget.photoNumber].stream,
                    initialData: PhotoIndex(),
                    builder: (context, snapshot) {
                      return buildOpacity(snapshot);
                    },
                  );
                } else
                  return Container();
              },
            ),
          );
        else
          return Container();
      },
    );
  }

  Widget buildOpacity(AsyncSnapshot snapshot) {
    return Opacity(
      opacity: snapshot.data.borderVisible ? 1 : 0,
      child: widget.buttonClass == ButtonClass.DELETE
          ? GestureDetector(
              onTap: () {
                _constructorBloc
                    .getPhotoCalculationValuesList[widget.photoNumber]
                    .deleteImage(
                  photoNumber: widget.photoNumber,
                );
              },
              child: buildGestureChild(),
            )
          : widget.buttonClass == ButtonClass.ROTATE
              ? buildRotateButton()
              : buildScaleButton(snapshot),
    );
  }

  Widget buildRotateButton() {
    return GestureDetector(
      onPanStart: (DragStartDetails data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .pressRotateStart(
          data: data,
          photoNumber: widget.photoNumber,
          width: widget.photoWidth,
          height: widget.photoHeight,
        );
      },
      onPanEnd: (data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .rotateEnd(
          photoNumber: widget.photoNumber,
        );
      },
      onPanUpdate: (data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .rotateUpdate(
          data: data,
          photoNumber: widget.photoNumber,
        );
      },
      child: buildGestureChild(),
    );
  }

  Widget buildScaleButton(AsyncSnapshot snapshot) {
    return GestureDetector(
      onPanStart: (data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .pressScaleStart(
          photoNumber: widget.photoNumber,
        );
      },
      onPanEnd: (data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .scaleEnd(photoNumber: widget.photoNumber);
      },
      onPanUpdate: (data) {
        _constructorBloc.getPhotoCalculationValuesList[widget.photoNumber]
            .scaleUpdate(
          globalPosition: data.globalPosition,
          firstTapScaleOffset: snapshot.data.firstTapScaleOffset,
          angle: widget.angle,
          photoNumber: widget.photoNumber,
          height: widget.photoHeight,
          width: widget.photoWidth,
        );
      },
      child: buildGestureChild(),
    );
  }

  Widget buildGestureChild() {
    return GestureActionButton(
      buttonClass: widget.buttonClass,
    );
  }
}
