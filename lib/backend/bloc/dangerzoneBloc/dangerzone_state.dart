import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

abstract class DangerZoneState extends Equatable {
  const DangerZoneState();

  @override
  List<Object> get props => [];
}

class DangerZonesLoading extends DangerZoneState {}

class DangerZonesLoaded extends DangerZoneState {
  final List<DangerZoneModel> dangerZones;

  const DangerZonesLoaded(this.dangerZones);

  @override
  List<Object> get props => [dangerZones];
}

class DangerZonesError extends DangerZoneState {
  final String message;

  const DangerZonesError(this.message);

  @override
  List<Object> get props => [message];
}
