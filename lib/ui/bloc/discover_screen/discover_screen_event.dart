class DiscoverScreenEvent {
  DiscoverScreenEvent._();

  factory DiscoverScreenEvent.addPageIndex(int index) = SetDiscoverScreenEvent;
}

class SetDiscoverScreenEvent extends DiscoverScreenEvent {
  final int index;

  SetDiscoverScreenEvent(this.index): super._();
}