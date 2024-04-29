class OrderItemDetailModel {
  List<OrderItems>? orderItems;

  OrderItemDetailModel({this.orderItems});

  OrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  int? id;
  int? productId;
  String? productName;
  String? productThumbnailImage;
  dynamic variation;
  String? price;
  dynamic tax;
  dynamic shippingCost;
  int? couponDiscount;
  int? quantity;

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
      this.quantity});

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
    return data;
  }
}
