class ProductListModel {
  Pagination? pagination;
  List<Data>? data;

  ProductListModel({this.pagination, this.data});

  ProductListModel.fromJson(Map<String, dynamic> json) {
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
  dynamic weight;
  int? minQty;
  int? lowStockQuantity;
  int? productionDays;
  String? productThumbnailImage;
  List<String>? productGalleryImages;

  Data(
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
      this.productionDays,
      this.productGalleryImages});

  Data.fromJson(Map<String, dynamic> json) {
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
    productionDays = json['production_days'];
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
    data['production_days'] = this.productionDays;

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
