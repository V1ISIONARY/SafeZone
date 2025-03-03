import 'dart:io';
import 'package:safezone/backend/models/userModel/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> getProfile(int id);
  Future<bool> updateStatus(int userId, String status);
  Future<String?> uploadProfilePicture(int userId, File imageFile);
  Future<String?> getProfilePicture(int userId);
}
