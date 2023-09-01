import 'dart:convert';

import 'package:bn_sl/models/general_response.dart';
import 'package:bn_sl/services/general_service/i_general.dart';
import 'package:http/http.dart' as http;
import '../login/auth.dart';

class General implements IGeneral{
  late String? _token=null;


  @override
  Future<List<GeneralResponse>?> Get() async {
    // TODO: implement Get
    _token=await Auth().ReadToken();
    print("get Funcction");
    try {
      List<GeneralResponse> list=[];
      http.Response response = await http.get(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/General"
              as String),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        var map=jsonDecode(response.body);
        for(int i=0; i<map.length; i++){
          list.add(GeneralResponse.fromJson(map[i]));
        }
        print(" succ");
        //CustomerResponse r= CustomerResponse.fromJson();
        return list;
      } else {
        print("error");
        return null;
      }
    } catch (e) {
      print("++++++++++++++++++${e.toString()}");
    }
  }

  @override
  Future<List<GeneralResponse>?> Put(GeneralResponse generalResponse) async{//int id, String name, String value
    // TODO: implement Put
    _token=await Auth().ReadToken();
    print("get Funcction");
    print("%%%%%%%%%%%%%%%%%%%%%%");
    print(generalResponse.value);
    print("%%%%%%%%%%%%%%%%%%%%%%%%");
    try {
      List<GeneralResponse> list=[];
      http.Response response = await http.put(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/General"
              as String),
          body:
          //jsonEncode(generalResponse.toJson()),
          jsonEncode({
            "id": generalResponse.id,
            "name": generalResponse.name,
            "value": generalResponse.value,
          }),
          // jsonEncode(generalResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        var map=jsonDecode(response.body);
        for(int i=0; i<map.length; i++){
          list.add(GeneralResponse.fromJson(map[i]));
        }
        print(" succ");
        //CustomerResponse r= CustomerResponse.fromJson();
        return list;
      } else {
        print("error");
        return null;
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>>${(jsonEncode(generalResponse.toJson()))}");
      print("}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

}