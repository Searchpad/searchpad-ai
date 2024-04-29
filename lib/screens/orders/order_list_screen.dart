import 'package:booking_system_flutter/model/order_list_model.dart';
import 'package:booking_system_flutter/screens/orders/order_component.dart';

import 'package:booking_system_flutter/utils/common.dart';
import 'package:flutter/material.dart';

import 'package:booking_system_flutter/component/loader_widget.dart';

import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:flutter/services.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../component/back_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';
import 'order_details_screen.dart';

class AllOrderListScreen extends StatefulWidget {
  final int? brandId;
  final int? categoryId;
  final int? subCategoryId;
  final int? providerId;
  final String? search;

  const AllOrderListScreen(
      {super.key,
      this.brandId,
      this.categoryId,
      this.subCategoryId,
      this.providerId,
      this.search});

  @override
  State<AllOrderListScreen> createState() => _AllOrderListScreenState();
}

class _AllOrderListScreenState extends State<AllOrderListScreen> {
  Future<OrderListModel>? futureOrderList;
  List<Data>? orderList = [];

  String? selectedStatusValue = 'all';
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchAllOrderList(false);
  }

  // void fetchCategoryList() async {
  //   futureCategory = getSubCategoryListAPI(catId: widget.categoryId!);
  // }

  void fetchAllOrderList(isSearch) async {
    appStore.setLoading(true);
    futureOrderList = fetchOrderList(
        offset: page, dataCount: 10, orderStatus: selectedStatusValue);
    OrderListModel dd;
    dd = await futureOrderList!;
    if (page == dd.pagination?.totalPages) {
      isLastPage = true;
    }
    if (isSearch) {
      orderList?.clear();
      isLastPage = false;
      page = 1;
    }
    for (var element in dd.data!) {
      orderList?.add(element);
    }
    setState(() {});
  }

  Widget subCategoryWidget() {
    return SnapHelperWidget<OrderListModel>(
      future: futureOrderList,
      // initialData: cachedSubcategoryList
      //     .firstWhere((element) => element?.$1 == widget.categoryId.validate(),
      //         orElse: () => null)
      //     ?.$2,
      loadingWidget: Offstage(),
      onSuccess: (list) {
        if (list.data?.length == 1) return Offstage();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Text(language.lblSubcategories,
                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                .paddingLeft(16),
            16.height,
          ],
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    filterStore.clearFilters();

    filterStore.setSelectedSubCategory(catId: 0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("",
          backWidget: BackWidget(iconColor: white),
          color: context.primaryColor,
          systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: context.primaryColor,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light),
          titleWidget: Text(
            language.orderList,
            style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
          ),
          showBack: false),
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          children: [
            OrderStatusDropdown(
                selectedStatus: selectedStatusValue ?? '',
                onValueChanged: (ss) {
                  selectedStatusValue = ss;
                  fetchAllOrderList(true);
                }).paddingAll(5),
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                page = 1;
                appStore.setLoading(true);
                fetchAllOrderList(true);
                setState(() {});

                return Future.value(false);
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  appStore.setLoading(true);
                  fetchAllOrderList(false);
                  setState(() {});
                }
              },
              children: [
                if (widget.categoryId != null) subCategoryWidget(),
                16.height,
                SnapHelperWidget(
                  future: futureOrderList,
                  loadingWidget: LoaderWidget(),
                  errorBuilder: (p0) {
                    return NoDataWidget(
                      title: p0,
                      retryText: language.reload,
                      imageWidget: ErrorStateWidget(),
                      onRetry: () {
                        page = 1;
                        appStore.setLoading(true);
                        fetchAllOrderList(true);
                        setState(() {});
                      },
                    );
                  },
                  onSuccess: (data) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedListView(
                          itemCount: orderList?.length,
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration:
                              FadeInConfiguration(duration: 2.seconds),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          emptyWidget: NoDataWidget(
                            title: language.noDataAvailable,
                            imageWidget: EmptyStateWidget(),
                          ),
                          itemBuilder: (_, index) {
                            var dd = orderList?[index];
                            return InkWell(
                              onTap: () {
                                OrderDetailsScreen(orderId: dd.id.toString())
                                    .launch(context);
                              },
                              child: OrderComponent(
                                  orderItems: dd!.orderItems!.first,
                                  isGifted: dd.isGifted ?? 0,
                                  orderData: dd,
                                  provider: dd.provider!),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}

// class OrderListScreen extends StatelessWidget {
//   final Data productData;

//   const OrderListScreen({super.key, required this.productData});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         OrderDetailsScreen(orderId: productData.id.toString()).launch(context);
//       },
//       child: Card(
//         color: appStore.isDarkMode ? Color(0x42323232) : white,
//         margin: EdgeInsets.all(0),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.0),
//             // border: Border.all(
//             //   color: Colors.grey,
//             //   width: 1.0,
//             // ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${language.lblId}: ${productData.code}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                         color: appStore.isDarkMode ? white : black,
//                       ),
//                     ),
//                     Text(
//                       '${language.lblDate}: ${productData.date}',
//                       style: TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   '${language.paymentDetail}: ${productData.paymentType}',
//                   style: TextStyle(
//                     fontSize: 15.0,
//                     color: appStore.isDarkMode ? white : black,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Row(
//                   children: [
//                     Text(
//                       '${language.paymentStatus}: ',
//                       style: TextStyle(
//                         fontSize: 15.0,
//                         color: appStore.isDarkMode ? white : black,
//                       ),
//                     ),
//                     Text(
//                       '${productData.paymentStatusString}',
//                       style: TextStyle(
//                           fontSize: 15.0,
//                           color:
//                               productData.paymentStatusString?.toLowerCase() ==
//                                       "paid"
//                                   ? greenColor
//                                   : redColor),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   '${language.lblOrderStatus}: ${productData.deliveryStatus}',
//                   style: TextStyle(
//                     fontSize: 15.0,
//                     color: appStore.isDarkMode ? white : black,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   '${language.totalAmount}: ${productData.grandTotal}',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0,
//                     color: appStore.isDarkMode ? white : black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class OrderStatusDropdown extends StatefulWidget {
  final Function(String value) onValueChanged;
  final String selectedStatus;

  OrderStatusDropdown({
    required this.onValueChanged,
    Key? key,
    required this.selectedStatus,
  }) : super(key: key);

  @override
  _OrderStatusDropdownState createState() => _OrderStatusDropdownState();
}

class _OrderStatusDropdownState extends State<OrderStatusDropdown> {
  String? defaultValue = 'all';

  List statusData = [
    {"code": "all", "value": language.lblViewAll},
    {"code": "pending", "value": language.lblPending},
    {"code": "confirmed", "value": language.confirmed},
    {"code": "picked_up", "value": language.pickedUp},
    {"code": "on_the_way", "value": language.onTheWay},
    {"code": "delivered", "value": language.delivered},
    {"code": "cancelled", "value": language.cancelled},
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      onChanged: (value) {
        widget.onValueChanged.call(value!);
      },
      value: defaultValue,
      isExpanded: true,
      // validator: widget.isValidate
      //     ? (c) {
      //         if (c == null) return language.requiredText;
      //         return null;
      //       }
      //     : null,
      decoration: inputDecoration(context),
      dropdownColor: context.cardColor,
      alignment: Alignment.bottomCenter,
      items: List.generate(
        statusData.length,
        (index) {
          var data = statusData[index];
          return DropdownMenuItem(
            value: data['code'],
            child: Text(data['value'], style: primaryTextStyle()),
          );
        },
      ),
    );
  }
}
