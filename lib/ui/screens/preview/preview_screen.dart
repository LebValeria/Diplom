import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../ui.dart';

class PreviewScreen extends StatefulWidget {
  final Template template;
  final ConstructorBloc constructorBloc;

  PreviewScreen({
    @required this.template,
    @required this.constructorBloc,
  }) : assert(template != null);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  static DynamicTemplateEngine saveTemplateEngine;
  ScrollController scrollController;
  int index = 0;

  PreviewScreenBloc _bloc;

  @override
  void initState() {
    saveTemplateEngine = DynamicTemplateEngine(
      height: 1080,
      defaultWidth: widget.template.templateWidth,
    );
    scrollController = ScrollController();

    _bloc = PreviewScreenBloc(
      template: widget.template,
      bloc: widget.constructorBloc,
    );

    _bloc.createPreviewImage();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: Constants.width24,
                        bottom: Constants.height40,
                        top: Constants.height24,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/arrow_back_icons.svg',
                          width: Constants.width24,
                          height: Constants.height24,
                        ),
                      ),
                    ),
                  ],
                ),
                SwipeDetector(
                  swipeConfiguration: SwipeConfiguration(
                    horizontalSwipeMaxHeightThreshold:
                        MediaQuery.of(context).size.width,
                    horizontalSwipeMinDisplacement: 10.0,
                    horizontalSwipeMinVelocity: 10.0,
                  ),
                  onSwipeLeft: () {
                    if (index < widget.template.scrollCountInPreview) {
                      index += 1;
                      if (index == widget.template.scrollCountInPreview)
                        scrollController.animateTo(
                            MediaQuery.of(context).size.width * index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      else
                        scrollController.animateTo(
                          MediaQuery.of(context).size.width * index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                    }
                  },
                  onSwipeRight: () {
                    if (index > 0) {
                      index -= 1;
                      scrollController.animateTo(
                        MediaQuery.of(context).size.width * index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Container(
                    height: Constants.width375,
                    child: ListView.builder(
                      itemCount: _bloc.getListPreview.length,
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return StreamBuilder(
                          stream: _bloc.getListPreview[index].stream,
                          builder: (context, snapshot) {
                            return Container(
                              width: Constants.width375,
                              height: Constants.width375,
                              child: snapshot.hasData
                                  ? Image.memory(
                                      snapshot.data,
                                    )
                                  : Center(child: CircularProgressIndicator()),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: Constants.height90),
                StreamBuilder<bool>(
                    stream: _bloc.getShowSaveButton,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: snapshot.data,
                        child: GestureDetector(
                          onTap: () async {
                            _bloc.addTrueProgressIndicator();

                            try {
                              for (int i = 0;
                                  i < widget.template.templateWidth / 1080;
                                  i++) {
                                await widget.constructorBloc.saveBytes(
                                  _bloc.getListPreview[i].value,
                                  i,
                                );
                              }
                              Fluttertoast.showToast(
                                msg: 'Images saved!',
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            } catch (error) {
                              print(error);
                              Fluttertoast.showToast(
                                msg: 'Error',
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                            _bloc.addFalseProgressIndicator();
                          },
                          child: Container(
                            height: Constants.height60,
                            width: Constants.width100,
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                'Save',
                                style: AppTypography.appBar.copyWith(
                                  color: AppColors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
              ],
            ),
            StreamBuilder(
              stream: _bloc.getShowProgressIndicator,
              initialData: false,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: Constants.height50,
                        height: Constants.height50,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.pink),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
