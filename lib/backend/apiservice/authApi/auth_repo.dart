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
      double latitude, // New parameter for latitude
      double longitude // New parameter for longitude
      );
  Future<void> updateLocation(double latitude, double longitude);
}
