import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_city.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final NotificationCity? city;

  const NotificationLoaded(this.city);

  bool get hasCity => city != null;

  @override
  List<Object?> get props => [city];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}