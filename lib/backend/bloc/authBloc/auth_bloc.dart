import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:safezone/backend/apiservice/authApi/auth_repo.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authrepo;
  AuthenticationBloc(this._authrepo) : super(AuthenticationInitial()) {
    //BLOC BY MIRO
    on<UserLogin>((event, emit) async {
      final SharedPreferences login = await SharedPreferences.getInstance();
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
        );

        emit(SignUpSuccess());
      } catch (error) {
        emit(SignUpError('Sign up failed: ${error.toString()}'));
      }
    });
  }
}
