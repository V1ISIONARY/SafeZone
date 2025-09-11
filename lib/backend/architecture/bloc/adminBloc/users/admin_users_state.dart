import 'package:equatable/equatable.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();

  @override
  List<Object> get props => [];
}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminRequestsLoaded extends AdminUserState {
  final List<Map<String, dynamic>> requests;

  const AdminRequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class AdminActionSuccess extends AdminUserState {
  final String message;

  const AdminActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AdminUserError extends AdminUserState {
  final String error;

  const AdminUserError(this.error);

  @override
  List<Object> get props => [error];
}
