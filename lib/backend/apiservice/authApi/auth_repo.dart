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
      double latitude,
      double longitude 
      );
  Future<void> updateLocation(double latitude, double longitude);
  Future<void> changePassword(String password, String newpassword);
  Future<void> resetPassword(String email, String password, String newpassword);
}
