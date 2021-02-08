import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stdapp/repository/user-repository.dart';

import 'authevents.dart';
import 'authstates.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(AuthenticationUninitialized()) {
    _authenticationStatusSubscription = userRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final UserRepository userRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    print("event " + event.toString());

    if (event is AppStarted) {
      // when app just start no login before
      yield AuthenticationUninitialized();
    }

    if (event is CheckAuth) {
      print('event is CheckAuth');
      //check the auth, may be login before
      final String hasToken = await userRepository.getTokenOnly();
      userRepository.authToken = "";
      print("hasToken " + hasToken.length.toString());
      if (hasToken != "") {
        if (userRepository.decodeToken(hasToken) == 0) {
          userRepository.authToken = hasToken;
          //have token consider login
          yield AuthenticationAuthenticated();
        } else {
          //no token, just delete again (double confirm to remove token)
          await userRepository.deleteToken();
          yield AuthenticationUnauthenticated();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      //success login persit token
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      userRepository.authToken = event.token;
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      // user request to logout
      userRepository.authToken = "";
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }

    //this is use for, when the token is expired during app running
    if (event is AuthenticationStatusChanged) {
      if (event.status != AuthenticationStatus.authenticated) {
        userRepository.authToken = "";
        yield AuthenticationLoading();
        await userRepository.deleteToken();
        yield AuthenticationUnauthenticated();
      }
    }
  }
}
