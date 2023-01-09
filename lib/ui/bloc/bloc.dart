import 'dart:async';

import 'package:rxdart/subjects.dart';

abstract class Bloc {
  List<StreamSubscription> subscriptions;
  List<Subject> subjects;

  void dispose() {
    subscriptions?.forEach((subscription) => subscription.cancel());
    subjects?.forEach((subject) => subject.close());
  }
}