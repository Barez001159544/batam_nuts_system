class ItemsPagnationResponse{
  late int id;
  late int customerId;
  late int warehouseId;
  late String representativeId;
  late int status;
  late double total;
  late String customerText;
  late String? note;
  late String? warehouse;
  late String? customer;
  late String? returns;
  late String addedBy;
  late String date;
  late String createdAt;
  late String updatedAt;
  late bool isActive;
  ItemsPagnationResponse(
      this.id,
      this.customerId,
      this.warehouseId,
      this.representativeId,
      this.status,
      this.total,
      this.customerText,
      this.note,
      this.warehouse,
      this.customer,
      this.returns,
      this.addedBy,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      );
  ItemsPagnationResponse.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    customerId = json['customerId'];
    warehouseId = json['warehouseId'];
    representativeId = json['representativeId'];
    status = json['status'];
    total = json['total'];
    customerText = json['customerText'];
    note = json['note'];
    warehouse = json['warehouse'];
    customer = json['customer'];
    returns = json['returns'];
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'customerId':customerId,
    'warehouseId':warehouseId,
    'representativeId':representativeId,
    'status':status,
    'total':total,
    'customerText':customerText,
    'note':note,
    'warehouse':warehouse,
    'customer':customer,
    'returns':returns,
    'addedBy':addedBy,
    'date':date,
    'createdAt':createdAt,
    'updatedAt':updatedAt,
    'isActive':isActive,
  };
}