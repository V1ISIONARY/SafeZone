import 'package:safezone/backend/models/userModel/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> getProfile(int id);
}
