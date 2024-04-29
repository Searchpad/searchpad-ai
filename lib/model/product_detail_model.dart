class ProductDetailModel {
  ProductDetail? productDetail;
  List<RelatedProducts>? relatedProducts;

  ProductDetailModel({this.productDetail, this.relatedProducts});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    productDetail = json['product_detail'] != null
        ? new ProductDetail.fromJson(json['product_detail'])
        : null;
    if (json['related_products'] != null) {
      relatedProducts = <RelatedProducts>[];
      json['related_products'].forEach((v) {
        relatedProducts!.add(new RelatedProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productDetail != null) {
      data['product_detail'] = this.productDetail!.toJson();
    }
    if (this.relatedProducts != null) {
      data['related_products'] =
          this.relatedProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetail {
  int? id;
  String? name;
  Category? category;
  SubCategory? subCategory;
  Brand? brand;
  String? videoLink;
  String? tags;
  String? description;
  dynamic variantProduct;
  int? featured;
  int? status;
  dynamic unit;
  dynamic weight;
  dynamic minQty;
  dynamic lowStockQuantity;
  String? productThumbnailImage;
  List<Photos>? photos;
  String? priceHighLow;
  List<ChoiceOptions>? choiceOptions;
  List<Colors>? colors;
  bool? hasDiscount;
  String? discount;
  String? strokedPrice;
  String? mainPrice;
  dynamic calculablePrice;
  int? currentStock;
  List<Variants>? variants;
  int? isFavourite;
  Provider? provider;

  ProductDetail({
    this.id,
    this.name,
    this.category,
    this.subCategory,
    this.brand,
    this.videoLink,
    this.tags,
    this.description,
    this.variantProduct,
    this.featured,
    this.status,
    this.unit,
    this.weight,
    this.minQty,
    this.lowStockQuantity,
    this.productThumbnailImage,
    this.photos,
    this.priceHighLow,
    this.choiceOptions,
    this.colors,
    this.hasDiscount,
    this.discount,
    this.strokedPrice,
    this.mainPrice,
    this.calculablePrice,
    this.currentStock,
    this.variants,
    this.isFavourite,
    this.provider,
  });

  ProductDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    videoLink = json['video_link'];
    tags = json['tags'];
    description = json['description'];
    variantProduct = json['variant_product'];
    featured = json['featured'];
    status = json['status'];
    unit = json['unit'];
    weight = json['weight'];
    minQty = json['min_qty'];
    lowStockQuantity = json['low_stock_quantity'];
    productThumbnailImage = json['product_thumbnail_image'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    priceHighLow = json['price_high_low'];
    if (json['choice_options'] != null) {
      choiceOptions = <ChoiceOptions>[];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(new ChoiceOptions.fromJson(v));
      });
    }
    if (json['colors'] != null) {
      colors = <Colors>[];
      json['colors'].forEach((v) {
        colors!.add(new Colors.fromJson(v));
      });
    }
    hasDiscount = json['has_discount'];
    discount = json['discount'];
    strokedPrice = json['stroked_price'];
    mainPrice = json['main_price'];
    calculablePrice = json['calculable_price'];
    currentStock = json['current_stock'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
    isFavourite = json['is_favourite'];
    provider = json['provider'] != null
        ? new Provider.fromJson(json['provider'])
        : null;
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
    data['variant_product'] = this.variantProduct;
    data['featured'] = this.featured;
    data['status'] = this.status;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    data['min_qty'] = this.minQty;
    data['low_stock_quantity'] = this.lowStockQuantity;
    data['product_thumbnail_image'] = this.productThumbnailImage;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['price_high_low'] = this.priceHighLow;
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions!.map((v) => v.toJson()).toList();
    }
    if (this.colors != null) {
      data['colors'] = this.colors!.map((v) => v.toJson()).toList();
    }
    data['has_discount'] = this.hasDiscount;
    data['discount'] = this.discount;
    data['stroked_price'] = this.strokedPrice;
    data['main_price'] = this.mainPrice;
    data['calculable_price'] = this.calculablePrice;
    data['current_stock'] = this.currentStock;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    data['is_favourite'] = this.isFavourite;
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? categoryImage;

  Category({this.id, this.name, this.categoryImage});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_image'] = this.categoryImage;
    return data;
  }
}

class SubCategory {
  String? id;
  String? name;

  SubCategory({this.id, this.name});

  SubCategory.fromJson(Map<String, dynamic> json) {
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

class Brand {
  String? id;
  String? name;
  String? brandLogo;

  Brand({this.id, this.name, this.brandLogo});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brandLogo = json['brand_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['brand_logo'] = this.brandLogo;
    return data;
  }
}

class Photos {
  String? variant;
  String? path;

  Photos({this.variant, this.path});

  Photos.fromJson(Map<String, dynamic> json) {
    variant = json['variant'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['variant'] = this.variant;
    data['path'] = this.path;
    return data;
  }
}

class RelatedProducts {
  int? id;
  String? name;
  SubCategory? category;
  SubCategory? subCategory;
  SubCategory? brand;
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
  String? productThumbnailImage;
  List<String>? productGalleryImages;
  int? isFavourite;

  RelatedProducts(
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
      this.productGalleryImages,
      this.isFavourite});

  RelatedProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'] != null
        ? new SubCategory.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    brand =
        json['brand'] != null ? new SubCategory.fromJson(json['brand']) : null;
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
    isFavourite = json['is_favourite'];
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
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}

class Colors {
  String? name;
  String? code;

  Colors({this.name, this.code});

  Colors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}

class Variants {
  int? id;
  int? productId;
  String? variant;
  String? sku;
  String? strokedPrice;
  String? mainPrice;
  dynamic calculablePrice;
  int? qty;

  Variants(
      {this.id,
      this.productId,
      this.variant,
      this.sku,
      this.strokedPrice,
      this.mainPrice,
      this.calculablePrice,
      this.qty});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    variant = json['variant'];
    sku = json['sku'];
    strokedPrice = json['stroked_price'];
    mainPrice = json['main_price'];
    calculablePrice = json['calculable_price'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['variant'] = this.variant;
    data['sku'] = this.sku;
    data['stroked_price'] = this.strokedPrice;
    data['main_price'] = this.mainPrice;
    data['calculable_price'] = this.calculablePrice;
    data['qty'] = this.qty;
    return data;
  }
}

class Provider {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;

  Provider(
      {this.id, this.firstName, this.lastName, this.email, this.profileImage});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
