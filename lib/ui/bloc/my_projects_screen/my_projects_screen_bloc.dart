import 'dart:typed_data';

import 'package:instapanoflutter/ui/ui.dart';
import 'package:instapanoflutter/util/util.dart';
import 'package:rxdart/rxdart.dart';

class MyProjectsScreenBloc extends Bloc {
  final _templatesList = BehaviorSubject<List>();

  List<BehaviorSubject<Uint8List>> _listPreview = [];

  MyProjectsScreenBloc() {
    subjects = [_templatesList];
    subscriptions = [_templatesList.listen((data) {})];
  }

  List get getListPreview => _listPreview;

  Stream<List> get getTemplatesLength => _templatesList.stream;

  void addTemplatesList(List data) {
    _listPreview = [];
    for (int i = 0; i < data.length; i++) {
      _listPreview.add(BehaviorSubject<Uint8List>());
    }
    _templatesList.add(data);
  }

  Future<void> createPreviewImage(Map<templateName, Template> templates) async {
    for (int i = 0; i < _templatesList.value.length; i++) {
      var data = _templatesList.value[i];
      ConstructorBloc bloc = ConstructorBloc(
        template: templates[templateName.values[data['type']]],
      );
      bloc.fromJson(data);
      var bytes = await bloc.createPreviewImage(
        index: 0,
        bloc: bloc,
        myProjects: true,
      );
      _listPreview[i].add(bytes);
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}
