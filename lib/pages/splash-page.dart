import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stdapp/bloc/auth/authbloc.dart';
import 'package:stdapp/bloc/auth/authevents.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  AuthenticationBloc bloc;
  bool _isDone = false;
  bool _isRun = false;

  @override
  void initState() {
    super.initState();
    _isDone = false;
    _isRun = false;
    initSystem();
    bloc = BlocProvider.of<AuthenticationBloc>(context);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 3));
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.easeOutCirc);

    animation.addListener(() => this.setState(() {}));
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isRun = true;
        //animationController.dispose();
        //animationController = null;
        if (_isDone) {
          bloc.add(CheckAuth());
        }
      }
    });
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    //startTime();
  }

  Future initSystem() async {
    // DataHelperSingleton datahlp = DataHelperSingleton.getInstance();
    // await datahlp.iniSettingDB();
    // await ConnectionSingleton.getInstance().init();
    // await ThemeColor.refreshTheme();
    _isDone = true;
    if (_isRun) {
      bloc.add(CheckAuth());
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    "Powered By Wincom IT Solutions",
                    style: TextStyle(fontSize: 15),
                  )
                  // new Image.asset(
                  //   'assets/images/powered_by.png',
                  //   height: 25.0,
                  //   fit: BoxFit.scaleDown,
                  // )
                  )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
