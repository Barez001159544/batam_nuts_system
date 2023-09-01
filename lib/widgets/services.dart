import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class DataServices {
  DataServices(this.username, this.password);
  // String url;
  late String username;
  late String password;

  Future login() async {
    // http.Response response= await http.get(Uri.parse('http://barezazad-001-site1.ctempurl.com/api/Authentication/login   $username/$email?apikey=94C0B7D0-7259-4242-BEAE-46DAC3E30176' as String));
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Authentication/login"
                  as String),
          body: jsonEncode({'username': username, 'password': password}),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          });
      if (response.statusCode == 200) {
        String data = response.body;
        //------
        // var data = jsonDecode(response.body.toString());
        // print(data['token']);
        // print(data);
        print(jsonDecode(response.body.toString())['accessToken']);
        print("======================");
        // String jwtToken = jsonDecode(response.body.toString())['accessToken'];
        // Map<String, dynamic> decodedToken = Jwt.parseJwt(jwtToken);
        // print(decodedToken);
        print("======================");
        print('Login successfully');
        //------
        return jsonDecode(response.body.toString())['accessToken'];
      } else {
        print("${response.body}=============");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getLogin(username, password) async {
    DataServices dataServices = DataServices(username, password);
    var rateData = await dataServices.login();
    return rateData;
  }
}
