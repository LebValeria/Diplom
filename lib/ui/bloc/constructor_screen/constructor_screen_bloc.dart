import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_photo_picker/flutter_photo_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:save_image/save_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

const directoryName = 'Instapano';

class ConstructorBloc extends Bloc {
  final double _horizontalPadding = Constants.width24;

  final Template template;

  /// Количество текстовых полей. Нужно чтобы снова не вызывался фокус при закрытии клавиатуры.
  int itemCount = 0;

  double get defaultHorizontalPadding => _horizontalPadding;

  final _sliderPositionSubject = BehaviorSubject<SliderData>.seeded(
    SliderData(
      scrollPositions: 0.0,
    ),
  );

  final _listTextFieldSubject = BehaviorSubject<List<FieldItem>>.seeded([]);

  ///Текущее текстовое поле. Нужно для запроса к нему [FocusNode]
  final _actualTextFieldSubject = BehaviorSubject<int>();

  ///Список [BehaviorSubject]-ов для фотоглафий
  final _photoSubjectsListSubject =
      BehaviorSubject<List<BehaviorSubject<CustomFile>>>();

  final _scaleAndRotateListSubjects =
      BehaviorSubject<List<BehaviorSubject<ScaleAndRotate>>>.seeded([]);

  final _currentPhotoListSubject =
      BehaviorSubject<List<BehaviorSubject<PhotoIndex>>>();

  ///Для выделения кнопок
  final _buttonFocusListSubject =
      BehaviorSubject<List<BehaviorSubject<bool>>>();
  final _updateButtonFocusSubject = BehaviorSubject<bool>();

  final _showProgressIndicator = BehaviorSubject<bool>();

  List<PhotoCalculationValues> _calculationsList = [];

