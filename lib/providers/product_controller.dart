import 'package:bn_sl/services/product_service/product.dart';
import 'package:flutter/material.dart';

import '../models/product_response.dart';

class ProductController extends ChangeNotifier{
  final _service = Product();
  bool isLoading = false;
  List<ProductResponse> _productsView=[];
  List<ProductResponse> get productsView=>_productsView;

  Future<void> getAllProducts()async {
    isLoading=true;
    notifyListeners();
    final response= await _service.Get(1, false, "");
    _productsView= response!;
    isLoading=false;
    notifyListeners();
  }
}