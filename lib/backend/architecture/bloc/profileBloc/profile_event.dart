import 'package:equatable/equatable.dart';
import 'dart:io';

import 'package:safezone/backend/architecture/bloc/adminBloc/users/admin_users_event.dart';

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

// Get Profile Event
class GetProfileStatisticsEvent extends ProfileEvent {
  const GetProfileStatisticsEvent();

  @override
  List<Object?> get props => [];
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

class RequestAdminAccess extends ProfileEvent {
  final int userId;
  const RequestAdminAccess(this.userId);

  @override
  List<Object?> get props => [userId];
}
