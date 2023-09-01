class InvoiceDetail{
  late int id;
  late String representativeId;
  late String name;
  late String? note;
  late double total;
  late int warehouseId;
  late String? user;
  late String? warehouse;
  late String? invoiceFactRepresentativeInvoices;
  late String? representativeInvoiceDetail;
  late String addedBy;
  late String date;
  late String createdAt;
  late String updatedAt;
  late bool isActive;
  InvoiceDetail(
  this.id,
      this.representativeId,
      this.name,
      this.note,
      this.total,
      this.warehouseId,
      this.user,
      this.warehouse,
      this.invoiceFactRepresentativeInvoices,
      this.representativeInvoiceDetail,
      this.addedBy,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.isActive,
      );
  InvoiceDetail.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    representativeId = json['representativeId'];
    name = json['name'];
    note = json['note'];
    total = json['total'];
    warehouseId = json['warehouseId'];
    user = json['user'];
    warehouse = json['warehouse'];
    invoiceFactRepresentativeInvoices = json['invoiceFactRepresentativeInvoices'];
    representativeInvoiceDetail = json['representativeInvoiceDetail'];
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'representativeId': representativeId,
    'name': name,
    'note': note,
    'total': total,
    'warehouseId': warehouseId,
    'user': user,
    'warehouse': warehouse,
    'invoiceFactRepresentativeInvoices': invoiceFactRepresentativeInvoices,
    'representativeInvoiceDetail': representativeInvoiceDetail,
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
  };
}