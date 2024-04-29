// import 'package:booking_system_flutter/screens/products/cart_provider.dart';
// import 'package:booking_system_flutter/screens/products/screen_loader.dart';
// import 'package:booking_system_flutter/screens/products/ui_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import '../../component/back_widget.dart';
// import '../../component/cached_image_widget.dart';
// import '../../component/empty_error_state_widget.dart';
// import '../../component/loader_widget.dart';
// import '../../main.dart';
// import '../../model/product_detail_model.dart' as prod;
// import '../../network/rest_apis.dart';
// import '../../utils/constant.dart';
// import 'cart_list_screen.dart';
// import 'extended_image.dart';

// class ProductDetailPage extends StatefulWidget {
//   const ProductDetailPage({super.key, required this.productId});
//   final String productId;

//   @override
//   _ProductDetailPageState createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage>
//     with TickerProviderStateMixin {
//   Future<prod.ProductDetailModel>? profuctDetail;

//   late TabController imagesController;

//   _changeImageIndex(code, prod.ProductDetailModel profuctDetail) {
//     // int tempIndex = -1;

//     for (int i = 0; i < profuctDetail.productDetail!.photos!.length; i++) {
//       if (profuctDetail.productDetail!.photos![i].variant!.contains(code)) {
//         // tempIndex = i;
//         imagesController.index = i;
//         break; // Exit the loop when a match is found
//       }
//     }

//     setState(() {});
//   }

//   //
//   String selectedColor = "";
//   int selectedQty = 0;
//   var selectedOptionList = [];

//   getProdDetails() async {
//     profuctDetail = getProductDetail(widget.productId, widget.productId);
//     var dd = await profuctDetail;
//     imagesController = TabController(
//         length: dd?.productDetail?.photos?.length ?? 0, vsync: this);

//     selectedOptionList = List.generate(dd!.productDetail!.choiceOptions!.length,
//         (index) => dd.productDetail!.choiceOptions?[index].options?.first);

//     selectedColor = dd.productDetail?.colors?.isEmpty == true
//         ? ""
//         : dd.productDetail?.colors?.first.name ?? '';
//   }

//   @override
//   void initState() {
//     super.initState();
//     getProdDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBarWidget(
//         "",
//         backWidget: BackWidget(iconColor: white),
//         color: context.primaryColor,
//         systemUiOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: context.primaryColor,
//             statusBarBrightness: Brightness.dark,
//             statusBarIconBrightness: Brightness.light),
//         titleWidget: Text(
//           language.products,
//           style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
//         ),
//       ),
//       body: SnapHelperWidget<prod.ProductDetailModel>(
//         future: profuctDetail,
//         onSuccess: (data) {
//           return Stack(
//             children: [
//               _buildProductDetailsPage(context, data),
//               _buyNowButton(
//                   context,
//                   data,
//                   selectedOptionList.isNotEmpty
//                       ? "$selectedColor-${selectedOptionList.join('-')}"
//                       : "$selectedColor")
//             ],
//           );
//         },
//         errorBuilder: (error) {
//           return NoDataWidget(
//             title: error,
//             imageWidget: ErrorStateWidget(),
//             retryText: language.reload,
//             onRetry: () {
//               appStore.setLoading(true);

//               getProdDetails();
//               setState(() {});
//             },
//           );
//         },
//         loadingWidget: LoaderWidget(),
//       ),
//     );
//   }

//   Positioned _buyNowButton(
//       BuildContext context, prod.ProductDetailModel data, varienCode) {
//     return Positioned(
//       bottom: 16,
//       left: 16,
//       right: 16,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 6,
//             child: AppButton(
//               onTap: () async {
//                 if (selectedQty != 0) {
//                   if (selectedQty >= data.productDetail!.minQty!) {
//                     Loaders.start(context);
//                     var resp = await productAddToCart({
//                       "id": data.productDetail?.id,
//                       "variant":
//                           data.productDetail?.choiceOptions?.isEmpty ?? true
//                               ? ""
//                               : varienCode,
//                       "quantity": selectedQty
//                     });
//                     Loaders.stop(context);

