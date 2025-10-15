import 'package:equatable/equatable.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_state.dart';

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

class ProfileStatisticsLoading extends AdminState {}

// Loaded State for Statistics
class ProfileStatisticsLoaded extends AdminState {
  final Map<String, dynamic> statistics;

  const ProfileStatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}

// Error State for Statistics
class ProfileStatisticsError extends AdminState {
  final String message;

  const ProfileStatisticsError(this.message);

  @override
  List<Object> get props => [message];
}

class DashboardLoaded extends AdminState {
  final List<dynamic> users;
  final Map<String, dynamic> statistics;

  const DashboardLoaded({required this.users, required this.statistics});

  @override
  List<Object> get props => [users, statistics];
}

// State while toggling user status
class ToggleUserActivityLoading extends AdminState {}

// State when user activity toggle succeeds
class ToggleUserActivitySuccess extends AdminState {
  final String message;
  final bool newStatus;

  const ToggleUserActivitySuccess({
    required this.message,
    required this.newStatus,
  });

  @override
  List<Object> get props => [message, newStatus];
}

// State when toggling fails
class ToggleUserActivityError extends AdminState {
  final String message;

  const ToggleUserActivityError(this.message);

  @override
  List<Object> get props => [message];
}
