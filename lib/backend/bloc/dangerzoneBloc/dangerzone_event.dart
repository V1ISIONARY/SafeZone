import 'package:equatable/equatable.dart';

abstract class DangerZoneEvent extends Equatable {
  const DangerZoneEvent();

  @override
  List<Object> get props => [];
}

class FetchDangerZones extends DangerZoneEvent {}

class FetchDangerZoneById extends DangerZoneEvent {
  final int id;

  const FetchDangerZoneById(this.id);

  @override
  List<Object> get props => [id];
}