import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapDataLoaded extends MapState {
  final List<SafeZoneModel> safeZones;
  final List<DangerZoneModel> dangerZones;
  final List<Map<String, dynamic>> members;

  const MapDataLoaded(this.safeZones, this.dangerZones, this.members);

  @override
  List<Object> get props => [safeZones, dangerZones, members];
}

class MemberLocationUpdated extends MapState {
  final String userId;
  final double latitude;
  final double longitude;

  const MemberLocationUpdated(this.userId, this.latitude, this.longitude);

  @override
  List<Object> get props => [userId, latitude, longitude];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}
