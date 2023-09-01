class PagnationParameter {
  late int pageNumber;
  late int pageSize;
  late String sortField;
  late String sortOrder;
  late List parameter=[""];
  late String search;
  late int warehouseId;
  late String representativeId;
  late String frome;
  late String to;
  late bool filterByDate;
  late bool isActive;
  PagnationParameter(
    this.pageNumber,
    this.pageSize,
    this.sortField,
    this.sortOrder,
    this.parameter,
    this.search,
    this.warehouseId,
    this.representativeId,
    this.frome,
    this.to,
    this.filterByDate,
    this.isActive,
  );

  PagnationParameter.fromJson(Map<String, dynamic> json)
  {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    sortField = json['sortField'];
    sortOrder = json['sortOrder'];
    parameter = json['parameter'];
    search = json['search'];
    warehouseId = json['warehouseId'];
    representativeId = json['representativeId'];
    frome = json['frome'];
    to = json['to'];
    filterByDate = json['filterByDate'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() => {
  'pageNumber':pageNumber,
  'pageSize':pageSize,
  'sortField':sortField,
  'sortOrder':sortOrder,
  'parameter':parameter,
  'search':search,
  'warehouseId':warehouseId,
  'representativeId':representativeId,
  'frome':frome,
  'to':to,
  'filterByDate':filterByDate,
  'isActive':isActive,
  };
}
