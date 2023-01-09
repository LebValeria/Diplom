import 'package:instapanoflutter/ui/bloc/blocs.dart';
import 'package:instapanoflutter/ui/bloc/discover_screen/discover_bloc.dart';
import 'package:rxdart/rxdart.dart';

class DiscoverScreenBloc extends Bloc {
  final _discoverScreenEvent =
      BehaviorSubject<DiscoverScreenEvent>.seeded(SetDiscoverScreenEvent(0));
  final _discoverScreenStateSubject =
      BehaviorSubject<DiscoverScreenState>.seeded(
          FirstTabDiscoverScreenState());
  final _tabIndexSubject = BehaviorSubject<int>.seeded(0);

  DiscoverScreenBloc() {
    subjects = [
      _tabIndexSubject,
      _discoverScreenEvent,
      _discoverScreenStateSubject,
    ];
    subscriptions = [
      _discoverScreenEvent.skip(1).listen((data) {
        final currentState = _discoverScreenStateSubject.value;
        mapEventToState(data, currentState)
            .forEach(_discoverScreenStateSubject.add);
      }),
      _tabIndexSubject.skip(1).listen((index) {
        _discoverScreenEvent.add(DiscoverScreenEvent.addPageIndex(index));
      })
    ];
  }

  Stream<DiscoverScreenState> mapEventToState(
      DiscoverScreenEvent event, DiscoverScreenState state) async* {
    if ((event as SetDiscoverScreenEvent).index == 0) {
      yield DiscoverScreenState.firstTab();
    }
    if ((event as SetDiscoverScreenEvent).index == 1) {
      yield DiscoverScreenState.secondTab();
    }
  }

  @override
  void dispose() {
    _tabIndexSubject.close();
    _discoverScreenStateSubject.close();
    super.dispose();
  }

  Stream<DiscoverScreenState> get getTabState =>
      _discoverScreenStateSubject.stream.skip(1);

  Sink<int> get updateTabIndex => _tabIndexSubject.sink;
}
