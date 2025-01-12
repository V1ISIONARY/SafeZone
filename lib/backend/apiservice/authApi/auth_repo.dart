import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'package:safezone/backend/models/userModel/user_model.dart';

abstract class AuthenticationRepository {
  Future<void> userLogin(String email, String password);
  Future<void> userSignUp(
    String username,
    String email,
    String password,
    String address,
    String firstname,
    String lastname,
    bool isAdmin,
    bool isGirl,
    bool isVerified,
  );
}
