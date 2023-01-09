class DiscoverScreenState {
  DiscoverScreenState._();

  factory DiscoverScreenState.firstTab() = FirstTabDiscoverScreenState;
  factory DiscoverScreenState.secondTab() = SecondTabDiscoverScreenState;

}

class FirstTabDiscoverScreenState extends DiscoverScreenState {
  FirstTabDiscoverScreenState(): super._();
}

class SecondTabDiscoverScreenState extends DiscoverScreenState {
  SecondTabDiscoverScreenState(): super._();
}