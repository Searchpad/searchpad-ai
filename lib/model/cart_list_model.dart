class CartListModel {
  Message? message;

  CartListModel({this.message});

  CartListModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  bool? status;
  List<Data>? data;

  Message({this.status, this.data});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? ownerId;
  int? userId;
  int? productId;
  String? productName;
  String? productThumbnailImage;
  String? variation;
  dynamic price;
  dynamic tax;
  dynamic shippingCost;
  dynamic quantity;
  dynamic lowerLimit;
  dynamic upperLimit;
  int? productionDays;

  Data(
      {this.id,
      this.ownerId,
      this.userId,
      this.productId,
      this.productName,
      this.productThumbnailImage,
      this.variation,
      this.price,
      this.tax,
      this.shippingCost,
      this.quantity,
      this.lowerLimit,
      this.upperLimit,
      this.productionDays});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productThumbnailImage = json['product_thumbnail_image'];
    variation = json['variation'];
    price = json['price'];
    tax = json['tax'];
    shippingCost = json['shipping_cost'];
    quantity = json['quantity'];
    lowerLimit = json['lower_limit'];
    upperLimit = json['upper_limit'];
    productionDays = json['production_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_thumbnail_image'] = this.productThumbnailImage;
    data['variation'] = this.variation;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['quantity'] = this.quantity;
    data['lower_limit'] = this.lowerLimit;
    data['upper_limit'] = this.upperLimit;
    data['production_days'] = this.productionDays;
    return data;
  }
}
