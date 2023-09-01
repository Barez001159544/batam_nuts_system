class GeneralResponse{
  late int id;
  late String name;
  late String value;
  GeneralResponse(
      this.id,
      this.name,
      this.value,
      );
  GeneralResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
  }
  Map toJson() => {
    'id': id,
    'name': name,
    'value': value,
  };
}