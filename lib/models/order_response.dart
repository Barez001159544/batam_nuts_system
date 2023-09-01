class OrderResponse {
  late String addedBy;
  late String date;
  late String createdAt;
  late String updatedAt;
  late bool isActive;
  late int id;
  late String orderNumber;
  late String requiredDate;
  late int status;
  late String? note;
  late double total;
  late int customerId;
  late int warehouseId;
  late String customerText;
  late String representative;
  late String representativeId;

  OrderResponse(
    this.addedBy,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.id,
    this.orderNumber,
    this.requiredDate,
    this.status,
    this.note,
    this.total,
    this.customerId,
    this.warehouseId,
    this.customerText,
    this.representative,
    this.representativeId,
  );

  OrderResponse.fromJson(Map<String, dynamic> json)
  {
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    id = json['id'];
    orderNumber = json['orderNumber'];
    requiredDate = json['requiredDate'];
    status = json['status'];
    note = json['note'];
    total = json['total'];
    customerId = json['customerId'];
    warehouseId = json['warehouseId'];
    customerText = json['customerText'];
    representative = json['representative'];
    representativeId = json['representativeId'];
  }

  Map<String, dynamic> toJson() => {
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
    'id': id,
    'orderNumber': orderNumber,
    'requiredDate': requiredDate,
    'status': status,
    'note': note,
    'total': total,
    'customerId': customerId,
    'warehouseId': warehouseId,
    'customerText': customerText,
    'representative': representative,
    'representativeId': representativeId,
  };

}
