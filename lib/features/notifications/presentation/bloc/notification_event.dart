sealed class NotificationEvent {
  const NotificationEvent();
}

class LoadNotificationCity extends NotificationEvent {
  final String uid;

  const LoadNotificationCity(this.uid);
}

class SetNotificationCityEvent extends NotificationEvent {
  final String uid;
  final String cityName;

  const SetNotificationCityEvent({
    required this.uid,
    required this.cityName,
  });
}

class ClearNotificationCityEvent extends NotificationEvent {
  final String uid;

  const ClearNotificationCityEvent(this.uid);
}