class CategoryWiseProviderModel {
  bool? status;
  List<Providers>? providers;

  CategoryWiseProviderModel({this.status, this.providers});

  CategoryWiseProviderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(new Providers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.providers != null) {
      data['providers'] = this.providers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Providers {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  int? isFavourite;
  dynamic providersServiceRating;
  int? isVerifyProvider;
  String? createdAt;

  Providers(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.profileImage,
      this.isFavourite,
      this.providersServiceRating,
      this.isVerifyProvider,
      this.createdAt});

  Providers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
    isFavourite = json['is_favourite'];
    providersServiceRating = json['providers_service_rating'];
    isVerifyProvider = json['is_verify_provider'];
    createdAt = json['created_at'];
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
    data['created_at'] = this.createdAt;
    return data;
  }
}
