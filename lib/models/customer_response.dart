
class CustomerResponse {
  late int id;
  late String name;
  late String? employee;
  late String? phoneNumber ;
  late String? address;
  late String? orders;
  late String? addedBy;
  late String? date;
  late String? createdAt;
  late String? updatedAt;
  late bool isActive;

  CustomerResponse(
  this.id,
  this.name,
  this.employee,
  this.phoneNumber,
  this.address,
  this.addedBy,
  this.date,
  this.createdAt,
  this.updatedAt,
  this.isActive,
      );

  CustomerResponse.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    employee = json['employee'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isActive = json['isActive'];
    orders = json['orders'];
    addedBy = json['addedBy'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() => {
    'addedBy': addedBy,
    'date': date,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'isActive': isActive,
    'id': id,
    'name': name,
    'employee': employee,
    'phoneNumber': phoneNumber,
    'address': address,
  };


}