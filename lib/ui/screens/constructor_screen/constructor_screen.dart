import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instapanoflutter/ui/screens/constructor_screen/template_engine.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class ConstructorScreen extends StatefulWidget {
  final NavigatorScreenBloc navigatorScreenBloc;
  final Template template;
  final bool fromSave;
  final Map<String, dynamic> fromSaveData;

  ConstructorScreen({
    @required this.navigatorScreenBloc,
    @required this.template,
    this.fromSave = false,
    this.fromSaveData,
  });

  @override
  _ConstructorScreenState createState() => _ConstructorScreenState();
}

class _ConstructorScreenState extends State<ConstructorScreen> {
  ConstructorBloc _bloc;

  FocusNode focusNode;

  /// Для передвижения текстового поля по SingleChildScrollView и progressIndicator
  ScrollController _scrollController;

  static final double mainHeight = Constants.height300;

  static DynamicTemplateEngine templateEngineMain;

  @override
  void initState() {
    templateEngineMain = DynamicTemplateEngine(
      height: mainHeight,
      defaultWidth: widget.template.templateWidth,
    );

    _bloc = ConstructorBloc(template: widget.template);

    if (widget.fromSave)
      _bloc.fromJson(widget.fromSaveData);
    else
      _bloc.addPreFilledListTextFields(templateEngineMain);

    _scrollController = ScrollController();

    _bloc.getActualFocusNode.listen(
      (data) {
        focusNode = data;
      },
    );

    _scrollController.addListener(this.listener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.updateSliderMaxScrollPositions(
        _scrollController.position.maxScrollExtent -
            _bloc.defaultHorizontalPadding,
      );
    });

    super.initState();
  }

  void listener() {
    print(
        '_scrollController.position.maxScrollExtent ${_scrollController.position.maxScrollExtent - _bloc.defaultHorizontalPadding}');
    _bloc.updateSlider(_scrollController.position.pixels);
  }

  Future<void> backConstructor(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: Colors.white,
          ),
          width: 263,
          height: 181,
          child: Column(
            children: <Widget>[
              SizedBox(height: 18),
              Text(
                'Save template?',
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38),
                child: Text(
                  'Template will be added to your projects',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 13,
                    color: Color(0xff828282),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 14),
              Container(
                width: 263,
                height: 1,
                color: Color(0xffE6E6E6),
              ),
              SizedBox(height: 10),
              Container(
                height: 21,
                width: 263,
                child: InkWell(
                  onTap: () => _bloc.saveAsTemplate(
                    context,
                    widget.navigatorScreenBloc,
                  ),
                  child: Center(
                    child: Text(
                      'Yes',
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.pink,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 263,
                height: 1,
                color: Color(0xffE6E6E6),
              ),
              SizedBox(height: 10),
              Container(
                height: 17,
                width: 263,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'No',
                      style: AppTypography.buttonText.copyWith(
                        color: AppColors.pink,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PreviewScreen(
        template: widget.template,
        constructorBloc: _bloc,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Constructor',
                  style: AppTypography.appBar,
                ),
                Container(
                  width: Constants.width105,
                  height: Constants.height52,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(_createRoute()),
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Preview',
                        style: AppTypography.appBar.copyWith(
                            fontWeight: FontWeight.w500, color: AppColors.pink),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<bool>(
              stream: _bloc.getShowProgressIndicator,
              builder: (context, snapshot) {
                return Stack(
                  children: <Widget>[
                    Visibility(
                      visible: snapshot.data == null,
                      child: GestureDetector(
                        onTap: () => _bloc.tapOut(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).viewPadding.vertical,
                          color: Colors.transparent,
                          child: Provider.value(
                            value: _bloc,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: Constants.height80),
                                buildEngine(),
                                Spacer(),
                                buildBottomButtons(),
                                SizedBox(height: Constants.height24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: snapshot.data == true,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Center(
                          child: Container(
                            width: Constants.height50,
                            height: Constants.height50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.pink),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEngine() {
    return MultiProvider(
      providers: [
        ListenableProvider.value(
          value: _scrollController,
        ),
        Provider.value(
          value: false,
        ),
        Provider.value(
          value: templateEngineMain,
        )
      ],
      child: TemplateEngine(
        key: Key('main'),
      ),
    );
  }

  Widget buildBottomButtons() {
    return buildUnActiveTextField();
  }

  Widget buildUnActiveTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: Constants.width40,
        right: Constants.width38,
      ),
      child: buildAddText(),
    );
  }

  Widget buildAddText() {
    return ButtonRectangle20(
      width: Constants.width140,
      height: Constants.height64,
      onPressed: () =>
          _bloc.addNewTextField(mainHeight, context, _scrollController),
      child: Text(
        'Add text',
        style: AppTypography.buttonText.copyWith(
          color: AppColors.pink,
        ),
      ),
    );
  }
}
