import 'package:task/model/ErrorViewModel.dart';
import 'package:bloc/bloc.dart';
import 'package:task/resources/Constants.dart';
import 'package:task/resources/NetworkHelper.dart';
import 'package:task/resources/Repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  @override
  // TODO: implement initialState
  AuthenticationStates get initialState => AuthenticationLoadingState();

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    bool isConnected = await NetworkHelper.isNetworkAvailable();

    if (isConnected == false) {
      yield AuthenticationErrorState(
        failureReason: ErrorViewModel(
          errorMessage: Constants.NETWORK_ERROR_MESSAGE,
          errorCode: 0,
        ),
      );
      return;
    }

    if (event is AuthenticateUser) {
      yield AuthenticationLoadingState();

      bool isUserAuthenticated = await Repository.authenticateUser();
      if (isUserAuthenticated) {
        yield AuthenticationSuccessState();
      } else
        yield AnonymousUserState();
      return;
    } else if (event is Login) {
      bool isUserLoginSuccess = await Repository.loginUser();
      if (isUserLoginSuccess) {
        yield AuthenticationSuccessState();
      } else
        yield AnonymousUserState();
      return;
    } else if (event is Logout) {
      bool isUserLoginSuccess = await Repository.logoutUser();
      if (isUserLoginSuccess) {
        yield AuthenticationSuccessState();
      } else
        yield AnonymousUserState();
      return;
    }
  }
}

//-------------- Events ---------------------

abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents {}

class Login extends AuthenticationEvents {}

class Logout extends AuthenticationEvents {}

//------------- States ------------------------

abstract class AuthenticationStates {}

class AnonymousUserState extends AuthenticationLoadingState {}

class AuthenticationLoadingState extends AuthenticationStates {}

class AuthenticationSuccessState extends AuthenticationStates {}

class AuthenticationErrorState extends AuthenticationStates {
  final ErrorViewModel failureReason;
  AuthenticationErrorState({this.failureReason});
}
