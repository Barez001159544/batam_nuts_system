class ReturnHeadeResponse{
  late String addedBy;
  late String date;
  late String createdAt;
  late String updatedAt;
  late bool isActive;
  late int id;
  late int customerId;
  late int warehouseId;
  late String representativeId;
  late int status;
  late double total;
  late String customerText;
  late String? note;
  ReturnHeadeResponse(
      this.addedBy,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      this.id,
      this.customerId,
      this.warehouseId,
      this.representativeId,
      this.status,
      this.total,
      this.customerText,
  this.note,
      );
  ReturnHeadeResponse.fromJson(Map<String, dynamic> json)
  {
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    id = json['id'];
    status = json['status'];
    note = json['note'];
    total = json['total'];
    customerId = json['customerId'];
    warehouseId = json['warehouseId'];
    customerText = json['customerText'];
    representativeId = json['representativeId'];
  }
  Map<String, dynamic> toJson() => {
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
    'id': id,
    'status': status,
    'note': note,
    'total': total,
    'customerId': customerId,
    'warehouseId': warehouseId,
    'customerText': customerText,
    'representativeId': representativeId,
  };
}