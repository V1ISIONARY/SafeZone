import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profileData;

  const ProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateStatusLoading extends ProfileState {}

class UpdateStatusSuccess extends ProfileState {
  final String status;

  const UpdateStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

class UpdateStatusError extends ProfileState {
  final String message;

  const UpdateStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
