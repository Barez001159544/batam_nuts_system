import 'package:bn_sl/models/customer_pagnation_response.dart';
import 'package:bn_sl/models/customer_response.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/services/customer_service/customer.dart';
import 'package:flutter/material.dart';

class CustomerController extends ChangeNotifier{
  final _service = Customer();
  bool isLoading = false;
  List<CustomerResponse> _customerResponse = [];
  List<CustomerResponse> get customerResponse => _customerResponse;
  Future<void> getAllCustomers() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.Get();

    _customerResponse = response!;
    isLoading = false;
    notifyListeners();
  }

  CustomerPagnationResponse? _customerPaginationResponse;
  CustomerPagnationResponse? get customerPaginationResponse=>_customerPaginationResponse;
  Future<void> getCustomerPagination(PagnationParameter pagnationParameter) async{
    isLoading=true;
    notifyListeners();
    final response= await _service.GetPagination(pagnationParameter);
    _customerPaginationResponse= response;
    print("((((((((((((((((((object))))))))))))))))))");
    print(_customerPaginationResponse);
    print("((((((((((((((((((((object))))))))))))))))))))");
    isLoading=false;
    notifyListeners();
  }

  late CustomerResponse? _customerNM;
  CustomerResponse? get customerNM=>_customerNM;
  Future<void> updateCustomer(CustomerResponse customerResponse) async{
    isLoading=true;
    notifyListeners();
    final response= await _service.Put(customerResponse);
    _customerNM= response;
    isLoading=false;
    notifyListeners();
  }

  //
}