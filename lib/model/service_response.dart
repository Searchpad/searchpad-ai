import 'package:booking_system_flutter/model/service_data_model.dart';

import 'pagination_model.dart';

class ServiceResponse {
  List<ServiceData>? serviceList;
  Pagination? pagination;
  int? max;
  int? min;
  List<ServiceData>? userServices;
  List<Product>? product;

  ServiceResponse(
      {this.serviceList,
      this.pagination,
      this.max,
      this.min,
      this.userServices,
      this.product});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      serviceList: json['data'] != null
          ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList()
          : null,
      max: json['max'],
      min: json['min'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      userServices: json['user_services'] != null
          ? (json['user_services'] as List)
              .map((i) => ServiceData.fromJson(i))
              .toList()
          : null,
      product: json['products'] != null
          ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max'] = this.max;
    data['min'] = this.min;
    if (this.serviceList != null) {
      data['data'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.userServices != null) {
      data['user_services'] =
          this.userServices!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['products'] = this.product!.map((v) => v.toJson()).toList();
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
