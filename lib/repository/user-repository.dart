import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stdapp/base/api-base.dart';
import 'package:stdapp/model/user.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class UserRepository extends ApiBase {
  String authToken = "";
  User user;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<String> authenticate(
      {@required String username,
      @required String password,
      @required String compCode}) async {
    //await getSettingsAysn();
    String url = apiURL + "auth/jwt1";
    Map body = loginBody(username, password, compCode);
    print(url);
    print(body);
    var response = await http.post(url, body: json.encode(body), headers: {
      'content-type': 'application/json',
    });
    print(url);
    print(response.body);
    var resp = jsonDecode(response.body);

    String _token = "";
    if (resp['ok'] == "yes") {
      try {
        _token = resp['data'];
        Map<String, dynamic> jsonObj = jsonDecode(_token);
        _token = jsonObj["auth_token"];
      } catch (e) {
        _token = "";
        print(e.toString());
      }
    } else {
      await deleteToken();
      print('invalid data');
    }
    return _token;
  }

  Map loginBody(username, password, compCode) {
    var map = new Map<String, String>();
    map["name"] = username;
    map["fullname"] = "-";
    map["password"] = password;
    map["access"] = "-";
    map["role"] = "-";
    map["company"] = compCode;
    return map;
  }

  bool isAuthenticated() {
    print("isAuthenticated 1");
    if (authToken == "") return false;
    print("isAuthenticated2");
    print("isAuthenticated2 " + authToken);
    int numError = decodeToken(authToken);

    return (numError == 0);
  }

  User getAuthUserInfo() {
    if (authToken == "" || authToken == null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      return null;
    }

    return getAuthTokenInfo(authToken);
  }
}
