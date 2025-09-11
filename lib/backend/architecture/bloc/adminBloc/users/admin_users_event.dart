import 'package:equatable/equatable.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminRequests extends AdminUserEvent {}

class ApproveAdminUser extends AdminUserEvent {
  final int userId;

  const ApproveAdminUser(this.userId);

  @override
  List<Object> get props => [userId];
}

