import 'package:bn_sl/models/login_request.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/response_login.dart';

class UserManager {
  Future<ResponseLogin?> login(LoginRequest loginRequest) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Authentication/login"
                  as String),
          body: jsonEncode(loginRequest.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if (response.statusCode == 200) {
        ResponseLogin r= ResponseLogin.fromJson(jsonDecode(response.body));
        Auth().SaveToken(r.accessToken!);
        return r;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
