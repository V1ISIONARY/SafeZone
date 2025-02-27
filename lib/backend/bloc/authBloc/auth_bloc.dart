import 'package:bloc/bloc.dart';
import 'package:safezone/backend/apiservice/authApi/auth_repo.dart';
import 'package:safezone/backend/bloc/authBloc/auth_event.dart';
import 'package:safezone/backend/bloc/authBloc/auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authrepo;
  AuthenticationBloc(this._authrepo) : super(AuthenticationInitial()) {
    //BLOC BY MIRO
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
            event.latitude);

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
  }
}
