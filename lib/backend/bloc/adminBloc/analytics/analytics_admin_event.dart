import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

// Event to fetch all data
class FetchAllData extends AdminEvent {}

// Event to fetch users with data
class FetchUsersWithData extends AdminEvent {}

// Event to fetch incidents
class FetchIncidents extends AdminEvent {}

// Event to fetch users with incidents
class FetchUsersWithIncidents extends AdminEvent {}

// Event to fetch safe zones
class FetchSafeZones extends AdminEvent {}

// Event to fetch users with safe zones
class FetchUsersWithSafeZones extends AdminEvent {}
