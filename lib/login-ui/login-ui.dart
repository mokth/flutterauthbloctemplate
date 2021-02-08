import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stdapp/bloc/login/login-bloc.dart';
import 'package:stdapp/bloc/login/login-events.dart';
import 'package:stdapp/bloc/login/login-states.dart';
import 'package:stdapp/utilities/display-util.dart';

class Login extends StatefulWidget {
  final LoginState state;
  Login(this.state);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _compController = TextEditingController();
  LoginBloc loginBloc;
  LoginState state;
  double _curScaleFactor = 1.0;

  BuildContext _context;

  void initState() {
    super.initState();
    _curScaleFactor = 1.0;
    _usernameController.text = "";
    _passwordController.text = "";
    _compController.text = "";
    loginBloc = BlocProvider.of<LoginBloc>(context);
    state = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _curScaleFactor = DisplayUtil.getcurScaleFactor(context);
    double fontsize1 = _curScaleFactor >= 1.6 ? 14 : 13;
    return Column(
      children: <Widget>[
        // Padding(
        //   padding: EdgeInsets.fromLTRB(
        //       20, MediaQuery.of(context).size.height / 2.3, 20, 0),
        //   //.only(top: MediaQuery.of(context).size.height / 2.3),
        // ),
        Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      //style: TextStyle(fontSize: fontsize1 * _curScaleFactor),
                      decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).primaryColor,
                          //       width: 1.0),
                          // ),
                          prefix: Icon(Icons.person),
                          labelText: "User ID",
                          filled: true,
                          fillColor: Colors.white),
                      controller: _usernameController,
                      obscureText: false,
                    ),
                    TextFormField(
                      //style: TextStyle(fontSize: fontsize1 * _curScaleFactor),
                      decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).primaryColor,
                          //       width: 1.0),
                          // ),
                          prefix: Icon(Icons.person),
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.white),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    TextFormField(
                      //style: TextStyle(fontSize: fontsize1 * _curScaleFactor),
                      decoration: InputDecoration(
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).primaryColor,
                          //       width: 1.0),
                          // ),
                          prefix: Icon(Icons.person),
                          labelText: "Company Code",
                          filled: true,
                          fillColor: Colors.white),
                      controller: _compController,
                      obscureText: true,
                    ),
                  ],
                )),

            ///holds email header and inputField

            Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                roundedRectButton("Login", signInGradients, widget.state,
                    _onLoginButtonPressed),
                VerticalDivider(width: 20, color: Colors.transparent),
                roundedRectButton("Settings", signUpGradients, widget.state,
                    _onSettingButtonPressed),
              ],
            )
          ],
        )
      ],
    );
  }

  _onLoginButtonPressed() {
    loginBloc.add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
        compCode: _compController.text));
  }

  _onSettingButtonPressed() {
    // var push = Navigator.push(
    //   context,
    //   new CustomRoute(builder: (context) => new Settings()),
    // );
  }

  Widget roundedRectButton(String title, List<Color> gradient, LoginState state,
      Function pressFunction) {
    return Builder(builder: (BuildContext mContext) {
      return InkWell(
        onTap: state is! LoginLoading ? pressFunction : null,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Stack(
            alignment: Alignment(1.0, 0.0),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(mContext).size.width / 2.7,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13 * _curScaleFactor,
                        fontWeight: FontWeight.w500)),
                padding: EdgeInsets.only(top: 9, bottom: 9),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Color> signInGradients = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];

  List<Color> signUpGradients = [
    Color(0xFFFF9945),
    Color(0xFFFc6076),
  ];
}
