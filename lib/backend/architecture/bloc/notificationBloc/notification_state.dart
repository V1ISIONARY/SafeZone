import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/userModel/notifications_model.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationUpdated extends NotificationState {}

class NotificationDeleted extends NotificationState {}

class NotificationSent extends NotificationState {}

// New states
class NewUnreadNotificationsLoaded extends NotificationState {
  final Map<String, dynamic> result;
  NewUnreadNotificationsLoaded(this.result);

  @override
  List<Object?> get props => [result];
}

class UnreadNotificationsCountLoaded extends NotificationState {
  final int count;
  UnreadNotificationsCountLoaded(this.count);

  @override
  List<Object?> get props => [count];
}
class NotificationBroadcasted extends NotificationState {}
