class OrderListModel {
  Pagination? pagination;
  List<Data>? data;

  OrderListModel({this.pagination, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
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
  String? code;
  int? userId;
  String? paymentType;
  String? paymentStatus;
  String? paymentStatusString;
  String? deliveryStatus;
  String? deliveryStatusString;
  String? grandTotal;
  String? date;
  int? isGifted;
  List<OrderItems>? orderItems;
  Provider? provider;

  Data(
      {this.id,
      this.code,
      this.userId,
      this.paymentType,
      this.paymentStatus,
      this.paymentStatusString,
      this.deliveryStatus,
      this.deliveryStatusString,
      this.grandTotal,
      this.date,
      this.isGifted,
      this.orderItems,
      this.provider});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    paymentStatusString = json['payment_status_string'];
    deliveryStatus = json['delivery_status'];
    deliveryStatusString = json['delivery_status_string'];
    grandTotal = json['grand_total'];
    date = json['date'];
    isGifted = json['is_gifted'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    provider = json['provider'] != null
        ? new Provider.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['payment_status_string'] = this.paymentStatusString;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_status_string'] = this.deliveryStatusString;
    data['grand_total'] = this.grandTotal;
    data['date'] = this.date;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    return data;
  }
}

class OrderItems {
  int? id;
  int? productId;
  String? productName;
  String? productThumbnailImage;
  String? variation;
  String? price;
  dynamic tax;
  dynamic shippingCost;
  int? couponDiscount;
  int? quantity;
  int? isFavourite;

  OrderItems(
      {this.id,
      this.productId,
      this.productName,
      this.productThumbnailImage,
      this.variation,
      this.price,
      this.tax,
      this.shippingCost,
      this.couponDiscount,
      this.quantity,
      this.isFavourite});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productThumbnailImage = json['product_thumbnail_image'];
    variation = json['variation'];
    price = json['price'];
    tax = json['tax'];
    shippingCost = json['shipping_cost'];
    couponDiscount = json['coupon_discount'];
    quantity = json['quantity'];
    isFavourite = json['is_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_thumbnail_image'] = this.productThumbnailImage;
    data['variation'] = this.variation;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['shipping_cost'] = this.shippingCost;
    data['coupon_discount'] = this.couponDiscount;
    data['quantity'] = this.quantity;
    data['is_favourite'] = this.isFavourite;
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
