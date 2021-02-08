import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stdapp/bloc/auth/authbloc.dart';
import 'package:stdapp/bloc/auth/authevents.dart';
import 'package:stdapp/bloc/auth/authstates.dart';
import 'package:stdapp/repository/user-repository.dart';
import 'package:stdapp/utilities/display-util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthenticationBloc _authenticationBloc;
  UserRepository _userRepository;

  @override
  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _userRepository = RepositoryProvider.of<UserRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Divider(
                height: 40,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                child: DisplayUtil.entryText("Log out", fontSize: 14),
                onPressed: () {
                  _authenticationBloc.add(LoggedOut());
                },
              ),
              Divider(
                height: 40,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                child:
                    DisplayUtil.entryText("Test token Expired", fontSize: 14),
                onPressed: () async {
                  await _userRepository.deleteToken();
                  _userRepository.authToken = "";
                  var user = _userRepository.getAuthUserInfo();
                },
              ),
            ])));
  }
}
