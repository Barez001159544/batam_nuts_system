import 'order_details_response.dart';

class ReturnDetailsSView extends OrderDetailsResponse{
  ReturnDetailsSView(super.addedBy, super.date, super.createdAt, super.updatedAt, super.isActive, super.id, super.orderId, super.productId, super.productText, super.price, super.quantity, super.subtotal, this.available, this.sku, this.reason, this.unitOfMeasure, this.returnHeadeId,);
  double available;
  String sku;
  String reason;
  int unitOfMeasure;
  int returnHeadeId;
}
