import 'package:equatable/equatable.dart';

abstract class SafeZoneAdminEvent extends Equatable {
  const SafeZoneAdminEvent();

  @override
  List<Object> get props => [];
}

class VerifySafeZone extends SafeZoneAdminEvent {
  final int id;

  const VerifySafeZone(this.id);

  @override
  List<Object> get props => [id];
}

class RejectSafeZone extends SafeZoneAdminEvent {
  final int id;

  const RejectSafeZone(this.id);

  @override
  List<Object> get props => [id];
}

class ReviewSafeZone extends SafeZoneAdminEvent {
  final int id;

  const ReviewSafeZone(this.id);

  @override
  List<Object> get props => [id];
}
