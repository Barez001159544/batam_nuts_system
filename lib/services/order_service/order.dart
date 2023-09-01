import 'dart:convert';

import 'package:bn_sl/models/order_details_response.dart';
import 'package:bn_sl/models/order_pagnation_response.dart';
import 'package:bn_sl/models/order_response.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/services/order_service/i_order.dart';
import 'package:http/http.dart' as http;
import '../login/auth.dart';

class Order implements IOrder{
  late String? _token=null;
  @override
  Future<OrderResponse?> Upload(OrderResponse orderResponse) async {
    // TODO: implement Put
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Order"
              as String),
          body: jsonEncode(orderResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        print(" ${response.body}");
      return OrderResponse.fromJson(jsonDecode(response.body));
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        print(jsonEncode(orderResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

  @override
  Future<OrderPagnationResponse?> OrderPagnation(PagnationParameter pagnationParameter) async{
    _token=await Auth().ReadToken();
    List<OrderPagnationResponse> list=[];
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/Order/GetPagination"
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
        return OrderPagnationResponse.fromJson(map);
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

class OrderDetails implements IOrderDetails{
  late String? _token=null;

  @override
  Future<OrderDetailsResponse?> OrderDetailsUpload(OrderDetailsResponse orderDetailsResponse) async {
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/OrderDetail"
              as String),
          body: jsonEncode(orderDetailsResponse.toJson()),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 201) {
        print(" succ");
        print("^^^^^^^^^^^^^^^^^^^^^^$orderDetailsResponse");
        return OrderDetailsResponse.fromJson(jsonDecode(response.body));
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.body}");
        print(jsonEncode(orderDetailsResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }

  @override
  Future<List<OrderDetailsResponse>?> GetOrderById(String orderId) async{
    _token=await Auth().ReadToken();
    List<OrderDetailsResponse>? list=[];
    try {
      http.Response response = await http.get(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/OrderDetail/GetByOrdr/$orderId"
              as String),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        print(" succ");
        // print("${OrderDetailsResponse.fromJson(jsonDecode(response.body))}%%%%%%%%%%%");
        // var map=jsonDecode(response.body);
        for(int i=0; i<json.decode(response.body).length; i++){
          print(i);
          list.add(OrderDetailsResponse.fromJson(json.decode(response.body)[i]));
        }
        // print(list);
        return list;
        //CustomerResponse r= CustomerResponse.fromJson();
      } else {
        print("error${response.statusCode}");
        print(90909090909);
        // print(jsonEncode(orderDetailsResponse.toJson()));
        return null;
      }
    } catch (e) {
      print("}}}}}}}}}}}}}}}}}}}}}}}}}${e}");
    }
  }



}
