class OrderDetailModel {
  OrderDetail? orderDetail;

  OrderDetailModel({this.orderDetail});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderDetail = json['order_detail'] != null
        ? new OrderDetail.fromJson(json['order_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetail != null) {
      data['order_detail'] = this.orderDetail!.toJson();
    }
    return data;
  }
}

class OrderDetail {
  int? id;
  String? code;
  int? userId;
  ShippingAddress? shippingAddress;
  String? paymentType;
  String? paymentStatus;
  String? paymentStatusString;
  String? deliveryStatus;
  String? deliveryStatusString;
  String? grandTotal;
  dynamic planeGrandTotal;
  dynamic couponDiscount;
  dynamic shippingCost;
  String? subtotal;
  dynamic tax;
  String? date;
  bool? cancelRequest;
  String? txnId;
  String? additionalInfo;
  String? delivertDateTime;
  int? isGifted;
  String? receiverPhoneNumber;

  OrderDetail({
    this.id,
    this.code,
    this.userId,
    this.shippingAddress,
    this.paymentType,
    this.paymentStatus,
    this.paymentStatusString,
    this.deliveryStatus,
    this.deliveryStatusString,
    this.grandTotal,
    this.planeGrandTotal,
    this.couponDiscount,
    this.shippingCost,
    this.subtotal,
    this.tax,
    this.date,
    this.cancelRequest,
    this.additionalInfo,
    this.txnId,
    this.isGifted,
    this.delivertDateTime,
    this.receiverPhoneNumber,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    paymentStatusString = json['payment_status_string'];
    deliveryStatus = json['delivery_status'];
    deliveryStatusString = json['delivery_status_string'];
    grandTotal = json['grand_total'];
    planeGrandTotal = json['plane_grand_total'];
    couponDiscount = json['coupon_discount'];
    shippingCost = json['shipping_cost'];
    subtotal = json['subtotal'];
    tax = json['tax'];
    date = json['date'];
    cancelRequest = json['cancel_request'];
    txnId = json['txn_id'];
    additionalInfo = json['additional_info'];
    isGifted = json['is_gifted'];
    delivertDateTime = json['delivery_datetime'];
    receiverPhoneNumber = json['receiver_phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['user_id'] = this.userId;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['payment_status_string'] = this.paymentStatusString;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_status_string'] = this.deliveryStatusString;
    data['grand_total'] = this.grandTotal;
    data['plane_grand_total'] = this.planeGrandTotal;
    data['coupon_discount'] = this.couponDiscount;
    data['shipping_cost'] = this.shippingCost;
    data['subtotal'] = this.subtotal;
    data['tax'] = this.tax;
    data['date'] = this.date;
    data['cancel_request'] = this.cancelRequest;
    data['txn_id'] = this.txnId;
    data['additional_info'] = this.additionalInfo;
    return data;
  }
}

class ShippingAddress {
  String? name;
  String? email;
  String? address;
  String? city;
  String? phone;
  String? latLang;

  ShippingAddress(
      {this.name,
      this.email,
      this.address,
      this.city,
      this.phone,
      this.latLang});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    phone = json['phone'];
    latLang = json['lat_lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['phone'] = this.phone;
    data['lat_lang'] = this.latLang;
    return data;
  }
}
