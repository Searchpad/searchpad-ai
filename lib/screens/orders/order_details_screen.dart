import 'package:booking_system_flutter/screens/products/product_details_view.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:booking_system_flutter/model/order_detail_mode.dart';

import '../../component/back_widget.dart';
import '../../component/cached_image_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../component/loader_widget.dart';
import '../../main.dart';
import '../../model/order_item_detail_model.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  Future<OrderDetailModel>? orderDetail;
  OrderItemDetailModel orderItemDetailModel = OrderItemDetailModel();

  getProdDetails() async {
    orderDetail = ferOrderDetails(orderId: widget.orderId);
  }

  getOrderItem() async {
    orderItemDetailModel = await ferOrderItemDetails(orderId: widget.orderId);
  }

  initFunctions() async {
    await getOrderItem();
    await getProdDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        backWidget: BackWidget(iconColor: white),
        color: context.primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: context.primaryColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        titleWidget: Text(
          language.lblDetails,
          style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
        ),
      ),
      body: SnapHelperWidget<OrderDetailModel>(
        future: orderDetail,
        onSuccess: (data) {
          return OrderDetailsPage(
            orderDetailData: data,
            orderItemDetail: orderItemDetailModel,
          );
        },
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: language.reload,
            onRetry: () {
              appStore.setLoading(true);

              getProdDetails();
              setState(() {});
            },
          );
        },
        loadingWidget: LoaderWidget(),
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final OrderDetailModel orderDetailData;
  final OrderItemDetailModel orderItemDetail;

  const OrderDetailsPage(
      {super.key,
      required this.orderDetailData,
      required this.orderItemDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cartItemWidget(orderItemDetail),
            _orderNotes(),
            _shippingAddress(),
            _orderSummary(),
          ],
        ),
      ),
    );
  }

  Column _orderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.lblOrderStatus}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appStore.isDarkMode ? white : black,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.deliveryStatusString ?? '',
                  style: TextStyle(
                    color: orderDetailData.orderDetail?.deliveryStatusString
                                ?.toLowerCase() ==
                            "confirmed"
                        ? Colors.green
                        : yellowGreen,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.paymentStatus}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.paymentStatus?.toUpperCase() ??
                      '',
                  style: TextStyle(
                    color: orderDetailData.orderDetail?.paymentStatus
                                ?.toLowerCase() ==
                            "paid"
                        ? Colors.green
                        : Colors.red,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.isGifted}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.isGifted == 1 ? "Yes" : "No",
                  style: TextStyle(
                    // color: orderDetailData.orderDetail?.paymentStatus
                    //             ?.toLowerCase() ==
                    //         "paid"
                    //     ? Colors.green
                    //     : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.receiverPhone}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.receiverPhoneNumber == ""
                      ? "N/A"
                      : orderDetailData.orderDetail?.receiverPhoneNumber ?? '',
                  style: TextStyle(
                    // color: orderDetailData.orderDetail?.paymentStatus
                    //             ?.toLowerCase() ==
                    //         "paid"
                    //     ? Colors.green
                    //     : Colors.red,
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.deliveryDateTime,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.delivertDateTime == ""
                      ? "N/A"
                      : orderDetailData.orderDetail?.delivertDateTime ?? '',
                  style: TextStyle(
                    // color: orderDetailData.orderDetail?.paymentStatus
                    //             ?.toLowerCase() ==
                    //         "paid"
                    //     ? Colors.green
                    //     : Colors.red,
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.paymentDetail}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.paymentStatus?.toLowerCase() ==
                          "paid"
                      ? orderDetailData.orderDetail?.paymentType ?? ''
                      : "${language.cashOnDelivery}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Visibility(
              visible: orderDetailData.orderDetail?.txnId != "",
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${language.transactionId}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: appStore.isDarkMode ? white : black,
                        ),
                      ),
                      Text(
                        orderDetailData.orderDetail?.txnId ?? '',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: appStore.isDarkMode ? white : black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.lblSubTotal}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.subtotal ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.lblShippingChange}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.shippingCost.toString() ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.lblTax}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.tax.toString() ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.lblDiscount}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  '${orderDetailData.orderDetail?.couponDiscount.toString()}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${language.totalAmount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  orderDetailData.orderDetail?.grandTotal ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        )
      ],
    );
  }

  Widget _orderNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${language.additionalInfo}:',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appStore.isDarkMode ? white : black),
        ),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderDetailData.orderDetail?.additionalInfo.toString() ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appStore.isDarkMode ? white : black,
              ),
            ),
          ],
        ),
        Divider(height: 40),
      ],
    ).visible(orderDetailData.orderDetail?.additionalInfo != "");
  }

  Column _shippingAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${language.hintAddress}:',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: appStore.isDarkMode ? white : black),
        ),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderDetailData.orderDetail?.shippingAddress?.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: appStore.isDarkMode ? white : black,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${orderDetailData.orderDetail?.shippingAddress?.address ?? ''}, ${orderDetailData.orderDetail?.shippingAddress?.city ?? ''}",
                  style: TextStyle(
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  "${language.lblPhone}: ${orderDetailData.orderDetail?.shippingAddress?.phone ?? ''}",
                  style: TextStyle(
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
                Text(
                  "${language.hintEmailTxt}: ${orderDetailData.orderDetail?.shippingAddress?.email ?? ''}",
                  style: TextStyle(
                    color: appStore.isDarkMode ? white : black,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(height: 40),
      ],
    );
  }

  Widget _cartItemWidget(OrderItemDetailModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${language.lblDetails}:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: appStore.isDarkMode ? white : black,
          ),
        ),
        SizedBox(height: 5),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          itemCount: data.orderItems?.length,
          itemBuilder: (context, index) {
            final item = data.orderItems?[index];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImageWidget(
                      url: item?.productThumbnailImage ?? '',
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                    UIHelper.horizontalSpaceMedium(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item?.productName ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: appStore.isDarkMode ? white : black,
                              )),
                          Visibility(
                            visible: item?.variation == null ||
                                    language.lblVariation == ""
                                ? false
                                : true,
                            child: Text(
                                "${language.lblVariation}: ${item?.variation}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: appStore.isDarkMode ? white : black,
                                )),
                          ),
                          Text("${language.price}: ${item?.price.toString()}",
                              style: TextStyle(
                                fontSize: 14,
                                color: appStore.isDarkMode ? white : black,
                              )),
                          Text("${language.lblQuantity}: ${item?.quantity}",
                              style: TextStyle(
                                fontSize: 14,
                                color: appStore.isDarkMode ? white : black,
                              )),
                        ],
                      ),
                    ),
                  ],
                ).onTap(() {
                  ProductDetailsView(
                    productId: item?.productId ?? 0,
                    userId: appStore.userId ?? 0,
                  ).launch(context);
                }),
                Divider(
                  height: 25,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
