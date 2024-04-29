import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:flutter/material.dart';
import '../../model/product_detail_model.dart' as prod;

class ProductProvider extends ChangeNotifier {
  PageController pageController = PageController();
  Future<prod.ProductDetailModel>? profuctDetail;
  // Future<ServiceDetailResponse>? future;

  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;

  //
  String selectedColor = "";
  int selectedQty = 0;
  var selectedOptionList = [];
  late TabController imagesController;

  init({required productId, required userId}) async {
    discposeValues();
    profuctDetail = getProductDetail(productId, userId);
    var dd = await profuctDetail;

    selectedOptionList = List.generate(dd!.productDetail!.choiceOptions!.length,
        (index) => dd.productDetail!.choiceOptions?[index].options?.first);

    selectedColor = dd.productDetail?.colors?.isEmpty == true
        ? ""
        : dd.productDetail?.colors?.first.name ?? '';
    notifyListeners();

    return dd;
  }

  changeImageIndex(code, prod.ProductDetailModel profuctDetail) {
    // int tempIndex = -1;

    for (int i = 0; i < profuctDetail.productDetail!.photos!.length; i++) {
      if (profuctDetail.productDetail!.photos![i].variant!.contains(code)) {
        // tempIndex = i;
        imagesController.index = i;
        break; // Exit the loop when a match is found
      }
    }

    notifyListeners();
  }

  quantityIncrement(varientQty) {
    if (selectedQty < varientQty) {
      selectedQty++;
    }

    notifyListeners();
  }

  quantityDecrement() {
    if (selectedQty > 0) {
      selectedQty--;
    }

    notifyListeners();
  }

  discposeValues() {
    profuctDetail = null;
    // Future<ServiceDetailResponse>? future;

    selectedAddressId = 0;
    selectedBookingAddressId = -1;

    //
    selectedColor = "";
    selectedQty = 0;
    selectedOptionList = [];
  }
}
