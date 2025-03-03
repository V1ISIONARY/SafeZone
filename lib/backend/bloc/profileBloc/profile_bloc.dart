import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/profileApi/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    // Get Profile Event
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profileData = await profileRepository.getProfile(event.userId);
        if (profileData != null) {
          emit(ProfileLoaded(profileData));
        } else {
          emit(const ProfileError("Profile not found"));
        }
      } catch (e) {
        emit(ProfileError("Error fetching profile: $e"));
      }
    });

    // Update Status Event
    on<UpdateStatusEvent>((event, emit) async {
      emit(UpdateStatusLoading());
      try {
        final success =
            await profileRepository.updateStatus(event.userId, event.status);
        if (success) {
          emit(UpdateStatusSuccess(event.status));
        } else {
          emit(const UpdateStatusError("Failed to update status"));
        }
      } catch (e) {
        emit(UpdateStatusError("Error updating status: $e"));
      }
    });

    // Upload Profile Picture Event
    on<UploadProfilePictureEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profilePictureUrl = await profileRepository.uploadProfilePicture(
            event.userId, event.imageFile);
        if (profilePictureUrl != null) {
          emit(ProfilePictureUploaded(profilePictureUrl));
        } else {
          emit(const ProfileError("Failed to upload profile picture"));
        }
      } catch (e) {
        emit(ProfileError("Error uploading profile picture: $e"));
      }
    });

    // Get Profile Picture Event
    on<GetProfilePictureEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profilePictureUrl =
            await profileRepository.getProfilePicture(event.userId);
        if (profilePictureUrl != null) {
          emit(ProfilePictureLoaded(profilePictureUrl));
        } else {
          emit(const ProfileError("Profile picture not found"));
        }
      } catch (e) {
        emit(ProfileError("Error fetching profile picture: $e"));
      }
    });
  }
}
