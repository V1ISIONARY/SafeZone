import 'package:equatable/equatable.dart';

abstract class SafeZoneAdminState extends Equatable {
  const SafeZoneAdminState();

  @override
  List<Object> get props => [];
}

class SafeZoneAdminInitial extends SafeZoneAdminState {}

class SafeZoneAdminLoading extends SafeZoneAdminState {}

class SafeZoneAdminSuccess extends SafeZoneAdminState {
  final String message;

  const SafeZoneAdminSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SafeZoneAdminFailure extends SafeZoneAdminState {
  final String error;

  const SafeZoneAdminFailure(this.error);

  @override
  List<Object> get props => [error];
}
