class AddressListModel {
  Pagination? pagination;
  List<Data>? data;

  AddressListModel({this.pagination, this.data});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  String? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  String? nextPage;
  String? previousPage;

  Pagination(
      {this.totalItems,
      this.perPage,
      this.currentPage,
      this.totalPages,
      this.from,
      this.to,
      this.nextPage,
      this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['per_page'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['from'] = this.from;
    data['to'] = this.to;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? latitude;
  String? longitude;
  int? setDefault;

  Data(
      {this.id,
      this.userId,
      this.name,
      this.phone,
      this.email,
      this.address,
      this.city,
      this.latitude,
      this.longitude,
      this.setDefault});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    setDefault = json['set_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['set_default'] = this.setDefault;
    return data;
  }
}
