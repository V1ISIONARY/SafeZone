import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/notificationApi/notification_repo.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc(this.notificationRepository) : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications =
            await notificationRepository.getNotifications(event.userId);
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkNotificationAsRead>((event, emit) async {
      try {
        bool success =
            await notificationRepository.markAsRead(event.notificationId);
        if (success) {
          emit(NotificationUpdated());
        } else {
          emit(NotificationError("Failed to mark notification as read."));
        }
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<DeleteNotification>((event, emit) async {
      try {
        bool success = await notificationRepository
            .deleteNotification(event.notificationId);
        if (success) {
          emit(NotificationDeleted());
        } else {
          emit(NotificationError("Failed to delete notification."));
        }
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<SendNotification>((event, emit) async {
      try {
        bool success = await notificationRepository.sendNotification(
            event.userId, event.title, event.message, event.type);
        if (success) {
          emit(NotificationSent());
        } else {
          emit(NotificationError("Failed to send notification."));
        }
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}
