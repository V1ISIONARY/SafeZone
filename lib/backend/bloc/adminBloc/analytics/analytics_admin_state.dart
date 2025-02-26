import 'package:equatable/equatable.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

// Initial state
class AdminInitial extends AdminState {}

// Loading state
class AdminLoading extends AdminState {}

// Loaded state for all data
class AllDataLoaded extends AdminState {
  final dynamic data;
  const AllDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Loaded state for users with data
class UsersWithDataLoaded extends AdminState {
  final List<dynamic> data; // Change the type to List<dynamic>
  const UsersWithDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Loaded state for incidents
class IncidentsLoaded extends AdminState {
  final dynamic data;
  const IncidentsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Loaded state for users with incidents
class UsersWithIncidentsLoaded extends AdminState {
  final dynamic data;
  const UsersWithIncidentsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Loaded state for safe zones
class SafeZonesLoaded extends AdminState {
  final dynamic data;
  const SafeZonesLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Loaded state for users with safe zones
class UsersWithSafeZonesLoaded extends AdminState {
  final dynamic data;
  const UsersWithSafeZonesLoaded(this.data);

  @override
  List<Object> get props => [data];
}

// Error state
class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);

  @override
  List<Object> get props => [message];
}
