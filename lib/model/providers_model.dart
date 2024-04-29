class ProvidersModel {
  Pagination? pagination;
  List<Data>? data;

  ProvidersModel({this.pagination, this.data});

  ProvidersModel.fromJson(Map<String, dynamic> json) {
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
  dynamic perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  dynamic nextPage;
  dynamic previousPage;

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
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  int? isFavourite;
  int? providersServiceRating;
  int? isVerifyProvider;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.profileImage,
      this.isFavourite,
      this.providersServiceRating,
      this.isVerifyProvider});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    isFavourite = json['is_favourite'];
    providersServiceRating = json['providers_service_rating'];
    isVerifyProvider = json['is_verify_provider'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    data['is_favourite'] = this.isFavourite;
    data['providers_service_rating'] = this.providersServiceRating;
    data['is_verify_provider'] = this.isVerifyProvider;
    return data;
  }
}
