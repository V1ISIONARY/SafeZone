import 'package:equatable/equatable.dart';

abstract class MapPageEvent extends Equatable {
  const MapPageEvent();

  @override
  List<Object> get props => [];
}

class FetchMapData extends MapPageEvent {}

class ListenForMemberLocations extends MapPageEvent {
  final List<Map<String, dynamic>> members;
  final int userId; 
  const ListenForMemberLocations(this.members, this.userId);

  @override
  List<Object> get props => [members, userId];
}
