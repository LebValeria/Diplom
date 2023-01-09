import 'package:flutter/cupertino.dart';

import 'constants.dart';

enum templateName { BLACK_FAMOUS, STAY_SALTY, BASIC }

class Templates {
  final Map<templateName, Template> templates = {
    templateName.BASIC: BasicTemplate(),
    templateName.STAY_SALTY: StaySalty(),
    templateName.BLACK_FAMOUS : BlackFamous(),
  };

  Templates();
}

class Template {
  ///Путь до изображения, которое будет прокручиваться на экране Discover и т.п.
  final String previewFilePath;

  ///Позиции, куда скроллится превью шаблона на экране Discover
  final List<double> previewScrollPositions;

  ///Количество свайпов в предпросмотре при сохранении
  final int scrollCountInPreview;

  ///Ширина фото в превью
  final double previewWidth;

  ///Ширина шаблонизатора
  final int templateWidth;

  ///Количество фото, которые пользователь может добавить
  final int photoCount;

  ///Путь до изображения слайдера
  final String sliderFilePath;

  ///Ширина слайдера прокрутки шаблона
  final double sliderWidth;

  ///Высота слайдера прорутки шаблона
  final double sliderHeight;

  final templateName name;

  const Template({
    @required this.previewFilePath,
    @required this.previewScrollPositions,
    @required this.previewWidth,
    @required this.templateWidth,
    @required this.scrollCountInPreview,
    @required this.photoCount,
    @required this.sliderFilePath,
    @required this.sliderWidth,
    @required this.sliderHeight,
    @required this.name,
  });
}

class BasicTemplate extends Template {
  BasicTemplate()
      : super(
          previewFilePath: 'assets/templates_other_images/basic/basic.jpg',
          previewScrollPositions: [0, Constants.width280, Constants.width560],
          previewWidth: Constants.width721,
          templateWidth: 4320,
          scrollCountInPreview: 3,
          photoCount: 8,
          sliderFilePath: 'assets/templates_other_images/basic/slider.jpg',
          sliderWidth: Constants.width142,
          sliderHeight: Constants.height35,
          name: templateName.BASIC,
        );
}

class StaySalty extends Template {
  StaySalty()
      : super(
          previewFilePath:
              'assets/templates_other_images/stay_salty/stay_salty_preview.jpg',
          previewScrollPositions: [0, Constants.width280, Constants.width560],
          previewWidth: Constants.width900,
          templateWidth: 5400,
          scrollCountInPreview: 4,
          photoCount: 6,
          sliderFilePath:
              'assets/templates_other_images/stay_salty/stay_salty_slider.jpg',
          sliderWidth: Constants.height176,
          sliderHeight: Constants.height35,
          name: templateName.STAY_SALTY,
        );
}

class BlackFamous extends Template {
  BlackFamous()
      : super(
    previewFilePath:
    'assets/templates_other_images/black_famous/black_famous_preview.png',
    previewScrollPositions: [0, Constants.width280, Constants.width560],
    previewWidth: Constants.width900,
    templateWidth: 5400,
    scrollCountInPreview: 4,
    photoCount: 6,
    sliderFilePath:
    'assets/templates_other_images/black_famous/black_famous_slider.png',
    sliderWidth: Constants.height176,
    sliderHeight: Constants.height35,
    name: templateName.BLACK_FAMOUS,
  );
}
