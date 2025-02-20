import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final int userId;

  const GetProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
