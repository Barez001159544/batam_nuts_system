class ReturnResponse{
  late String   addedBy;
  late String   date;
  late String   createdAt;
  late String   updatedAt;
  late bool     isActive;
  late int      id;
  late int      productId;
  late String   productText;
  late int      unitOfMeasure;
  late String   reason;
  late double   quantity;
  late double      price;
  late double      subtotal;
  late int      returnHeadeId;

  ReturnResponse(
  this.addedBy,
  this.date,
  this.createdAt,
  this.updatedAt,
  this.isActive,
  this.id,
  this.productId,
  this.productText,
  this.unitOfMeasure,
  this.reason,
  this.quantity,
  this.price,
  this.subtotal,
  this.returnHeadeId,
      );

  ReturnResponse.fromJson(Map<String, dynamic> json)
  {
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    id = json['id'];
    productId = json['productId'];
    productText = json['productText'];
    unitOfMeasure = json['unitOfMeasure'];
    reason = json['reason'];
    quantity = json['quantity'];
    price = json['price'];
    subtotal = json['subtotal'];
    returnHeadeId = json['returnHeadeId'];
  }
  Map<String, dynamic> toJson() => {
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
    'id': id,
    'productId': productId,
    'productText': productText,
    'unitOfMeasure': unitOfMeasure,
    'reason': reason,
    'quantity': quantity,
    'price': price,
    'subtotal': subtotal,
    'returnHeadeId': returnHeadeId,
  };
}