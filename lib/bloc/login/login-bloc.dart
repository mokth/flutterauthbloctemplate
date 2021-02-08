import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:stdapp/bloc/auth/authbloc.dart';
import 'package:stdapp/bloc/auth/authevents.dart';
import 'package:stdapp/repository/user-repository.dart';

import 'login-events.dart';
import 'login-states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  }) : super(LoginInitial()) {
    assert(userRepository != null);
    assert(authenticationBloc != null);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
            username: event.username,
            password: event.password,
            compCode: event.compCode);
        if (token != "") {
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: "Invalid user id / password");
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
