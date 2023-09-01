class ProductResponse {
  late int id;
  late String? sku;
  late String name;
  late String description;
  late int unitOfMeasure;
  late double price;
  late String? image;
  late double quantityOnHand;
  late double quantityOrder;
  late double quantityAvailable;

  ProductResponse(
    this.id,
    this.sku,
    this.name,
    this.description,
    this.unitOfMeasure,
    this.price,
    this.image,
    this.quantityOnHand,
    this.quantityOrder,
    this.quantityAvailable,
  );

  ProductResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sku = json['sku'];
    name = json['name'];
    description = json['description'];
    unitOfMeasure = json['unitOfMeasure'];
    price = json['price'];
    image = json['image'];
    quantityOnHand = json['quantityOnHand'];
    quantityOrder = json['quantityOrder'];
    quantityAvailable = json['quantityAvailable'];
  }
}
