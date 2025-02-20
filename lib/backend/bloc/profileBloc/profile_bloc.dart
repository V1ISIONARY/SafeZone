import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/profileApi/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
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
  }
}
