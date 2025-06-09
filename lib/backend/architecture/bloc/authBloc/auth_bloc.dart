import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/architecture/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/architecture/bloc/authBloc/auth_state.dart';
import 'package:safezone/backend/repository/authApi/auth_repo.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authrepo;
  AuthenticationBloc(this._authrepo) : super(AuthenticationInitial()) {
    on<UserLogin>((event, emit) async {
      emit(LoginLoading());
      try {
        await _authrepo.userLogin(event.email, event.password);
        emit(LoginSuccess(event.email, event.password));
      } catch (e) {
        emit(LoginError('Error logging in: ${e.toString()}'));
      }
    });

    on<UserSignUpEvent>((event, emit) async {
      emit(SignUpnLoading());
      try {
        await _authrepo.userSignUp(
            event.username,
            event.email,
            event.password,
            event.address,
            event.firstname,
            event.lastname,
            event.isAdmin,
            event.isGirl,
            event.isVerified,
            event.longitude,
            event.latitude,
            event.age);

        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpError('Sign up failed: ${error.toString()}'));
      }
    });

    on<UpdateLocationEvent>((event, emit) async {
      emit(UpdateLocationLoading());
      try {
        // Call the repository or API to update the location here
        await _authrepo.updateLocation(event.latitude, event.longitude);

        emit(UpdateLocationSuccess(event.latitude, event.longitude));
      } catch (e) {
        emit(UpdateLocationError('Failed to update location: ${e.toString()}'));
      }
    });

    on<CheckEmailEvent>((event, emit) async {
      emit(UpdateLocationLoading());
      try {
        final response = await _authrepo.checkEmail(event.email);
        emit(EmailCheckSuccess());
      } catch (e) {
        emit(EmailCheckError("Failed to check email: ${e.toString()}"));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(UpdateLocationLoading());
      try {
        await _authrepo.resetPassword(
            event.email, event.password, event.newPassword);
        emit(UpdateMyPasswordSuccess(
            event.email, event.password, event.newPassword));
      } catch (e) {
        emit(UpdateMyPasswordError(
            'Failed to change password: ${e.toString()}'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(UpdateLocationLoading());
      try {
        await _authrepo.changePassword(event.password, event.newPassword);
        emit(UpdatePasswordSuccess(event.password, event.newPassword));
      } catch (e) {
        emit(UpdatePasswordError('Failed to change password: ${e.toString()}'));
      }
    });
  }
}
