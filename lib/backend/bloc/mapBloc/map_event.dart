import 'package:equatable/equatable.dart';

abstract class MapPageEvent extends Equatable {
  const MapPageEvent();

  @override
  List<Object> get props => [];
}

class FetchMapData extends MapPageEvent {}
