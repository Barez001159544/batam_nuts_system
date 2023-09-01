
import 'package:bn_sl/models/customer_response.dart';

class CustomerPagnationResponse {
  late int pageIndex;
  late int totalPages;
  late int totalItems;
  late int pageSize;
  late int startPage;
  late int endPage;
  late bool hasPreviousPage;
  late bool hasNextPage;
  late List<CustomerResponse>? items;

  CustomerPagnationResponse(this.pageIndex,
      this.totalPages,
      this.totalItems,
      this.pageSize,
      this.startPage,
      this.endPage,
      this.hasPreviousPage,
      this.hasNextPage,
      this.items,);

  CustomerPagnationResponse.fromJson(Map<String, dynamic> json)
  {
    pageIndex = json['pageIndex'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    pageSize = json['pageSize'];
    startPage = json['startPage'];
    endPage = json['endPage'];
    hasPreviousPage = json['hasPreviousPage'];
    hasNextPage = json['hasNextPage'];
    items = json['items'].map<CustomerResponse>((items) =>
        CustomerResponse.fromJson(items)).toList();
  }

  Map<String, dynamic> toJson() =>
      {
        'pageIndex': pageIndex,
        'totalPages': totalPages,
        'totalItems': totalItems,
        'pageSize': pageSize,
        'startPage': startPage,
        'endPage': endPage,
        'hasPreviousPage': hasPreviousPage,
        'hasNextPage': hasNextPage,
        'items': items,
      };
}