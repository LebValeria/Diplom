import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../ui.dart';

class DraggableTextField extends StatefulWidget {
  final FieldItem fieldItem;
  final int index;
  final ConstructorBloc constructorBloc;
  final bool isPreview;
  final BuildContext templateContext;

  DraggableTextField({
    @required this.fieldItem,
    @required this.index,
    this.constructorBloc,
    this.isPreview,
    this.templateContext,
  })  : assert(fieldItem != null),
        assert(index != null);

  @override
  _DraggableTextFieldState createState() => _DraggableTextFieldState();
}

class _DraggableTextFieldState extends State<DraggableTextField> {
  double _rotate;

  double finalScale;
  double finalScaleX;
  double finalScaleY;

  ///Во время ротейта или зума, чтобы логика кнопок работала
  bool buttonOpacity = true;

  ///Видимость кнопок управления
  bool buttonVisibly = true;

  StreamSubscription _subscription;

  KeyboardVisibilityNotification _keyboardVisibility;
  int _keyboardVisibilitySubscriberId;

  ScrollController scrollController;
  double maxScrollPosition = 0;
  double fontSize = 0;

  GlobalKey key = GlobalKey();

  DynamicTemplateEngine _templateEngine;

  @override
  void initState() {
    if (!widget.isPreview) if (widget.fieldItem.scaleAndRotate != null)
      widget.fieldItem.dragTextBloc.initCopy(widget.fieldItem.scaleAndRotate);

    widget.constructorBloc.requestLastFocus(widget.index);

    _subscription = widget.constructorBloc.getButtonFocusList.listen(
      (data) {
        int photoCount = widget.constructorBloc.getPhotoCount;
        if (data.length >= widget.index + 1 + photoCount) {
          data[widget.index + photoCount].listen(
            (item) {
              if (mounted)
                setState(() {
                  buttonVisibly = item;
                });
            },
          );
        }
      },
    );

    _keyboardVisibility = KeyboardVisibilityNotification();
    _keyboardVisibilitySubscriberId =
        _keyboardVisibility.addNewListener(onChange: (value) {
      widget.fieldItem.dragTextBloc.updateShowKeyboard(value);
    });

    scrollController = ScrollController(initialScrollOffset: 0);

    scrollController.addListener(
      () {
        widget.fieldItem.dragTextBloc
            .updateMaxScroll(scrollController.position.maxScrollExtent);
      },
    );

    super.initState();
  }

