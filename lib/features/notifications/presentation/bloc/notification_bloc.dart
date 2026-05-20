import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_notification_city.dart';
import '../../domain/usecases/set_notification_city.dart';
import '../../domain/usecases/clear_notification_city.dart';
import 'notification_event.dart';
import 'notification_state.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationCity _getNotificationCity;
  final SetNotificationCity _setNotificationCity;
  final ClearNotificationCity _clearNotificationCity;

  NotificationBloc(
      this._getNotificationCity,
      this._setNotificationCity,
      this._clearNotificationCity,
      ) : super(const NotificationInitial()) {
    on<LoadNotificationCity>(_onLoad);
    on<SetNotificationCityEvent>(_onSet);
    on<ClearNotificationCityEvent>(_onClear);
  }

  Future<void> _onLoad(
      LoadNotificationCity event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());

    final result = await _getNotificationCity(event.uid);
    result.fold(
          (failure) => emit(NotificationError(failure.message)),
          (city) => emit(NotificationLoaded(city)),
    );
  }

  Future<void> _onSet(
      SetNotificationCityEvent event,
      Emitter<NotificationState> emit,
      ) async {
    final result = await _setNotificationCity(event.uid, event.cityName);
    result.fold(
          (failure) => emit(NotificationError(failure.message)),
          (_) => add(LoadNotificationCity(event.uid)),
    );
  }

  Future<void> _onClear(
      ClearNotificationCityEvent event,
      Emitter<NotificationState> emit,
      ) async {
    final result = await _clearNotificationCity(event.uid);
    result.fold(
          (failure) => emit(NotificationError(failure.message)),
          (_) => add(LoadNotificationCity(event.uid)),
    );
  }
}