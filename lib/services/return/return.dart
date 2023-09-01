import 'dart:convert';

import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/models/return_pagnation_response.dart';
import 'package:bn_sl/models/return_response.dart';
import 'package:bn_sl/return_heade_response.dart';
import 'package:bn_sl/services/return/i_return.dart';
import 'package:http/http.dart' as http;
import '../login/auth.dart';

class ReturnHeadeClass implements IReturnHeade{
  late String? _token=null;
  @override
  Future<ReturnHeadeResponse?> ReturnHeade(ReturnHeadeResponse returnHeadeResponse) async{
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/ReturnHeade"
              as String),
          body: jsonEncode(returnHeadeResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        print(" succ");
        // print("^^^^^^^^^^^^^^^^^^^^^^$returnHeadeResponse");
        return ReturnHeadeResponse.fromJson(jsonDecode(response.body));
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        // print(jsonEncode(returnHeadeResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

  @override
  Future<ReturnResponse?> Return(ReturnResponse returnResponse) async{
    _token=await Auth().ReadToken();
    try {
      print(jsonEncode(returnResponse.toJson()));
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Return"
              as String),
          body: jsonEncode(returnResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        print(" succ");
        // print("^^^^^^^^^^^^^^^^^^^^^^$returnHeadeResponse");
        return ReturnResponse.fromJson(jsonDecode(response.body));
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        // print(jsonEncode(returnHeadeResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

  @override
  Future<ReturnPagnationResponse?> ReturnPagnation(PagnationParameter pagnationParameter) async {
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/ReturnHeade/GetPagination"
              as String),
          body: jsonEncode(pagnationParameter.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        // print(" ${response.body}");
        var map=jsonDecode(response.body);

        // print(map);
        return ReturnPagnationResponse.fromJson(map);
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        // print(jsonEncode(orderDetailsResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
    return null;
  }

  @override
  Future<List<ReturnResponse>?> ReturnById(int id) async{
    _token=await Auth().ReadToken();
    List<ReturnResponse> list=[];
    print("@@@@@@@@@@@@@@@@@@@@@$id");
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Return/GetByHeade/$id"
              as String),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        print("&&&&&&&&&&&&&&&${jsonDecode(response.body)}");
        var map=jsonDecode(response.body);
        for(int i=0; i<map.length; i++){
          list.add(ReturnResponse.fromJson(map[i]));
        }
        print(" succ");
        // print("^^^^^^^^^^^^^^^^^^^^^^$returnHeadeResponse");
        // print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${list[0].isActive}");
        return list;
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        // print(jsonEncode(returnHeadeResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

}