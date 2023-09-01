
import 'dart:convert';

import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/general_response.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/models/product_response.dart';
import 'package:bn_sl/models/return_pagnation_response.dart';
import 'package:bn_sl/services/customer_service/i_customer.dart';
import 'package:bn_sl/services/login/auth.dart';
import 'package:http/http.dart' as http;

import '../../models/customer_pagnation_response.dart';

class Customer implements ICustomer{
  late String? _token=null;

  @override
  Future<List<CustomerResponse>?> Get() async{
    // TODO: implement Get
    _token=await Auth().ReadToken();
    print("get Funcction");
    try {
      List<CustomerResponse> list=[];
      http.Response response = await http.get(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Customer"
              as String),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        var map=jsonDecode(response.body);
        for(int i=0; i<map.length; i++){
          list.add(CustomerResponse.fromJson(map[i]));
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
  Future<CustomerResponse?> Post(CustomerResponse customerResponse) async {
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Customer"
              as String),
          body: jsonEncode(customerResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        // print(" ${response.body}");

        // print(map);
        return CustomerResponse.fromJson(jsonDecode(response.body));
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
  Future<CustomerPagnationResponse?> GetPagination(PagnationParameter pagnationParameter) async{
    _token=await Auth().ReadToken();

    try {
      print(jsonEncode(pagnationParameter.toJson()));
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Customer/GetPagination"
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
        return CustomerPagnationResponse.fromJson(map);
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
  Future<CustomerResponse?> Put(CustomerResponse customerResponse) async{
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.put(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Customer"
              as String),
          body: jsonEncode(customerResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        // print(" ${response.body}");

        // print(map);
        return CustomerResponse.fromJson(jsonDecode(response.body));
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
}