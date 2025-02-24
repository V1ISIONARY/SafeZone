import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNotifications extends NotificationEvent {
  final int userId;
  FetchNotifications(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final int notificationId;
  MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class DeleteNotification extends NotificationEvent {
  final int notificationId;
  DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class SendNotification extends NotificationEvent {
  final int userId;
  final String title;
  final String message;
  final String type;

  SendNotification(this.userId, this.title, this.message, this.type);

  @override
  List<Object?> get props => [userId, title, message, type];
}

// New events
class FetchNewUnreadNotifications extends NotificationEvent {
  final int userId;
  final String lastChecked;

  FetchNewUnreadNotifications(this.userId, this.lastChecked);

  @override
  List<Object?> get props => [userId, lastChecked];
}

class FetchUnreadNotificationsCount extends NotificationEvent {
  final int userId;

  FetchUnreadNotificationsCount(this.userId);

  @override
  List<Object?> get props => [userId];
}
