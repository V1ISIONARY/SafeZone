abstract class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class UserLogingIn extends AuthenticationState {}

class UserSignUp extends AuthenticationState {
  final String username;
  final String email;
  final String password;
  final String address;
  final String firstname;
  final String lastname;
  final bool isAdmin;
  final bool isGirl;
  final bool isVerified;

  UserSignUp({
    required this.username,
    required this.email,
    required this.password,
    required this.address,
    required this.firstname,
    required this.lastname,
    required this.isAdmin,
    required this.isGirl,
    required this.isVerified,
  });
}

class LoginSuccess extends AuthenticationState {
  final String email;
  final String password;

  LoginSuccess(this.email, this.password);
}

class LoginFailed extends AuthenticationState {
  final String message;

  LoginFailed(this.message);
}

class LoginError extends AuthenticationState {
  final String message;

  LoginError(this.message);
}

class LoginLoading extends AuthenticationState {}

class SignUpSuccess extends AuthenticationState {}

class SignUpFailed extends AuthenticationState {
  final String message;

  SignUpFailed(this.message);
}

class SignUpError extends AuthenticationState {
  final String message;

  SignUpError(this.message);
}

class SignUpnLoading extends AuthenticationState {}
