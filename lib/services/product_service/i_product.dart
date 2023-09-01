import '../../models/product_response.dart';

abstract class IProduct {
  //
  Future<List<ProductResponse>?> Get(int warehouseID, bool isOrder, String search,);

}