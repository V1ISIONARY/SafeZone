import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneAdminState extends Equatable {
  const SafeZoneAdminState();

  @override
  List<Object> get props => [];
}

class SafeZoneAdminInitial extends SafeZoneAdminState {}

class SafeZoneAdminLoading extends SafeZoneAdminState {}

class SafeZoneAdminSuccess extends SafeZoneAdminState {
  final SafeZoneModel safeZoneModel; // Include the updated safe zone model
  final String message;

  const SafeZoneAdminSuccess(this.safeZoneModel, this.message);

  @override
  List<Object> get props => [safeZoneModel, message];
}

class SafeZoneAdminFailure extends SafeZoneAdminState {
  final String error;

  const SafeZoneAdminFailure(this.error);

  @override
  List<Object> get props => [error];
}

class SafeZoneAdminLoaded extends SafeZoneAdminState {
  final List<SafeZoneModel> safeZones;

  const SafeZoneAdminLoaded(this.safeZones);

  @override
  List<Object> get props => [safeZones];
}

