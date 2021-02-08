import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stdapp/pages/loading-indicator.dart';
import 'package:stdapp/pages/splash-page.dart';

import 'bloc/auth/authbloc.dart';
import 'bloc/auth/authstates.dart';
import 'pages/home.dart';
import 'pages/login-page.dart';
import 'repository/user-repository.dart';

void main() {
  runApp(App(
    userRepository: UserRepository(),
  ));
}

class App extends StatefulWidget {
  App({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  UserRepository userRepository;

  @override
  @override
  void initState() {
    super.initState();
    userRepository = widget.userRepository;
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: userRepository,
        child: BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(userRepository: userRepository),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, AuthenticationState state) {
              return MaterialApp(
                  theme: ThemeData(
                    fontFamily: 'OpenSans',
                    brightness: Brightness.light,
                    primaryColor: Color(0xff003c7e),
                    accentColor: Color(0xff4487c7),
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Color(0xff34495E)),
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder:
                          (BuildContext context, AuthenticationState state) {
                    print(state);
                    if (state is AuthenticationUninitialized) {
                      return SplashPage(); //authenticationBloc);
                    }

                    if (state is AuthenticationAuthenticated) {
                      print("yes not auth yet");
                      if (!userRepository.isAuthenticated()) return LoginPage();
                      return HomePage();
                    }

                    if (state is AuthenticationUnauthenticated) {
                      return LoginPage();
                    }
                    if (state is AuthenticationLoading) {
                      return LoadingIndicator();
                    }

                    return Text('');
                  }));
            })));
  }
}
