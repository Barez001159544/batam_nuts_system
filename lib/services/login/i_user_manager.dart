import 'package:bn_sl/models/login_request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/response_login.dart';

abstract  class IUserManager {

   Future<ResponseLogin?> getLogin(LoginRequest login);

}