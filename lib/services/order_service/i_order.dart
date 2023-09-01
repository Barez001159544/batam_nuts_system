import 'package:bn_sl/models/order_pagnation_response.dart';
import 'package:bn_sl/models/order_response.dart';
import 'package:bn_sl/models/pagnation_parameter.dart';
import 'package:bn_sl/services/order_service/order.dart';

import '../../models/order_details_response.dart';

abstract class IOrder{
  Future<OrderResponse?> Upload(OrderResponse orderResponse);
  Future<OrderPagnationResponse?> OrderPagnation(PagnationParameter pagnationParameter);
}

abstract class IOrderDetails{
  Future<OrderDetailsResponse?> OrderDetailsUpload(OrderDetailsResponse orderDetailsResponse);
  Future<List<OrderDetailsResponse>?> GetOrderById(String orderId);
}
