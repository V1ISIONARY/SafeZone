abstract class AuthenticationEvent {}

//BLOC BY MIRO
class UserLogin extends AuthenticationEvent {
  final String email;
  final String password;

  UserLogin(this.email, this.password);
}

class UpdateLocationEvent extends AuthenticationEvent {
  final double latitude;
  final double longitude;

  UpdateLocationEvent({required this.latitude, required this.longitude});
}

class UserSignUpEvent extends AuthenticationEvent {
  final String username;
  final String email;
  final String password;
  final String address;
  final String firstname;
  final String lastname;
  final bool isAdmin;
  final bool isGirl;
  final bool isVerified;
  final double longitude;
  final double latitude;

  UserSignUpEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.firstname,
    required this.lastname,
    required this.isAdmin,
    required this.isGirl,
    required this.isVerified,
    required this.longitude,
    required this.latitude,
  });
}
