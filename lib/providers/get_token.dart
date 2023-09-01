import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../new_oreder.dart';
import '../services/login/auth.dart';

class GetToken extends ChangeNotifier{
  Map<String, dynamic> _dToken={};
  Map<String, dynamic> get dToken=> _dToken;
  void readToken() async{
    // _token= await Auth().ReadToken();
    _dToken = Jwt.parseJwt("${await Auth().ReadToken()}");
    notifyListeners();
  }
}