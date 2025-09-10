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

class UpdateMemberLocation extends MapPageEvent {
  final String userId;
  final double latitude;
  final double longitude;

  const UpdateMemberLocation(this.userId, this.latitude, this.longitude);

  @override
  List<Object> get props => [userId, latitude, longitude];

  @override
  String toString() =>
      'UpdateMemberLocation(userId: $userId, lat: $latitude, lng: $longitude)';
}

class RefreshMapData extends MapPageEvent {
  final String reason; 

  const RefreshMapData({this.reason = 'manual'});

  @override
  List<Object> get props => [reason];
}