  /*  @override
  void dispose() {
    widget.fieldItem.dragTextBloc.dispose();
    _subscription.cancel();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    _keyboardVisibility.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    widget.fieldItem.dragTextBloc.initSize(
      context,
      widget.fieldItem.textData.value.textObjectHeight,
      widget.fieldItem.textData.value.textObjectWidth,
    );

    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);

    return StreamBuilder<TextData>(
      stream: widget.fieldItem.textData.stream,
      builder: (context, snapshot) {
        var snap = snapshot.data;
        if (Provider.of<Key>(context) == Key('save'))
          snap = widget.fieldItem.textData.value;
        if (snap != null) {
          TextData textData = snap;
          return buildDrag(textData);
        } else
          return Container();
      },
    );
  }

  Widget buildDrag(TextData textData) {
    return Positioned(
      left: widget.isPreview
          ? textData.offset.dx *
              (_templateEngine.getMainHeight / _templateEngine.engineHeight)
          : textData.offset.dx,
      top: widget.isPreview
          ? textData.offset.dy *
              (_templateEngine.getMainHeight / _templateEngine.engineHeight)
          : textData.offset.dy,
      child: RectGetter(
        key: widget.isPreview
            ? RectGetter.createGlobalKey()
            : widget.fieldItem.dragTextBloc.dragKey,
        child: Visibility(
          visible: textData.visible,
          child: StreamBuilder<double>(
            stream: widget.fieldItem.dragTextBloc.getMaxScroll,
            initialData: 0,
            builder: (context, snapshot) {
              var snap = snapshot.data;
              if (Provider.of<Key>(context) == Key('save'))
                snap = widget.fieldItem.dragTextBloc.getSaveMaxScrollPosition();

              maxScrollPosition = snap;
              return StreamBuilder<ScaleAndRotate>(
                stream: widget.fieldItem.dragTextBloc.getScaleAndRotate,
                builder: (context, snapshot) {
                  var snap = snapshot.data;
                  if (Provider.of<Key>(context) == Key('save'))
                    snap =
                        widget.fieldItem.dragTextBloc.getSaveScaleAndRotate();
                  if (snap != null) {
                    finalScale = snap.scale;
                    finalScaleX = snap.scaleX;
                    finalScaleY = snap.scaleY;
                    _rotate = snap.rotate;
                    fontSize = textData.fontSize * finalScaleY;
                    if (widget.isPreview)
                      fontSize = fontSize *
                          (_templateEngine.getMainHeight /
                              _templateEngine.engineHeight);
                    return Transform.rotate(
                      angle: _rotate,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: _templateEngine.getWidth(48),
                            left: _templateEngine.getWidth(62),
                            right: _templateEngine.getWidth(48),
                            child: Container(
                              width: (_templateEngine
                                          .getHeight(textData.textObjectWidth) *
                                      finalScaleX)
                                  .abs(),
                              height: (_templateEngine.getHeight(
                                              textData.textObjectHeight) *
                                          finalScaleY)
                                      .abs() +
                                  _templateEngine.getHeight(20),
                              child: TextField(
                                key: key,
                                scrollController: scrollController,
                                style: textData.textStyle.copyWith(
                                  fontSize: fontSize,
                                  color: Colors.transparent,
                                ),
                                readOnly: false,
                                enabled: false,
                                textAlign: textData.textAlign,
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: 'Begin Typing',
                                  isDense: true,
                                  hintMaxLines: null,
                                  hintStyle: textData.textStyle.copyWith(
                                    fontSize: fontSize,
                                    color: Colors.transparent,
                                  ),
                                ),
                                controller: textData.controller,
                                maxLines: null,
                              ),
                            ),
                          ),
                          if (Provider.of<bool>(context) &&
                              Provider.of<Key>(context) != Key('save'))
                            buildFeedback(textData, snap)
                          else
                            buildDragItem(textData, snap)
                        ],
                      ),
                    );
                  } else
                    return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildDragItem(TextData textData, ScaleAndRotate scaleAndRotate) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              top: _templateEngine.getWidth(48),
              left: _templateEngine.getWidth(48),
              right: _templateEngine.getWidth(48),
              bottom: _templateEngine.getHeight(48),
              child: Container(
                width: _templateEngine.getHeight(textData.textObjectWidth) *
                    finalScaleX.abs(),
                height: _templateEngine.getHeight(textData.textObjectHeight) *
                        finalScaleY.abs() +
                    maxScrollPosition +
                    _templateEngine.getHeight(20),
                color: Colors.transparent,
                margin: EdgeInsets.zero,
                child: DottedBorder(
                  padding: EdgeInsets.zero,
                  strokeCap: StrokeCap.round,
                  color: buttonVisibly
                      ? Provider.of<Key>(context) != Key('save')
                          ? Color(0xff838383)
                          : Colors.transparent
                      : Colors.transparent,
                  strokeWidth: 1,
                  dashPattern: [16, 16, 16, 16],
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _templateEngine.getWidth(20),
                    ),
                    child: buildTextField(textData),
                  ),
                ),
              ),
            ),
            Provider.of<Key>(context) != Key('save')
                ? Positioned(
                    left: widget.fieldItem.dragTextBloc.width / 2,
                    top: widget.fieldItem.dragTextBloc.height / 2,
                    child: RectGetter(
                      key: widget.fieldItem.dragTextBloc.centerKey,
                      child: Container(
                        width: 1,
                        height: 1,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                : Container(),
            Container(
              width: widget.fieldItem.dragTextBloc.width * finalScaleX.abs(),
              height: widget.fieldItem.dragTextBloc.height * finalScaleY.abs() +
                  maxScrollPosition +
                  _templateEngine.getHeight(20),
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails data) {
                  widget.fieldItem.dragTextBloc.updatePosition(
                      context, widget.templateContext, data, widget.index);
                },
                onPanEnd: (data) {
                  widget.fieldItem.dragTextBloc.endDrag();
                },
                onTap: () {
                  if (!widget.isPreview)
                    Provider.of<ConstructorBloc>(context)
                        .changeButtonFocus(widget.index, false);
                },
              ),
            ),
          ],
        ),
        // buildCopyButton(textData, scaleAndRotate),
        buildDeleteButton(),
        // buildScaleButton(scaleAndRotate),
        // buildRotateButton(),
      ],
    );
  }

  Widget buildFeedback(TextData textData, ScaleAndRotate scaleAndRotate) {
    return Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: _rotate,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              width: widget.fieldItem.dragTextBloc.width * finalScaleX,
              height: widget.fieldItem.dragTextBloc.height * finalScaleY +
                  maxScrollPosition +
                  _templateEngine.getHeight(20),
              margin: EdgeInsets.zero,
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: widget.fieldItem.dragTextBloc.width * finalScaleX,
                  height: widget.fieldItem.dragTextBloc.height * finalScaleY +
                      maxScrollPosition +
                      _templateEngine.getHeight(20),
                ),
                Positioned(
                  top: _templateEngine.getWidth(48),
                  left: _templateEngine.getWidth(48),
                  right: _templateEngine.getWidth(48),
                  bottom: _templateEngine.getHeight(48),
                  child: GestureDetector(
                    onTap: () => !widget.isPreview
                        ? Provider.of<ConstructorBloc>(context)
                            .changeButtonFocus(widget.index, false)
                        : null,
                    child: Container(
                      width: _templateEngine.getHeight(
                        widget.fieldItem.textData.value.textObjectWidth,
                      ),
                      height: _templateEngine.getHeight(
                        widget.fieldItem.textData.value.textObjectHeight,
                      ),
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      child: DottedBorder(
                        padding: EdgeInsets.zero,
                        strokeCap: StrokeCap.round,
                        color: buttonVisibly
                            ? Color(0xff838383)
                            : Colors.transparent,
                        strokeWidth: 1,
                        dashPattern: [16, 16, 16, 16],
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: _templateEngine.getWidth(20),
                          ),
                          child: buildTextField(textData),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // buildCopyButton(textData, scaleAndRotate),
            buildDeleteButton(),
            // buildScaleButton(scaleAndRotate),
            // buildRotateButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextData textData) {
    return Transform.rotate(
      angle: (widget.isPreview && Provider.of<Key>(context) != Key('save'))
          ? -_rotate
          : 0,
      child: StreamBuilder<bool>(
        stream: widget.fieldItem.dragTextBloc.getShowKeyboard,
        initialData: false,
        builder: (context, snapshotKeyboard) {
          return StreamBuilder<int>(
            stream: widget.constructorBloc.getActualTextFieldIndex,
            initialData: widget.index,
            builder: (context, snapshot) {
              return TextField(
                cursorColor: AppColors.black,
                textDirection: TextDirection.ltr,
                strutStyle: StrutStyle(
                  forceStrutHeight: false,
                ),
                scrollPhysics: NeverScrollableScrollPhysics(),
                textAlign: textData.textAlign,
                style: textData.textStyle.copyWith(
                  fontSize: fontSize,
                  color: textData.color,
                ),
                onTap: () {
                  if (!widget.isPreview) {
                    if (buttonVisibly) {
                      Provider.of<ConstructorBloc>(context)
                          .updateActualIndex
                          .add(widget.index);
                    } else {
                      Provider.of<ConstructorBloc>(context)
                          .changeButtonFocus(widget.index, false);

                      ///Для закрытия плашки над клавиатурой после нажатия на само текстовое поле (скрытые кнопки были)
                      textData.focusNode.unfocus();
                    }
                  }
                },
                readOnly: !(buttonVisibly && snapshot.data == widget.index),
                enabled: !widget.isPreview,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Begin Typing',
                  isDense: true,
                  hintMaxLines: null,
                  hintStyle: textData.textStyle.copyWith(
                    fontSize: fontSize,
                    color: buttonVisibly &&
                            snapshot.data == widget.index &&
                            snapshotKeyboard.data
                        ? Color(0xff9E9E9E)
                        : textData.color,
                  ),
                ),
                controller: textData.controller,
                maxLines: null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(150),
                ],
                onEditingComplete: () {
                  print('editing complete');
                  textData.focusNode.unfocus();
                },
                focusNode: widget.isPreview ? FocusNode() : textData.focusNode,
              );
            },
          );
        },
      ),
    );
  }

  Widget buildCopyButton(TextData textData, ScaleAndRotate scaleAndRotate) {
    return Positioned(
      top: 0,
      left: 0,
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: buttonVisibly,
            child: Opacity(
              opacity: buttonOpacity ? 1 : 0,
              child: GestureDetector(
                onTap: () {
                  Provider.of<ConstructorBloc>(context).addCopyTextField(
                    textData,
                    scaleAndRotate,
                    widget.fieldItem.styleData.value,
                  );
                },
                child: buildGestureActionButton(ButtonClass.COPY),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: Visibility(
        visible: buttonVisibly,
        child: Opacity(
          opacity: buttonOpacity ? 1 : 0,
          child: GestureDetector(
            onDoubleTap: () {
              Provider.of<ConstructorBloc>(context, listen: false)
                  .updateTextFieldVisibly(widget.index);
            },
            child: buildGestureActionButton(ButtonClass.DELETE),
          ),
        ),
      ),
    );
  }

  Widget buildScaleButton(ScaleAndRotate scaleAndRotate) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Visibility(
        visible: buttonVisibly,
        child: Opacity(
          opacity: buttonOpacity ? 1 : 0,
          child: GestureDetector(
            onPanStart: (e) {
              widget.fieldItem.dragTextBloc.pressScaleStart(
                e,
                scaleAndRotate.previousScale,
                scaleAndRotate.previousScaleX,
                scaleAndRotate.previousScaleY,
              );
              setState(() {
                buttonOpacity = false;
              });
            },
            onPanUpdate: (e) {
              widget.fieldItem.dragTextBloc.scaleUpdate(e);
            },
            onPanEnd: (e) {
              widget.fieldItem.dragTextBloc.dropScaleToDefault();
              setState(() {
                buttonOpacity = true;
              });
            },
            child: buildGestureActionButton(ButtonClass.SCALE),
          ),
        ),
      ),
    );
  }

  Widget buildRotateButton() {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Visibility(
        visible: buttonVisibly,
        child: Opacity(
          opacity: buttonOpacity ? 1 : 0,
          child: GestureDetector(
            onPanStart: (data) {
              widget.fieldItem.dragTextBloc
                  .pressRotateStart(context, data.globalPosition);
              setState(() {
                buttonOpacity = false;
              });
            },
            onPanEnd: (data) {
              setState(() {
                buttonOpacity = true;
              });
              widget.fieldItem.dragTextBloc.rotateEnd();
            },
            onPanUpdate: (e) {
              widget.fieldItem.dragTextBloc
                  .rotateUpdate(context, e.globalPosition);
            },
            child: buildGestureActionButton(ButtonClass.ROTATE),
          ),
        ),
      ),
    );
  }

  Widget buildGestureActionButton(ButtonClass buttonClass) {
    if (Provider.of<Key>(context) == Key('save')) return Container();
    return Transform.rotate(
      angle: -_rotate,
      alignment: Alignment.center,
      child: Container(
        width: _templateEngine.getWidth(96),
        height: _templateEngine.getWidth(96),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xffbfbfbf),
                offset: Offset(0, 0),
                blurRadius: 4,
              )
            ]),
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: _templateEngine.getWidth(24),
                top: _templateEngine.getHeight(24),
                child: RectGetter(
                  key: buttonClass == ButtonClass.SCALE
                      ? widget.fieldItem.dragTextBloc.scaleKey
                      : buttonClass == ButtonClass.COPY
                          ? widget.fieldItem.dragTextBloc.copyKey
                          : buttonClass == ButtonClass.ROTATE
                              ? widget.fieldItem.dragTextBloc.rotateKey
                              : widget.fieldItem.dragTextBloc.deleteKey,
                  child: Container(
                    width: 1,
                    height: 1,
                  ),
                ),
              ),
              SvgPicture.asset(
                buttonClass == ButtonClass.SCALE
                    ? 'assets/icons/scale.svg'
                    : buttonClass == ButtonClass.ROTATE
                        ? 'assets/icons/rotate.svg'
                        : buttonClass == ButtonClass.COPY
                            ? 'assets/icons/copy.svg'
                            : 'assets/icons/delete_text.svg',
                width: _templateEngine.getHeight(56),
                height: _templateEngine.getHeight(56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
