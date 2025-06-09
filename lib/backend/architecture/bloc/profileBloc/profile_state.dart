import 'package:equatable/equatable.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';

class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ProfileInitial extends ProfileState {}

// Loading States
class ProfileLoading extends ProfileState {}

class UpdateStatusLoading extends ProfileState {}

// Loaded States
class ProfileLoaded extends ProfileState {
  final ProfileModel profileData;

  const ProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class ProfilePictureLoaded extends ProfileState {
  final String profilePictureUrl;

  const ProfilePictureLoaded(this.profilePictureUrl);

  @override
  List<Object?> get props => [profilePictureUrl];
}

// Success States
class UpdateStatusSuccess extends ProfileState {
  final String status;

  const UpdateStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

class ProfilePictureUploaded extends ProfileState {
  final String profilePictureUrl;

  const ProfilePictureUploaded(this.profilePictureUrl);

  @override
  List<Object?> get props => [profilePictureUrl];
}

// Error States
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateStatusError extends ProfileState {
  final String message;

  const UpdateStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
