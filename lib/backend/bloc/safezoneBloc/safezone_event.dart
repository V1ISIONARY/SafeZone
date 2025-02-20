import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneEvent extends Equatable {
  const SafeZoneEvent();

  @override
  List<Object> get props => [];
}

// Fetch all safe zones
class FetchSafeZones extends SafeZoneEvent {}

class FetchAllSafeZones extends SafeZoneEvent {}

// Fetch a safe zone by ID
class FetchSafeZoneById extends SafeZoneEvent {
  final int id;

  const FetchSafeZoneById(this.id);

  @override
  List<Object> get props => [id];
}

// Fetch safe zones by status
class FetchSafeZonesByStatus extends SafeZoneEvent {
  final String status;

  const FetchSafeZonesByStatus(this.status);

  @override
  List<Object> get props => [status];
}

// Fetch safe zones by user ID
class FetchSafeZonesByUserId extends SafeZoneEvent {
  final int userId;

  const FetchSafeZonesByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

// Fetch status history for a safe zone
class FetchStatusHistory extends SafeZoneEvent {
  final int safeZoneId;

  const FetchStatusHistory(this.safeZoneId);

  @override
  List<Object> get props => [safeZoneId];
}

// Create a new safe zone
class CreateSafeZone extends SafeZoneEvent {
  final SafeZoneModel safeZone;

  const CreateSafeZone(this.safeZone);

  @override
  List<Object> get props => [safeZone];
}

// Update a safe zone
class UpdateSafeZone extends SafeZoneEvent {
  final SafeZoneModel safeZone;

  const UpdateSafeZone(this.safeZone);

  @override
  List<Object> get props => [safeZone];
}

// Delete a safe zone
class DeleteSafeZone extends SafeZoneEvent {
  final int id;

  const DeleteSafeZone(this.id);

  @override
  List<Object> get props => [id];
}
