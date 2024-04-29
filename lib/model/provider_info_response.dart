import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';

import 'service_data_model.dart';

class ProviderInfoResponse {
  UserData? userData;
  List<ServiceData>? serviceList;
  List<Product>? product;
  List<RatingData>? handymanRatingReviewList;

  ProviderInfoResponse(
      {this.userData, this.serviceList, this.handymanRatingReviewList});

  ProviderInfoResponse.fromJson(Map<String, dynamic> json) {
    userData =
        json['data'] != null ? new UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      serviceList = [];
      json['service'].forEach((v) {
        serviceList!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReviewList = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReviewList!.add(new RatingData.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    if (this.serviceList != null) {
      data['service'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    if (this.handymanRatingReviewList != null) {
      data['handyman_rating_review'] =
          this.handymanRatingReviewList!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  Category? category;
  Category? subCategory;
  Category? brand;
  String? videoLink;
  String? tags;
  String? description;
  bool? hasDiscount;
  String? discount;
  String? strokedPrice;
  String? mainPrice;
  int? variantProduct;
  int? featured;
  int? status;
  String? unit;
  String? weight;
  int? minQty;
  int? lowStockQuantity;
  String? productThumbnailImage;
  List<String>? productGalleryImages;

  Product(
      {this.id,
      this.name,
      this.category,
      this.subCategory,
      this.brand,
      this.videoLink,
      this.tags,
      this.description,
      this.hasDiscount,
      this.discount,
      this.strokedPrice,
      this.mainPrice,
      this.variantProduct,
      this.featured,
      this.status,
      this.unit,
      this.weight,
      this.minQty,
      this.lowStockQuantity,
      this.productThumbnailImage,
      this.productGalleryImages});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new Category.fromJson(json['sub_category'])
        : null;
    brand = json['brand'] != null ? new Category.fromJson(json['brand']) : null;
    videoLink = json['video_link'];
    tags = json['tags'];
    description = json['description'];
    hasDiscount = json['has_discount'];
    discount = json['discount'];
    strokedPrice = json['stroked_price'];
    mainPrice = json['main_price'];
    variantProduct = json['variant_product'];
    featured = json['featured'];
    status = json['status'];
    unit = json['unit'];
    weight = json['weight'];
    minQty = json['min_qty'];
    lowStockQuantity = json['low_stock_quantity'];
    productThumbnailImage = json['product_thumbnail_image'];
    productGalleryImages = json['product_gallery_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    data['video_link'] = this.videoLink;
    data['tags'] = this.tags;
    data['description'] = this.description;
    data['has_discount'] = this.hasDiscount;
    data['discount'] = this.discount;
    data['stroked_price'] = this.strokedPrice;
    data['main_price'] = this.mainPrice;
    data['variant_product'] = this.variantProduct;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    data['min_qty'] = this.minQty;
    data['low_stock_quantity'] = this.lowStockQuantity;
    data['product_thumbnail_image'] = this.productThumbnailImage;
    data['product_gallery_images'] = this.productGalleryImages;
    return data;
  }
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
