import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:provider/provider.dart';

import '../../ui.dart';

class MyProjectsScreen extends StatefulWidget {
  @override
  _MyProjectsScreenState createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  StreamSubscription _subscription;
  MyProjectsScreenBloc _bloc;

  @override
  void initState() {
    _bloc = MyProjectsScreenBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _subscription = Provider.of<NavigatorScreenBloc>(context).getSaveTemplates.listen((data) {
      _bloc.addTemplatesList(data);
      _bloc.createPreviewImage(
        Provider.of<Templates>(context).templates,
      );
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'My Project',
                style: AppTypography.appBar,
              ),
            ],
          ),
        ),
        Expanded(child: buildCollections()),
      ],
    );
  }

  Widget buildCollections() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<List>(
        stream: _bloc.getTemplatesLength,
        initialData: [],
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              return buildPreviewContainer(
                snapshot.data[index],
                index,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: Constants.height24);
            },
          );
        },
      ),
    );
  }

  Widget buildPreviewContainer(Map<String, dynamic> data, int index) {
    return Padding(
      padding: EdgeInsets.only(left: Constants.width24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPhotoText(),
          SizedBox(height: Constants.height8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constants.width10,
              vertical: Constants.height10,
            ),
            width: Constants.width327,
            height: Constants.height246,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              color: Colors.white,
              border: Border.all(color: Color(0xff313131).withOpacity(0.1)),
            ),
            child: GestureDetector(
              // onTap: () =>
              //     Provider.of<NavigatorScreenBloc>(context, listen: false)
              //         .addConstructorEvent(
              //   Provider.of<Templates>(context)
              //       .templates[templateName.values[data['type']]],
              //   data,
              // ),
              onTap: () {
                final template =
                    Provider.of<Templates>(context).templates[templateName.values[data['type']]];
                final bloc = Provider.of<NavigatorScreenBloc>(context, listen: false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Provider.value(
                        value: template,
                        child: ConstructorScreen(
                          navigatorScreenBloc: bloc,
                          template: template,
                          fromSave: data != null,
                          fromSaveData: data,
                        ),
                      );
                    },
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
                child: Container(
                  width: Constants.width307,
                  height: Constants.height280,
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder(
                      stream: _bloc.getListPreview[index],
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Row(
                            children: <Widget>[
                              Image.memory(
                                snapshot.data,
                                fit: BoxFit.fill,
                              ),
                            ],
                          );
                        else
                          return Row(
                            children: [
                              SizedBox(
                                width: Constants.width130,
                              ),
                              Center(child: CircularProgressIndicator()),
                            ],
                          );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhotoText() {
    return Text(
      '4:5 ratio, 3 photo on 2 frames',
      style: AppTypography.subhead.copyWith(
          fontSize: Constants.textSize13, color: AppColors.black.withOpacity(0.5), height: 1.54),
    );
  }
}
