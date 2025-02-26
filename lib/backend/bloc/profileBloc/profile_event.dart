import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Get Profile Event
class GetProfileEvent extends ProfileEvent {
  final int userId;

  const GetProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Update Status Event
class UpdateStatusEvent extends ProfileEvent {
  final int userId;
  final String status;

  const UpdateStatusEvent(this.userId, this.status);

  @override
  List<Object?> get props => [userId, status];
}

// Upload Profile Picture Event
class UploadProfilePictureEvent extends ProfileEvent {
  final int userId;
  final File imageFile;

  const UploadProfilePictureEvent(this.userId, this.imageFile);

  @override
  List<Object?> get props => [userId, imageFile];
}

// Get Profile Picture Event
class GetProfilePictureEvent extends ProfileEvent {
  final int userId;

  const GetProfilePictureEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
