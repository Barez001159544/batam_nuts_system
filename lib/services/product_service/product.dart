import 'dart:convert';

import 'package:bn_sl/models/product_response.dart';
import 'package:bn_sl/services/product_service/i_product.dart';
import 'package:http/http.dart' as http;
import '../login/auth.dart';

class Product implements IProduct{
  late String? _token=null;
  late String link;
  @override
  Future<List<ProductResponse>?> Get(int warehouseID, bool isOrder, String? search) async {
    // TODO: implement Get

    if(search==""){
      link="http://barezazad-001-site1.ctempurl.com/api/Product/GetSearch/$warehouseID/$isOrder/'$search'";
    }else if(search!=null){
      link="http://barezazad-001-site1.ctempurl.com/api/Product/GetSearch/$warehouseID/$isOrder/$search";
    }
    _token=await Auth().ReadToken();
    print("get Funcction");
    try {
      List<ProductResponse> list=[];
      http.Response response = await http.get(
          Uri.parse(
              link
              as String),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'Authorization': 'Bearer $_token',
          });
      if (response.statusCode == 200) {
        var map=jsonDecode(response.body);
        for(int i=0; i<map.length; i++){
          list.add(ProductResponse.fromJson(map[i]));
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
  //
}