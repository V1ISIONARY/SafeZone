import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneState extends Equatable {
  const SafeZoneState();

  @override
  List<Object> get props => [];
}

// Initial state
class SafeZoneInitial extends SafeZoneState {}

// Loading state
class SafeZoneLoading extends SafeZoneState {}

// Loaded state for safe zones
class SafeZonesLoaded extends SafeZoneState {
  final List<SafeZoneModel> safeZones;

  const SafeZonesLoaded(this.safeZones);

  @override
  List<Object> get props => [safeZones];
}

// Loaded state for a single safe zone
class SafeZoneLoaded extends SafeZoneState {
  final SafeZoneModel safeZone;

  const SafeZoneLoaded(this.safeZone);

  @override
  List<Object> get props => [safeZone];
}

// Loaded state for status history
class StatusHistoryLoaded extends SafeZoneState {
  final List<StatusHistory> statusHistory;

  const StatusHistoryLoaded(this.statusHistory);

  @override
  List<Object> get props => [statusHistory];
}

// Success state for create/update/delete operations
class SafeZoneOperationSuccess extends SafeZoneState {
  final String message;

  const SafeZoneOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Error state
class SafeZoneError extends SafeZoneState {
  final String message;

  const SafeZoneError(this.message);

  @override
  List<Object> get props => [message];
}