//                     if (resp['message']['status'] == true) {
//                       Fluttertoast.showToast(msg: resp['message']['message']);
//                       await context.read<CartProvider>().removerCartData();
//                       CartListScreen().launch(context);
//                     } else {
//                       Fluttertoast.showToast(msg: resp['message']['message']);
//                     }
//                   } else {
//                     Fluttertoast.showToast(
//                         msg:
//                             "${language.pleaseAddMin} ${data.productDetail!.minQty} ${data.productDetail!.unit}");
//                   }
//                 } else {
//                   Fluttertoast.showToast(msg: language.pleaseSelectQty);
//                 }
//               },
//               color: context.primaryColor,
//               child:
//                   Text(language.lblBuyNow, style: boldTextStyle(color: white)),
//               width: context.width(),
//               textColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildProductDetailsPage(BuildContext context, prod.ProductDetailModel data) {
//     Size screenSize = MediaQuery.of(context).size;

//     return ListView(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.all(4.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(height: 12.0),
//               _buildProductImagesWidgets(data),
//               SizedBox(height: 12.0),
//               _buildDivider(screenSize),
//               SizedBox(height: 12.0),
//               _buildProductBrand(data),
//               SizedBox(height: 6.0),
//               _buildProductTitleWidget(data),
//               SizedBox(height: 12.0),
//               _buildPriceWidgets(
//                   data,
//                   selectedOptionList.isNotEmpty
//                       ? "$selectedColor-${selectedOptionList.join('-')}"
//                       : "$selectedColor"),
//               SizedBox(height: 12.0),
//               _buildColorOptions(data, screenSize),
//               _buildVariantOptions(data, screenSize),
//               _buildQtyOptions(
//                   data,
//                   screenSize,
//                   selectedOptionList.isNotEmpty
//                       ? "$selectedColor-${selectedOptionList.join('-')}"
//                       : "$selectedColor"),
//               _buildDetailsAndMaterialWidgets(data),
//               SizedBox(
//                 height: 60,
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   _buildDivider(Size screenSize) {
//     return Column(
//       children: <Widget>[
//         Container(
//           color: Colors.grey[600],
//           width: screenSize.width,
//           height: 0.25,
//         ),
//       ],
//     );
//   }

//   _buildProductImagesWidgets(prod.ProductDetailModel data) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         height: 300.0,
//         child: Center(
//           child: DefaultTabController(
//             length: data.productDetail?.photos?.length ?? 0,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: <Widget>[
//                 TabBarView(
//                     controller: imagesController,
//                     children: List.generate(
//                         data.productDetail?.photos?.length ?? 0,
//                         (index) => InkWell(
//                               onTap: () {
//                                 ExtendedImageWidget(
//                                         currentPage: index,
//                                         imageList: data.productDetail!.photos!)
//                                     .launch(context);
//                               },
//                               child: CachedImageWidget(
//                                 url: data.productDetail?.photos?[index].path ??
//                                     '',
//                                 height: 300,
//                               ),
//                             ))

//                     // children: product.images.map(
//                     //   (image) {
//                     //     return Image.network(
//                     //       image.imageURL,
//                     //     );
//                     //   },
//                     // ).toList(),
//                     ),
//                 Positioned(
//                   bottom: 10,
//                   child: FittedBox(
//                     child: Container(
//                       alignment: FractionalOffset(0.5, 0.95),
//                       child: TabPageSelector(
//                         controller: imagesController,
//                         selectedColor: Colors.grey,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _buildProductBrand(prod.ProductDetailModel data) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Row(
//         children: [
//           CachedImageWidget(
//               url: data.productDetail?.brand?.brandLogo ?? '',
//               height: 30,
//               circle: true),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             //name,
//             data.productDetail?.brand?.name ?? '',
//             style: TextStyle(
//                 fontSize: 14.0,
//                 color: appStore.isDarkMode ? Colors.white : Colors.black),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildProductTitleWidget(prod.ProductDetailModel data) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Text(
//         //name,
//         data.productDetail?.name ?? '',
//         style: TextStyle(
//             fontSize: 16.0,
//             color: appStore.isDarkMode ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   _buildPriceWidgets(prod.ProductDetailModel data, varianCode) {
//     var price = "";
//     var stockedPrice = "";

//     if (data.productDetail?.choiceOptions?.isNotEmpty ?? false) {
//       var matchingVariant = data.productDetail?.variants?.firstWhere(
//         (variant) => variant.variant == varianCode,
//       );

//       if (matchingVariant != null) {
//         price = matchingVariant.mainPrice ?? "";
//         stockedPrice = matchingVariant.strokedPrice ?? "";
//       } else {
//         price = "";
//         stockedPrice = "";
//       }
//     } else {
//       price = data.productDetail?.mainPrice.toString() ?? '';
//       stockedPrice = data.productDetail?.strokedPrice ?? '';
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Text(
//                 price,
//                 style: TextStyle(
//                     fontSize: 16.0,
//                     color: appStore.isDarkMode ? Colors.white : Colors.black),
//               ),
//               Visibility(
//                 visible: data.productDetail?.hasDiscount ?? false,
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 8.0,
//                     ),
//                     Text(
//                       stockedPrice,
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.grey,
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 8.0,
//                     ),
//                     Text(
//                       "${data.productDetail?.discount ?? ''} ${language.lblOff}",
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.orange[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           UIHelper.verticalSpaceSmall(),
//           Text(
//             data.productDetail?.priceHighLow ?? '',
//             style: TextStyle(fontSize: 13.0, color: Colors.blue),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildDetailsAndMaterialWidgets(prod.ProductDetailModel data) {
//     return Container(
//       margin: EdgeInsets.all(5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             language.lblDetails,
//             style: TextStyle(
//               color: appStore.isDarkMode ? Colors.white : Colors.black,
//             ),
//           ),
//           Container(
//             child: Html(
//               data: data.productDetail?.description ?? '',
//               style: {
//                 "html": Style(
//                   color: appStore.isDarkMode
//                       ? Colors.white
//                       : Colors
//                           .black, // Set the text color of the entire HTML widget to red
//                 ),
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// //////
//   Widget _buildColorOptions(prod.ProductDetailModel data, screenSize) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Visibility(
//         visible: data.productDetail?.colors?.isNotEmpty ?? false,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDivider(screenSize),
//             SizedBox(height: 12.0),
//             Text(
//               'Color',
//               style: TextStyle(color: appStore.isDarkMode ? whiteColor : black),
//             ),
//             Row(
//               children: data.productDetail!.colors!.map<Widget>((color) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedQty = 0;
//                       selectedColor = color.name ?? '';
//                       _changeImageIndex(
//                           selectedOptionList.isNotEmpty
//                               ? "$selectedColor-${selectedOptionList.join('-')}"
//                               : "$selectedColor",
//                           data);
//                     });
//                   },
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     margin: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Color(
//                           int.parse(color.code!.substring(1, 7), radix: 16) +
//                               0xFF000000),
//                       border: selectedColor == color.name
//                           ? Border.all(color: Colors.blue, width: 2)
//                           : null,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 12.0),
//             _buildDivider(screenSize),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQtyOptions(
//       prod.ProductDetailModel data, screenSize, variantCode) {
//     int varientQty = 0;

//     if (data.productDetail?.choiceOptions?.isNotEmpty ?? false) {
//       var matchingVariant = data.productDetail?.variants!.firstWhere(
//         (variant) => variant.variant == variantCode,
//       );

//       if (matchingVariant != null) {
//         varientQty = matchingVariant.qty ?? 0;
//       } else {
//         varientQty = 0;
//       }
//     } else {
//       varientQty = data.productDetail?.currentStock ?? 0;
//     }

//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             language.lblQuantity,
//             style: TextStyle(
//                 color: appStore.isDarkMode ? Colors.white : Colors.black),
//           ),
//           UIHelper.verticalSpaceSmall(),
//           Row(children: [
//             RoundCard(
//               child: SizedBox(
//                 height: 35,
//                 width: 35,
//                 child: IconButton(
//                   icon: Icon(Icons.remove,
//                       size: 20,
//                       color: appStore.isDarkMode ? Colors.black : darkCyan),
//                   onPressed: () {
//                     setState(() {
//                       if (selectedQty > 0) {
//                         selectedQty--;
//                       }
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(width: 16.0),
//             Text(
//               selectedQty.toString(),
//               style: TextStyle(
//                   fontSize: 20.0,
//                   color: appStore.isDarkMode ? Colors.white : Colors.black),
//             ),
//             SizedBox(width: 16.0),
//             RoundCard(
//               child: SizedBox(
//                 height: 35,
//                 width: 35,
//                 child: IconButton(
//                   icon: Icon(Icons.add,
//                       size: 20,
//                       color: appStore.isDarkMode ? Colors.black : darkCyan),
//                   onPressed: () {
//                     setState(() {
//                       if (selectedQty < varientQty) {
//                         selectedQty++;
//                       }
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(width: 16.0),
//             Text(
//               varientQty == 0
//                   ? language.lblOutOfStock
//                   : '${language.lblTotalStock}: $varientQty',
//               style: TextStyle(
//                   fontSize: 16.0,
//                   color: varientQty == 0
//                       ? redColor
//                       : appStore.isDarkMode
//                           ? Colors.white
//                           : Colors.black),
//             ),
//           ]),
//           SizedBox(height: 12.0),
//           _buildDivider(screenSize),
//         ],
//       ),
//     );
//   }

//   Widget _buildVariantOptions(prod.ProductDetailModel data, screenSize) {
//     return Visibility(
//       visible: data.productDetail?.choiceOptions?.isNotEmpty ?? false,
//       child: ListView.builder(
//         padding: EdgeInsets.all(5),
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: data.productDetail?.choiceOptions?.length,
//         itemBuilder: (BuildContext context, int index) {
//           var indexData = data.productDetail?.choiceOptions?[index];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 indexData?.title ?? '',
//                 style:
//                     TextStyle(color: appStore.isDarkMode ? whiteColor : black),
//               ),
//               SizedBox(
//                 height: 50,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: indexData?.options?.length,
//                   itemBuilder: (BuildContext context, int index2) {
//                     var optionData = indexData?.options?[index2];
//                     return Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: ChoiceChip(
//                           label: Text(optionData ?? ''),
//                           selected: selectedOptionList[index] == optionData
//                               ? true
//                               : false,
//                           onSelected: (ss) {
//                             selectedQty = 0;
//                             if (ss) {
//                               selectedOptionList[index] = optionData;
//                             }

//                             setState(() {});
//                           }),
//                     ).paddingOnly(bottom: 5);
//                   },
//                 ),
//               ),
//               SizedBox(height: 12.0),
//               _buildDivider(screenSize),
//               SizedBox(height: 12.0),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Widget _buildQuantityOptions(prod.ProductDetailModel data, variantCode) {
//   //   int varientQty = 0;

//   //   if (data.productDetail?.choiceOptions?.isNotEmpty ?? false) {
//   //     var matchingVariant = data.productDetail?.variants!.firstWhere(
//   //       (variant) => variant.variant == variantCode,
//   //     );

//   //     if (matchingVariant != null) {
//   //       varientQty = matchingVariant.qty ?? 0;
//   //     } else {
//   //       varientQty = 0;
//   //     }
//   //   } else {
//   //     varientQty = data.productDetail?.currentStock ?? 0;
//   //   }

//   //   return Container(
//   //     height: 50,
//   //     decoration: BoxDecoration(
//   //         color: Colors.white,
//   //         borderRadius: BorderRadius.circular(10),
//   //         border: Border.all(
//   //             color: selectedQty == null ? Colors.red : primaryColor)),
//   //     child: Center(
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: <Widget>[
//   //           DropdownButton<int>(
//   //             elevation: 0,
//   //             underline: SizedBox.shrink(),
//   //             hint: Text('Qty.'),
//   //             value: selectedQty,
//   //             onChanged: (newValue) {
//   //               setState(() {
//   //                 selectedQty = newValue!;
//   //               });

//   //               print(selectedQty);
//   //             },
//   //             items: List.generate(varientQty, (index) => index + 1)
//   //                 .map((int value) {
//   //               return DropdownMenuItem<int>(
//   //                 value: value,
//   //                 child: Text(value.toString()),
//   //               );
//   //             }).toList(),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
// ////////
// }


