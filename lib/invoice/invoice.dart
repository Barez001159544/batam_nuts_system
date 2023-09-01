import 'dart:convert';

import 'package:bn_sl/invoice/i_invoice.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/models/return_invoice_pagination.dart';
import 'package:http/http.dart' as http;
import '../services/login/auth.dart';

class Invoice implements IInvoice{
  late String? _token=null;
  @override
  Future<ReturnInvoicePagination?> GetPagination(PagnationParameter pagnationParameter) async {
    _token=await Auth().ReadToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              "http://barezazad-001-site1.ctempurl.com/api/RepresentativeInvoice/GetPagination"
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
        return ReturnInvoicePagination.fromJson(map);
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