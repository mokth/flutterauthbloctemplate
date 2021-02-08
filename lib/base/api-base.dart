import 'package:shared_preferences/shared_preferences.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

import 'package:stdapp/model/user.dart';

abstract class ApiBase {
  static String url1 = Uri.encodeFull("http://www.udomain.com/yourapi/");
  static String url2 = Uri.encodeFull("http://www.udomain.com/uwebsite/");
  static String _baseUrl = url1;
  static String _erpUrl = url2;

  String get apiURL {
    if (_baseUrl == null || _baseUrl.trim() == "") {
      //getSettings();
      _baseUrl = url1;
    }
    return _baseUrl;
  }

  String get erpURL {
    return _erpUrl;
  }

  Map jsonHeader() {
    var map = new Map<String, String>();
    map["'content-type'"] = "'application/json'";
    return map;
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return;
  }

  Future<bool> hasToken() async {
    print("ada token");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return token != null;
  }

  Future<String> getToken() async {
    //print("ada token");
    final prefs = await SharedPreferences.getInstance();
    String token = "";
    try {
      String authtoken = prefs.getString('token');
      //Map<String,dynamic> jsonObj = jsonDecode(token);

      token = "Bearer " + authtoken; //jsonObj["auth_token"];
      //token = authtoken; //jsonObj["auth_token"];
    } catch (Exception) {}

    return token;
  }

  int decodeToken(String token) {
    int code = 0;
    try {
      var validator = new JWTValidator();

      var decodedToken = new JWT.parse(token);

      print("decode");
      Set<String> error = validator.validate(decodedToken);
      print(error);

      code = error.length;
      if (code > 0) {
        error.forEach((f) {
          if (f.contains("The token issuedAt time is in future")) {}
          if (f.contains(
              "The token can not be accepted due to notBefore policy")) {
            code = 0;
          }
        });
      }
      //The token issuedAt time is in future.,
      //The token can not be accepted due to notBefore policy.

    } catch (e) {
      print(e.toString());
      code = 99;
    }

    return code;
  }

  Future<User> getUserInfo() async {
    var token = await getTokenOnly();
    return getAuthTokenInfo(token);
  }

  User getAuthTokenInfo(String token) {
    User user;
    try {
      var dtoken = new JWT.parse(token);
      String rol = dtoken.getClaim('rol');
      String role = dtoken.getClaim('role');
      String id = dtoken.getClaim('id');
      String name = dtoken.getClaim('sub');
      String fname = dtoken.getClaim('fullname');

      user = User(id: id, name: name, fullname: fname, rol: rol, role: role);
    } catch (e) {
      print(e);
      user = null;
    }
    return user;
  }

  Future<String> getTokenOnly() async {
    String token = "";
    try {
      final prefs = await SharedPreferences.getInstance();
      String authToken = prefs.getString('token');
      token = (authToken == null) ? "" : authToken;
      // token = jsonObj["auth_token"];
    } catch (e) {
      token = "";
      print(e.toString());
    }

    return token;
  }
}
