import 'package:booking_system_flutter/model/cart_list_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Future<CartListModel>? cartList;
  CartListModel? cartData;
  bool showCheckOut = false;
  getCartList() async {
    cartList = getAllCartList();
    var dd = await cartList;
    cartData = dd;
    showCheckOut = dd?.message?.status ?? false;
    notifyListeners();
  }

  bool isLoading = false;

  setLoading(val) {
    isLoading = val;
    notifyListeners();
  }
}