  ConstructorBloc({@required this.template}) {
    subscriptions = [];
    subjects = [
      _listTextFieldSubject,
      _actualTextFieldSubject,
      _photoSubjectsListSubject,
      _scaleAndRotateListSubjects,
      _currentPhotoListSubject,
      _sliderPositionSubject,
      _buttonFocusListSubject,
      _updateButtonFocusSubject,
      _showProgressIndicator,
    ];
    initPhotoList(template.photoCount);
    initPhotoCalculationValuesList();
    initScaleAndRotateSubjects();
    initPhotoIndexList();
    initButtonFocusList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<bool> get getShowProgressIndicator => _showProgressIndicator.stream;

  List<PhotoCalculationValues> get getPhotoCalculationValuesList =>
      _calculationsList;

  Stream<SliderData> get getSliderPosition =>
      _sliderPositionSubject.stream.skip(1);

  Stream<List<FieldItem>> get getListTextField => _listTextFieldSubject.stream;

  Stream<FocusNode> get getActualFocusNode => Rx.combineLatest2(
        _actualTextFieldSubject.stream,
        _listTextFieldSubject.stream,
        (int number, List<FieldItem> fieldsList) {
          return fieldsList.isEmpty || number == null
              ? null
              : fieldsList[number].textData.value.focusNode;
        },
      );

  Stream<List<BehaviorSubject<CustomFile>>> get getPhotoList =>
      _photoSubjectsListSubject.stream;

  List<FieldItem> get countTextFields => _listTextFieldSubject.value;

  ///Функции для сохранения шаблона в виде картинки
  List getSavePhotoList() {
    return _photoSubjectsListSubject.value;
  }

  CustomFile getSaveImageFromIndex(int index) {
    return _photoSubjectsListSubject.value[index].value;
  }

  List getSaveListPhotoIndex() {
    return _currentPhotoListSubject.value;
  }

  PhotoIndex getSavePhotoIndexFromIndex(int index) {
    return _currentPhotoListSubject.value[index].value;
  }

  List getSaveListScaleAndRotate() {
    return _scaleAndRotateListSubjects.value;
  }

  ScaleAndRotate getSaveScaleAndRotateFromIndex(int index) {
    return _scaleAndRotateListSubjects.value[index].value;
  }

  ///endregion

  Sink<int> get updateActualIndex => _actualTextFieldSubject.sink;

  Stream<int> get getActualTextFieldIndex => _actualTextFieldSubject.stream;

  Stream<List<BehaviorSubject<ScaleAndRotate>>> get getListScaleAndRotate =>
      _scaleAndRotateListSubjects.stream;

  Stream<List<BehaviorSubject<PhotoIndex>>> get getListPhotoIndex =>
      _currentPhotoListSubject.stream;

  Stream<List<BehaviorSubject<bool>>> get getButtonFocusList =>
      _buttonFocusListSubject.stream;

  ///[Stream] для блокирования скрола шаблона. true - заблокирован
  Stream<bool> get getHaveActiveButtonFocus => _updateButtonFocusSubject.stream;

  ///return [int] индекс текстового поля, у которого активны кнопки
  Stream<int> get getIndexActiveTextFieldButton => Rx.combineLatest2(
        _updateButtonFocusSubject,
        _buttonFocusListSubject,
        (bool update, List<BehaviorSubject<bool>> behList) {
          for (int i = _photoSubjectsListSubject.value.length;
              i < behList.length;
              i++) {
            if (behList[i].value == true)
              return i - _photoSubjectsListSubject.value.length;
          }
          return null;
        },
      );

  int get getPhotoCount => _photoSubjectsListSubject.value.length;

  void updateSlider(double value) {
    if (value < 0) value = 0;
    _sliderPositionSubject.add(
      _sliderPositionSubject.value..scrollPositions = value,
    );
  }

  void updateSliderMaxScrollPositions(double value) {
    _sliderPositionSubject.add(
      _sliderPositionSubject.value..maxScrollPosition = value,
    );
  }

  ///Должна быть первой в списке функций инициализации списков
  void initPhotoList(int photoCount) {
    List<BehaviorSubject<CustomFile>> bufList = [];
    for (int i = 0; i < photoCount; i++) {
      bufList.add(BehaviorSubject<CustomFile>());
    }
    _photoSubjectsListSubject.add(bufList);
  }

  void initPhotoCalculationValuesList() {
    for (var _ in _photoSubjectsListSubject.value) {
      _calculationsList.add(PhotoCalculationValues(
        constructorBloc: this,
      ));
    }
  }

  void initScaleAndRotateSubjects() {
    List<BehaviorSubject<ScaleAndRotate>> bufList = [];
    for (var _ in _photoSubjectsListSubject.value) {
      bufList.add(BehaviorSubject<ScaleAndRotate>.seeded(ScaleAndRotate()));
    }
    _scaleAndRotateListSubjects.add(bufList);
  }

  void initPhotoIndexList() {
    List<BehaviorSubject<PhotoIndex>> bufList = [];
    for (var _ in _photoSubjectsListSubject.value) {
      bufList.add(
        BehaviorSubject<PhotoIndex>.seeded(
          PhotoIndex(),
        ),
      );
    }
    _currentPhotoListSubject.add(bufList);
  }

  ///При инициализации заполняется только для фото, т.к. изначально текстовых полей нет
  void initButtonFocusList() {
    List<BehaviorSubject<bool>> bufList = [];
    for (var _ in _photoSubjectsListSubject.value) {
      bufList.add(
        BehaviorSubject<bool>.seeded(false),
      );
    }
    _buttonFocusListSubject.add(bufList);
  }

  void addShowProgressIndicator(bool value) {
    _showProgressIndicator.add(value);
  }

  ///Добавление нового фокуса для кнопок текста
  void addToButtonFocusList() {
    this.clearButtonFocus();
    _updateButtonFocusSubject.add(true);

    _buttonFocusListSubject.value.add(BehaviorSubject<bool>.seeded(true));
  }

  void changeButtonFocus(int elementID, bool isPhoto) {
    if (!isPhoto) {
      elementID += _photoSubjectsListSubject.value.length;
    }

    this.clearButtonFocus();

    /// Новый фокус
    _buttonFocusListSubject
        .expand((item) => item)
        .skip(elementID)
        .take(1)
        .map((data) => data.add(true))
        .listen(
          (e) {},
        );

    _updateButtonFocusSubject.add(true);

    if (isPhoto)
      _currentPhotoListSubject
          .expand((item) => item)
          .skip(elementID)
          .take(1)
          .map((data) => data.add(data.value..borderVisible = true))
          .listen((e) {});
  }

  /// Убираем старый фокус
  void clearButtonFocus() {
    _updateButtonFocusSubject.add(false);

    ///Цикл для того, чтобы не перезатирался true после добавления/копирования текстового поля
    for (int i = 0; i < _buttonFocusListSubject.value.length; i++) {
      if (_buttonFocusListSubject.value[i].value == true)
        _buttonFocusListSubject.value[i].add(false);
    }

    _currentPhotoListSubject
        .expand((item) => item)
        .where(
          (data) => data.value.borderVisible == true,
        )
        .map(
          (trueItem) => trueItem.add(trueItem.value..borderVisible = false),
        )
        .listen(
          (e) {},
        );
  }

  void unFocusActualTextField() {
    final actualIndex = _actualTextFieldSubject.value;
    if (actualIndex != null) {
      final List<FieldItem> texts = _listTextFieldSubject.value;
      this.closeKeyboard(texts[actualIndex].textData.value.focusNode);
      _actualTextFieldSubject.add(null);
    }
  }

  void tapOut() {
    this.clearButtonFocus();
    this.unFocusActualTextField();
  }

  ///Добавление предзаполенного текстового поля
  void addPreFilledTextField(FieldItem fieldItem) {
    _listTextFieldSubject.value.add(fieldItem);
  }

  /// Добавление списка предзаполненных текстовых полей
  void addPreFilledListTextFields(
    DynamicTemplateEngine templateEngine,
  ) {
    this.preFilledTextFieldsSwitch(templateEngine);
  }

  /// Запрос фокуса для последнего текстового поля
  void requestLastFocus(index) async {
    final int length = _listTextFieldSubject.value.length;
    if (index == length - 1 && length != itemCount) {
      itemCount = length;
      if (!_listTextFieldSubject
          .value[index].textData.value.requestFocusAfterAdd) {
        await Future.delayed((Duration(milliseconds: 200)));
        _listTextFieldSubject.value[index].textData.value.focusNode
            .requestFocus();
      }
    }
  }

  void addNewTextField(
      double height, BuildContext context, ScrollController controller) {
    _listTextFieldSubject.take(1).listen(
      (data) {
        // добавление нового текстового поля в список фокусов для кнопок
        this.addToButtonFocusList();

        data.add(
          FieldItem(
            textData: BehaviorSubject<TextData>.seeded(
              TextData(
                textStyle: GoogleFonts.roboto(
                  fontWeight:
                      FontWeight.lerp(FontWeight.w300, FontWeight.w400, 0.5),
                  fontStyle: FontStyle.normal,
                  fontSize: 17,
                  letterSpacing: -0.24,
                  height: 1.18,
                  color: AppColors.black,
                ),
                controller: TextEditingController(),
                fontSize: Constants.textSize15,
                color: Colors.black,
                focusNode: FocusNode(),
                visible: true,
                offset: Offset(
                  controller.position.pixels +
                      MediaQuery.of(context).size.width / 3,
                  height / 3,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
            dragTextBloc: DragTextBloc(),
            styleData: BehaviorSubject<StyleData>.seeded(
              StyleData(
                fontWeight: FontWeight.w400,
                textDirection: TextDirection.ltr,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        );
        _listTextFieldSubject.add(data);
        updateActualIndex.add(_listTextFieldSubject.value.length - 1);
      },
    );
  }

  ///Добавление текстовых полей в зависимости от шаблона
  void preFilledTextFieldsSwitch(DynamicTemplateEngine templateEngine) {
    List<FieldItem> fieldItems = [];
    if (template.name == templateName.STAY_SALTY) {
      fieldItems =
          StaySaltyPreFields(templateEngine: templateEngine).fieldItems;
    }
    if (template.name == templateName.BLACK_FAMOUS) {
      fieldItems =
          BlackFamousPreFields(templateEngine: templateEngine).fieldItems;
    }
    _listTextFieldSubject.add(fieldItems);
    for (int i = 0; i < fieldItems.length; i++) {
      _buttonFocusListSubject.value.add(BehaviorSubject<bool>.seeded(false));
    }
  }

  void addCopyTextField(TextData oldTextData, ScaleAndRotate scaleAndRotate,
      StyleData styleData) {
    Offset newOffset =
        Offset(oldTextData.offset.dx + 24, oldTextData.offset.dy + 24);
    _listTextFieldSubject.take(1).listen(
      (data) {
        data.add(
          FieldItem(
            textData: BehaviorSubject<TextData>.seeded(
              TextData(
                textStyle: oldTextData.textStyle,
                controller: TextEditingController()
                  ..text = oldTextData.controller.text,
                fontSize: oldTextData.fontSize,
                color: oldTextData.color,
                focusNode: FocusNode(),
                visible: true,
                offset: newOffset,
                textDirection: oldTextData.textDirection,
                requestFocusAfterAdd: true,
              ),
            ),
            scaleAndRotate: scaleAndRotate,
            dragTextBloc: DragTextBloc(),
            styleData: BehaviorSubject<StyleData>.seeded(styleData),
          ),
        );
        // добавляем новое текстовое поле в список фокусов для кнопок
        this.addToButtonFocusList();

        _listTextFieldSubject.add(data);
        updateActualIndex.add(_listTextFieldSubject.value.length - 1);
      },
    );
  }

  void updateStyle(TextStyle textStyle, int index) {
    _listTextFieldSubject
        .expand((item) => item)
        .skip(index)
        .take(1)
        .map((data) {
      data.textData.add(
        data.textData.value
          ..textStyle = textStyle.copyWith(
            letterSpacing: data.textData.value.textStyle.letterSpacing,
            height: data.textData.value.textStyle.height,
          ),
      );
    }).listen((e) {});
  }

  void updateFontSize(double fontSize, int index) {
    _listTextFieldSubject
        .expand((item) => item)
        .skip(index)
        .take(1)
        .map(
          (data) => data.textData.add(data.textData.value..fontSize = fontSize),
        )
        .listen((e) {});
  }

  void updatePositions(Offset offset, int index) {
    _listTextFieldSubject
        .expand((item) => item)
        .skip(index)
        .take(1)
        .map(
          (data) => data.textData.add(data.textData.value..offset = offset),
        )
        .listen((e) {});
  }

  void updateTextFieldVisibly(int index) {
    _listTextFieldSubject
        .expand((item) => item)
        .skip(index)
        .take(1)
        .map((data) {
      data.textData.value.focusNode.unfocus();
      return data.textData.add(data.textData.value..visible = false);
    }).listen((e) {});
    this.clearButtonFocus();
  }

  void deleteTextField(int index) {
    List<FieldItem> bufList = [];
    List<FieldItem> data = _listTextFieldSubject.value;
    for (int i = 0; i < data.length; i++) {
      if (i == index) {
        data[i].textData.value.focusNode.unfocus();
        //data[i].textData.value.focusNode.dispose();
        //data[i].textData.value.controller.dispose()
        if (i == _actualTextFieldSubject.value)
          _actualTextFieldSubject.add(null);
        continue;
      }
      bufList.add(data[i]);
    }
    _listTextFieldSubject.add(bufList);
  }

  void closeKeyboard(FocusNode focusNode) {
    focusNode.unfocus();
  }

  BehaviorSubject<CustomFile> getStreamPhotoId(int id) {
    return _photoSubjectsListSubject.value[id];
  }

  Future pickImageId(int id) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var size = await getSize(image);
      CustomFile file = CustomFile(
        file: image,
        imageHeight: size.height,
        imageWidth: size.width,
        relation: size.height / size.width,
      );
      _photoSubjectsListSubject.value[id].add(file);
      this.changeButtonFocus(id, true);
    }
  }

  void deleteImage(int photoNumber) {
    _photoSubjectsListSubject.value[photoNumber].add(null);
  }

  void updateFalseVisible(int photoNumber) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.updateFalseVisible(),
          ),
        )
        .listen((e) {});
  }

  void updatePhotoPosition(int photoNumber, Offset delta) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value..delta = delta + data.value.oldDelta,
          ),
        )
        .listen((e) {});
  }

  void updateOldPhotoPosition(int photoNumber) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value..oldDelta = data.value.delta,
          ),
        )
        .listen((e) {});
  }

  void updateLastCurrentPhoto(int photoNumber) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.updateLastCurrentPhoto(),
          ),
        )
        .listen((e) {});
  }

  void updateScale(
      double scale, double scaleX, double scaleY, int photoNumber) {
    _scaleAndRotateListSubjects
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.updateScale(scale, scaleX, scaleY),
          ),
        )
        .listen((e) {});
  }

  void updatePreviousScale(int photoNumber) {
    _scaleAndRotateListSubjects
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.updatePreviousScale(),
          ),
        )
        .listen((e) {});
  }

  double getSnapshotRotate(int photoNumber) {
    return _scaleAndRotateListSubjects.value[photoNumber].value.rotate;
  }

  void updateRotate(double rotate, int photoNumber) {
    _scaleAndRotateListSubjects
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value..rotate = rotate,
          ),
        )
        .listen((e) {});
  }

  void updateFirstTapScale(Offset offsetFirstTapScale, int photoNumber) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value..firstTapScaleOffset = offsetFirstTapScale,
          ),
        )
        .listen((e) {});
  }

  void dropPhotoScaleAndRotateToDefault(int photoNumber) {
    _scaleAndRotateListSubjects
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.dropToDefault(),
          ),
        )
        .listen((e) {});
  }

  void dropPhotoPositionToDefault(int photoNumber) {
    _currentPhotoListSubject
        .expand((item) => item)
        .skip(photoNumber)
        .take(1)
        .map(
          (data) => data.add(
            data.value.dropToDefault(),
          ),
        )
        .listen((e) {});
  }

  /// Клон _computeRotationFactor() из scale.dart
  /// Первый [Offset] - движущийся палец, второй нужен для вычисления расстояния
  /// между ним и начальной точкой, чтобы сэмулировать статичный второй палец
  /// для расчета разницы между двумя линиями
  double computeRotation(Offset globalPosition, Offset offsetFromOrigin) {
    final double fx = globalPosition.dx - offsetFromOrigin.dx;
    final double fy = globalPosition.dy - offsetFromOrigin.dy;
    final double sx = globalPosition.dx - offsetFromOrigin.dx;
    final double sy = globalPosition.dy - offsetFromOrigin.dy;

    final double nfx = globalPosition.dx - offsetFromOrigin.dx;
    final double nfy = globalPosition.dy - offsetFromOrigin.dy;
    final double nsx = globalPosition.dx;
    final double nsy = globalPosition.dy;

    final double angle1 = math.atan2(fy - sy, fx - sx);
    final double angle2 = math.atan2(nfy - nsy, nfx - nsx);

    return angle2 - angle1;
  }

  TextDirection toTextDirection(language data) {
    switch (data) {
      case language.ALL:
        return TextDirection.ltr;
      case language.CYRILLIC:
        return TextDirection.ltr;
      case language.ARABIC:
        return TextDirection.rtl;
      default:
        return null;
    }
  }

  language fromTextDirection(TextDirection data) {
    switch (data) {
      case TextDirection.ltr:
        return language.ALL;
      case TextDirection.rtl:
        return language.ARABIC;
      default:
        return null;
    }
  }

  void copyDragTextBlocToFieldItem() {
    for (int i = 0; i < _listTextFieldSubject.value.length; i++) {
      _listTextFieldSubject.value[i].scaleAndRotate =
          _listTextFieldSubject.value[i].dragTextBloc.getSaveScaleAndRotate();
    }
  }

  Future<Uint8List> createPreviewImage(
      {int index, ConstructorBloc bloc, bool myProjects = false}) async {
    DynamicTemplateEngine saveTemplateEngine = DynamicTemplateEngine(
      height: 1080,
      defaultWidth: template.templateWidth,
    );
    ScrollController scroll = ScrollController(
      initialScrollOffset: (index * 1080).toDouble(),
    );
    var saveEngine = MultiProvider(
      providers: [
        Provider.value(
          value: bloc ??= this,
        ),
        Provider.value(
          value: true,
        ),
        Provider.value(
          value: template.scrollCountInPreview,
        ),
        ListenableProvider.value(
          value: scroll,
        ),
        Provider.value(
          value: template,
        ),
        Provider.value(
          value: saveTemplateEngine,
        ),
      ],
      child: Stack(
        children: <Widget>[
          TemplateEngine(
            key: Key('save'),
            isMyProjects: myProjects,
          ),
        ],
      ),
    );
    var bytes = await createImageFromWidget(
      saveEngine,
      imageSize: Size(template.templateWidth.toDouble(), 1080),
      logicalSize: Size(template.templateWidth.toDouble(), 1080),
    );
    return bytes;
  }

  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration wait, Size logicalSize, Size imageSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    logicalSize ??= ui.window.physicalSize / ui.window.devicePixelRatio;
    imageSize ??= ui.window.physicalSize;

    final RenderView renderView = RenderView(
      window: null,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        await RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Material(
        color: Colors.transparent,
        child: MediaQuery(
          data: MediaQueryData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        ),
      ),
    ).attachToRenderTree(buildOwner);

    await buildOwner.buildScope(rootElement);

    await buildOwner.buildScope(rootElement);
    await buildOwner.buildScope(rootElement);

    await Future.delayed(Duration(seconds: 1));

    await buildOwner.buildScope(rootElement);
    await buildOwner.buildScope(rootElement);
    await buildOwner.buildScope(rootElement);
    await buildOwner.buildScope(rootElement);
    await buildOwner.finalizeTree();

    pipelineOwner.requestVisualUpdate();
    await pipelineOwner.flushLayout();
    await pipelineOwner.flushCompositingBits();
    await pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage();
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData.buffer.asUint8List();
  }

  Future saveBytes(Uint8List data, int index) async {
    await getStatus();
    String date = formattedDate();
    if (await Permission.storage.isGranted) {
      String path = '/storage/emulated/0/DCIM/$directoryName';
      if (Platform.isIOS) {
        // await SaveImage.save(imageBytes: data);
      } else {
        await Directory(path).create(recursive: true);
        await File('$path/${date}_$index.jpg').writeAsBytes(data);
        ScanImage.scanImage('$path/${date}_$index.jpg');
      }
      print('save $index');
    }
  }

  Future getStatus() async {
    var status = await Permission.storage.status;

    if (status != PermissionStatus.granted) await Permission.storage.request();
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        '' +
        dateTime.minute.toString() +
        '' +
        dateTime.second.toString() +
        '' +
        dateTime.millisecond.toString();
    return dateTimeString;
  }

  void fromJson(Map<String, dynamic> json) {
    _listTextFieldSubject.add(
      List.generate(
        json['listTextField'].length,
        (index) => FieldItem.fromJson(json['listTextField'][index]),
      ),
    );
    _photoSubjectsListSubject.add(
      List.generate(
        json['photoSubjects'].length,
        (index) => BehaviorSubject<CustomFile>.seeded(
          json['photoSubjects'][index] != null
              ? CustomFile.fromJson(json['photoSubjects'][index])
              : null,
        ),
      ),
    );
    _scaleAndRotateListSubjects.add(
      List.generate(
        json['scaleAndRotateList'].length,
        (index) => BehaviorSubject<ScaleAndRotate>.seeded(
          ScaleAndRotate.fromJson(json['scaleAndRotateList'][index]),
        ),
      ),
    );
    _currentPhotoListSubject.add(
      List.generate(
        json['currentPhotoList'].length,
        (index) => BehaviorSubject<PhotoIndex>.seeded(
          PhotoIndex.fromJson(json['currentPhotoList'][index]),
        ),
      ),
    );
    _buttonFocusListSubject.add(
      List.generate(
        json['buttonFocusListLength'],
        (index) => BehaviorSubject<bool>.seeded(false),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listTextField'] = List.generate(
      _listTextFieldSubject.value.length,
      (index) => _listTextFieldSubject.value[index].toJson(),
    );
    data['photoSubjects'] = List.generate(
      _photoSubjectsListSubject.value.length,
      (index) => _photoSubjectsListSubject.value[index].value != null
          ? _photoSubjectsListSubject.value[index].value.toJson()
          : null,
    );
    data['scaleAndRotateList'] = List.generate(
      _scaleAndRotateListSubjects.value.length,
      (index) => _scaleAndRotateListSubjects.value[index].value.toJson(),
    );
    data['currentPhotoList'] = List.generate(
      _currentPhotoListSubject.value.length,
      (index) => _currentPhotoListSubject.value[index].value.toJson(),
    );
    data['buttonFocusListLength'] = _buttonFocusListSubject.value.length;
    data['type'] = template.name.index;

    return data;
  }

  Future<void> saveAsTemplate(
      BuildContext context, NavigatorScreenBloc navigatorBloc) async {
    var data = this.toJson();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var localData = prefs.getString(Constants.saveTemplateString);
    List saveData = [];
    if (localData == null) {
      saveData.add(data);
    } else {
      saveData += jsonDecode(localData);
      saveData.add(data);
    }
    prefs.setString(Constants.saveTemplateString, jsonEncode(saveData));
    navigatorBloc.updateSaveTemplates(saveData);
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: 'Success',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<ui.Image> getSize(File image) async {
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    return decodedImage;
  }
}
