class OrderDetailsResponse{
  late String addedBy;
  late String date;
  late String createdAt;
  late String updatedAt;
  late bool   isActive;
  late int    id;
  late int orderId;
  late int productId;
  late String productText;
  late double price;
  late double quantity;
  late double subtotal;
  OrderDetailsResponse(
  this.addedBy,
  this.date,
  this.createdAt,
  this.updatedAt,
  this.isActive,
  this.id,
  this.orderId,
  this.productId,
  this.productText,
  this.price,
  this.quantity,
  this.subtotal,
      );
  OrderDetailsResponse.fromJson(Map<String, dynamic> json)
  {
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    id = json['id'];
    orderId = json['orderId'];
    productId = json['productId'];
    productText = json['productText'];
    price = json['price'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() => {
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
    'id': id,
    'orderId': orderId,
    'productId': productId,
    'productText': productText,
    'price': price,
    'quantity': quantity,
    'subtotal': subtotal,
  };
}