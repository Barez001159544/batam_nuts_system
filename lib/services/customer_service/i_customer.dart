
import 'package:bn_sl/models/customer_pagnation_response.dart';
import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/general_response.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/models/product_response.dart';
import 'package:bn_sl/models/return_pagnation_response.dart';

abstract class ICustomer{
  Future<List<CustomerResponse>?> Get();
  Future<CustomerResponse?> Post(CustomerResponse customerResponse);
  Future<CustomerResponse?> Put(CustomerResponse customerResponse);
  Future<CustomerPagnationResponse?> GetPagination(PagnationParameter pagnationParameter);
}



