import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => props;
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String compCode;

  LoginButtonPressed(
      {@required this.username,
      @required this.password,
      @required this.compCode});

  @override
  List<Object> get props => [username, password, compCode];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}
