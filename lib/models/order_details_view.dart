import 'package:bn_sl/models/order_details_response.dart';

class OrderDetailsView extends OrderDetailsResponse{
  OrderDetailsView(super.addedBy, super.date, super.createdAt, super.updatedAt, super.isActive, super.id, super.orderId, super.productId, super.productText, super.price, super.quantity, super.subtotal, this.available, this.sku);
  double available;
  String sku;
}
