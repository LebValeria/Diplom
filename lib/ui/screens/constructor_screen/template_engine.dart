import 'package:flutter/material.dart';
import 'package:instapanoflutter/data/data.dart';
import 'package:instapanoflutter/ui/widgets/templates/black_famous.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui.dart';

enum ButtonClass { ROTATE, SCALE, DELETE, COPY }

class TemplateEngine extends StatefulWidget {
  final Key key;
  final int index;
  final ScrollController scrollController;
  final bool isMyProjects;

  const TemplateEngine({
    this.key,
    this.index,
    this.scrollController,
    this.isMyProjects = false,
  });

  @override
  TemplateEngineState createState() => TemplateEngineState();
}

class TemplateEngineState extends State<TemplateEngine> {
  ConstructorBloc _constructorBloc;
  DynamicTemplateEngine _templateEngine;

  @override
  Widget build(BuildContext context) {
    _constructorBloc ??= Provider.of<ConstructorBloc>(context);
    _templateEngine ??= Provider.of<DynamicTemplateEngine>(context);

    return StreamBuilder<bool>(
      stream: _constructorBloc.getHaveActiveButtonFocus,
      initialData: false,
      builder: (context, snapshot) {
        return Container(
          height: _templateEngine.getMainHeight +
              _templateEngine.getHeight(120),
          width: widget.key == Key('save') && !widget.isMyProjects
              ? 1080
              : _templateEngine.getMainWidth,
          child: SingleChildScrollView(
            controller: widget.scrollController == null
                ? Provider.of<ScrollController>(context)
                : widget.scrollController,
            physics: Provider.of<bool>(context)
                ? NeverScrollableScrollPhysics()
                : snapshot.data
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: buildMainRow(),
          ),
        );
      },
    );
  }

  Widget buildMainRow() {
    return Row(
      children: <Widget>[
        if (!Provider.of<bool>(context))
          SizedBox(
            width:
            _constructorBloc.defaultHorizontalPadding,
          ),
        Container(
          width: _templateEngine.getMainWidth,
          height: _templateEngine.getMainHeight +
              _templateEngine.getWidth(120),
          child: MultiProvider(
            providers: [
              Provider.value(
                value: _templateEngine,
              ),
              Provider.value(
                value: widget.key,
              ),
            ],
            child: StreamBuilder<List<FieldItem>>(
              stream: _constructorBloc.getListTextField,
              initialData: [],
              builder: (context, snapshotFieldItem) {
                return buildStreams(snapshotFieldItem.data);
              },
            ),
          ),
        ),
        if (!Provider.of<bool>(context))
          SizedBox(
            width:
            _constructorBloc.defaultHorizontalPadding,
          ),
      ],
    );
  }

  Widget buildStreams(List<FieldItem> snapshotFieldItem) {
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
                return Provider.value(
                  value: snapshotFieldItem,
                  child: widget.key != Key('save') ? Stack(
                    children: <Widget>[
                      Positioned(
                        top: _templateEngine.getHeight(60),
                        child: templateSwitch(),
                      ),
                      Container(
                        width: _templateEngine.getMainWidth,
                        height: _templateEngine.getMainHeight +
                            _templateEngine.getHeight(120),
                      ),
                      Provider.value(
                        value: 120.0,
                        child: buildOverButton(),
                      ),
                    ],
                  ) : templateSwitch(),
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

  Widget templateSwitch() {
    templateName template = Provider.of<Template>(context).name;

    if (template == templateName.BASIC) return BasicTemplateWidget();
    if (template == templateName.STAY_SALTY)
      return StaySaltyTemplate(
        constructorBloc: _constructorBloc,
      );
    if (template == templateName.BLACK_FAMOUS)
      return BlackFamousTemplate(
        constructorBloc: _constructorBloc,
      );
    return Container(
      child: Text(
        'Nothing to show',
        style: AppTypography.headLine,
      ),
    );
  }

  Widget buildOverButton() {
    templateName template = Provider.of<Template>(context).name;
    if (template == templateName.STAY_SALTY) return buildStaySaltyOverButton();
    if (template == templateName.BLACK_FAMOUS)
      return buildBlackFamousOverButton();
    return Container();
  }

  Widget buildStaySaltyOverButton() {
    return Stack(
      children: <Widget>[
        Container(
          width: _templateEngine.getMainWidth,
          height: _templateEngine.getMainHeight +
              _templateEngine.getHeight(120),
        ),
        PhotoActionButton(
          buttonClass: ButtonClass.ROTATE,
          photoNumber: 1,
          bottom: 0,
          left: 2319,
          photoHeight: _templateEngine.getHeight(918),
          photoWidth: _templateEngine.getWidth(648),
        ),
        PhotoActionButton(
          buttonClass: ButtonClass.SCALE,
          photoNumber: 1,
          bottom: 0,
          left: 2962,
          photoHeight: _templateEngine.getHeight(918),
          photoWidth: _templateEngine.getWidth(648),
        ),
      ],
    );
  }

  Widget buildBlackFamousOverButton() {
    return Stack(
      children: <Widget>[
        Container(
          width: _templateEngine.getMainWidth,
          height: _templateEngine.getMainHeight +
              _templateEngine.getHeight(120),
        ),
        PhotoActionButton(
          buttonClass: ButtonClass.ROTATE,
          photoNumber: 4,
          bottom: 0,
          left: 2588,
          photoHeight: _templateEngine.getHeight(1080),
          photoWidth: _templateEngine.getWidth(1350),
        ),
        PhotoActionButton(
          buttonClass: ButtonClass.SCALE,
          photoNumber: 4,
          bottom: 0,
          left: 3936,
          photoHeight: _templateEngine.getHeight(1080),
          photoWidth: _templateEngine.getWidth(1350),
        ),
        PhotoActionButton(
          buttonClass: ButtonClass.DELETE,
          photoNumber: 4,
          top: 0,
          left: 3935,
        ),
      ],
    );
  }
}
