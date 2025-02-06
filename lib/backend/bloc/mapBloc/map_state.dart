import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

// Initial state
class MapInitial extends MapState {}

// Loading state
class MapLoading extends MapState {}

// Loaded state for safe zones and danger zones
class MapDataLoaded extends MapState {
  final List<SafeZoneModel> safeZones;
  final List<DangerZoneModel> dangerZones;

  const MapDataLoaded(this.safeZones, this.dangerZones);

  @override
  List<Object> get props => [safeZones, dangerZones];
}

// Error state
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}