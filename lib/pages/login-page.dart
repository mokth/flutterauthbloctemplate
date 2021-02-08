import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stdapp/bloc/auth/authbloc.dart';
import 'package:stdapp/bloc/login/login-bloc.dart';
import 'package:stdapp/bloc/login/login-states.dart';
import 'package:stdapp/login-ui/background.dart';
import 'package:stdapp/login-ui/login-ui.dart';
import 'package:stdapp/repository/user-repository.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  UserRepository _userRepository;
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    print("login page");
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
            userRepository: _userRepository,
            authenticationBloc: _authenticationBloc),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (
            BuildContext context,
            LoginState state,
          ) {
            if (state is LoginFailure) {
              _onWidgetDidBuild(() {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Stack(
                children: <Widget>[
                  Background(),
                  SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20,
                            MediaQuery.of(context).size.height / 2.5, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Login(state),
                            Container(
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator()
                                  : null,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
