import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/model/cart_list_model.dart';
import 'package:booking_system_flutter/model/payment_options_model.dart';
import 'package:booking_system_flutter/screens/address/address_list_screen.dart';
import 'package:booking_system_flutter/screens/products/cart_provider.dart';
import 'package:booking_system_flutter/screens/products/screen_loader.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../component/back_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../../utils/colors.dart';
import '../../utils/constant.dart';
import '../../model/address_list_model.dart' as add;
import '../orders/order_placed.dart';

class CartListScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartListScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _orderNote = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PaymentOptionModel? paymenOptions;
  Map? cartSummary;
  int? userId;

  int? selectedOption;
  String selectedPaymentName = "";
  bool isForGift = false;
  add.Data? selectedAddress;

  getCartSummart(load) async {
    if (load) {
      Loaders.start(context);
    }
    var resp = await getCartSummary();
    if (resp != null) {
      cartSummary = resp;
    }
    if (load) {
      Loaders.stop(context);
    }
    setState(() {});
  }

  getPaymentOptions() async {
    paymenOptions = await getPaymentListOption();
  }

  shippingCost() async {
    await getShippingCost();
    await getCartSummart(false);
  }

  initFunc() async {
    await shippingCost();
    await getPaymentOptions();
    // await context.read<CartProvider>().getCartList();

    setState(() {});
  }

  DateTime? selectedDateTime;

  Future<void> _selectDateTime(productDays) async {
    selectedDateTime = await showDateTimeAfterNDays(context, productDays);
    setState(() {});
  }

  @override
  void initState() {
    initFunc();
    super.initState();
  }

  @override
  void dispose() {
    paymenOptions = PaymentOptionModel();
    cartSummary = {};
    userId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: appBarWidget(
          "",
          backWidget: BackWidget(iconColor: white),
          color: context.primaryColor,
          systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: context.primaryColor,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light),
          titleWidget: Text(
            language.lblCartList,
            style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
          ),
        ),
        body: SnapHelperWidget<CartListModel>(
          future: context.watch<CartProvider>().cartList,
          onSuccess: (data) {
            if (data.message?.status == false) {
              return NoDataWidget(
                title: language.emptyCart,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  appStore.setLoading(true);

                  context.read<CartProvider>().getCartList();
                },
              );
            } else {
              userId = data.message?.data?.isEmpty ?? false
                  ? 0
                  : data.message?.data?.first.userId;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    selectedAddress != null
                        ? ListTile(
                            title: Text(
                              selectedAddress?.name ?? '',
                              style: TextStyle(
                                  color:
                                      appStore.isDarkMode ? whiteColor : black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${language.hintAddress}: ${selectedAddress?.address}, ${selectedAddress?.city}",
                                  style: TextStyle(
                                      color: appStore.isDarkMode
                                          ? whiteColor
                                          : black),
                                ),
                                Text(
                                  "${language.lblPhone}: ${selectedAddress?.phone}",
                                  style: TextStyle(
                                      color: appStore.isDarkMode
                                          ? whiteColor
                                          : black),
                                ),
                                Text(
                                  "${language.email}: ${selectedAddress?.email}",
                                  style: TextStyle(
                                      color: appStore.isDarkMode
                                          ? whiteColor
                                          : black),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.change_circle,
                                  color: primaryColor),
                              onPressed: () {
                                AddressListScreen(
                                  callBack: (data) {
                                    selectedAddress = data;
                                    setState(() {});
                                  },
                                  isFromCartPage: true,
                                ).launch(context);
                              },
                            ),
                          )
                        : ListTile(
                            onTap: () {
                              AddressListScreen(
                                callBack: (data) {
                                  selectedAddress = data;
                                  setState(() {});
                                },
                                isFromCartPage: true,
                              ).launch(context);
                            },
                            title: Text(
                              '${language.hintAddress}',
                              style: primaryTextStyle(size: 16),
                            ),
                            trailing: Icon(
                              Icons.arrow_drop_down_circle_rounded,
                              color: primaryColor,
                            )),
                    Divider(),
                    _cartItemWidget(data),
                    AppTextField(
                      textFieldType: TextFieldType.MULTILINE,
                      controller: _orderNote,
                      errorThisFieldRequired: language.requiredText,
                      decoration: inputDecoration(context,
                          labelText: language.orderNotes),
                      suffix: ic_message.iconImage(size: 10).paddingAll(14),
                      autoFillHints: [AutofillHints.addressState],
                    ).paddingOnly(left: 10, right: 10),
                    20.height,
                    Divider(),
                    Column(
                      children: [
                        SettingItemWidget(
                          leading: ic_gift.iconImage(size: SETTING_ICON_SIZE),
                          title: language.isGifted,
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Switch.adaptive(
                              value: getBoolAsync(AUTO_SLIDER_STATUS,
                                  defaultValue: isForGift),
                              onChanged: (v) {
                                isForGift = v;
                                setState(() {});
                              },
                            ).withHeight(24),
                          ),
                        ),
                        Visibility(
                          visible: isForGift,
                          child: texField(_phoneController,
                                  language.receiverPhone, TextFieldType.PHONE)
                              .paddingAll(10),
                        ),
                      ],
                    ),
                    Divider(),
                    20.height,
                    TextButton(
                        onPressed: () {
                          showDateTimeAfterNDays(context, 5);
                        },
                        child: chooseDeliveryWidget(
                          data.message?.data?[0].productionDays ?? 0,
                        )),
                    Divider(),
                    20.height,
                    Visibility(
                      visible:
                          cartSummary?['coupon_applied'] == true ? false : true,
                      child: ApplyCouponWidget(
                        couponController: _couponController,
                        formKey: _formKey,
                        func: () {
                          getCartSummart(true);
                        },
                      ),
                    ),
                    SummaryView(
                      couponController: _couponController,
                      couponApplied: cartSummary?['coupon_applied'] ?? false,
                      couponCode: cartSummary?['coupon_code'] ?? '',
                      discount: cartSummary?['discount'].toString() ?? '',
                      grandTotal: cartSummary?['grand_total'].toString() ?? '',
                      grandTotalValue:
                          cartSummary?['grand_total_value'].toString() ?? '',
                      shippingCost:
                          cartSummary?['shipping_cost'].toString() ?? '',
                      status: cartSummary?['status'] ?? false,
                      subTotal: cartSummary?['sub_total'] ?? '',
                      tax: cartSummary?['tax'] ?? '',
                      callSummary: () {
                        getCartSummart(true);
                      },
                    ),
                    Divider(),
                    _getPaymentOptions(),
                  ],
                ),
              );
            }
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                appStore.setLoading(true);

                context.read<CartProvider>().getCartList();
              },
            );
          },
          loadingWidget: LoaderWidget(),
        ),
        bottomNavigationBar: Visibility(
          visible: context.watch<CartProvider>().showCheckOut != false &&
              selectedPaymentName != "",
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onTap: () async {
                if (selectedAddress != null) {
                  if (selectedDateTime != null) {
                    Loaders.start(context);
                    await addShippingAddres(
                        {"address_id": selectedAddress?.id});
                    var resp = await placeOrder({
                      "payment_type": selectedPaymentName,
                      "additional_info": _orderNote.text.toString(),
                      "delivery_datetime": getDateTime(date: selectedDateTime),
                      "is_gifted": isForGift == true ? 1 : 0,
                      "receiver_phone_number": _phoneController.text.toString(),
                    });
                    Loaders.stop(context);

                    if (selectedPaymentName == "cash" &&
                        resp['message']['status'] == true) {
                      OrderPlacedScreen(
                        paymentSuccessful: true,
                        isCOD: true,
                      ).launch(context);
                    } else {
                      if (resp['message']['status'] == true) {
                        PaymentView(
                                combiantionId: resp['message']
                                    ['combined_order_id'],
                                url:
                                    "https://admin.munasbat.app/api/pay-with-tap?combined_order_id=${resp['message']['combined_order_id']}&user_id=$userId"
                                // "https://munasbat.thtbh.com/api/pay-with-tap?combined_order_id=${resp['message']['combined_order_id']}&user_id=$userId", OLD
                                )
                            .launch(context);
                      } else {
                        Fluttertoast.showToast(msg: resp['message']['message']);
                        navigatorKey.currentContext!
                            .read<CartProvider>()
                            .getCartList();
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "${language.selectDeliveryDate}");
                  }
                } else {
                  toast(language.lblAddAddress);
                }
              },
              color: context.primaryColor,
              child: Text(language.lblCheckout,
                  style: boldTextStyle(color: white)),
              width: context.width(),
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget texField(controller, label, textFieldType) {
    return AppTextField(
      textFieldType: textFieldType,
      controller: controller,
      errorThisFieldRequired: language.requiredText,
      decoration: inputDecoration(context, labelText: label),
    );
  }

  Column _getPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Text('${language.lblChoosePaymentMethod}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appStore.isDarkMode ? whiteColor : black,
              )),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: paymenOptions?.message?.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var paymentIndex = paymenOptions?.message?.data?[index];
              return Column(
                children: [
                  RadioListTile<String>(
                      value: paymentIndex!.type!,
                      groupValue: selectedPaymentName,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              paymentIndex.title ?? '',
                              style: TextStyle(
                                color: appStore.isDarkMode ? whiteColor : black,
                              ),
                            ),
                          ),
                          paymentIndex.type == "cash"
                              ? Image.asset(
                                  'assets/images/money.png',
                                  height: 35,
                                )
                              : Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/mastercard.png',
                                      height: 35,
                                    ),
                                    UIHelper.horizontalSpaceSmall(),
                                    Image.asset(
                                      'assets/images/visa.png',
                                      height: 35,
                                    ),
                                    UIHelper.horizontalSpaceSmall(),
                                    Image.asset(
                                      'assets/images/american-express.png',
                                      height: 35,
                                    ),
                                    UIHelper.horizontalSpaceSmall(),
                                    Image.asset(
                                      'assets/images/apple-pay.png',
                                      height: 35,
                                    ),
                                  ],
                                )
                        ],
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentName = value!;
                        });
                      }),
                  Divider()
                ],
              );
            })
      ],
    );
  }

  ListView _cartItemWidget(CartListModel data) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      itemCount: data.message?.data?.length,
      itemBuilder: (context, index) {
        final item = data.message?.data?[index];
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
                              color: appStore.isDarkMode ? whiteColor : black)),
                      Visibility(
                        visible: item?.variation != null,
                        child: Text(
                            "${language.lblVariation}: ${item?.variation}",
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    appStore.isDarkMode ? whiteColor : black)),
                      ),
                      Text("${language.lblPrice}: ${item?.price.toString()}",
                          style: TextStyle(
                              fontSize: 14,
                              color: appStore.isDarkMode ? whiteColor : black)),
                      Text(
                          "${language.lblQuantity}: ${item?.quantity.toString()}",
                          style: TextStyle(
                              fontSize: 14,
                              color: appStore.isDarkMode ? whiteColor : black)),
                    ],
                  ),
                ),
                UIHelper.horizontalSpaceMedium(),
                IconButton(
                    onPressed: () {
                      deleteCartDialog(
                          context, item?.id, data.message?.data?.length, () {
                        initFunc();
                      });
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: primaryColor,
                    ))
              ],
            ),
            Divider(
              height: 20,
            )
          ],
        );
      },
    );
  }

  deleteCartDialog(context, cartId, length, callBack) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            language.lblDeleteShoppingCart,
            style: boldTextStyle(),
          ),
          content: Text(
            language.areYouSureCart,
            style: primaryTextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(navigatorKey.currentContext!)
                    .pop(); // Close the dialog
                Loaders.start(navigatorKey.currentContext);
                await removeSingleCart(data: {"id": cartId});
                navigatorKey.currentContext!.read<CartProvider>().getCartList();
                Loaders.stop(navigatorKey.currentContext);
                Fluttertoast.showToast(msg: language.cartDeleted);
                await initFunc();

                // if (length > 1) {
                //   Loaders.start(context);
                //   await removeSingleCart(data: {"id": cartId});
                //   context.read<CartProvider>().removerCartData();
                //   await callBack.call();
                //   Loaders.stop(context);

                //   Navigator.of(context).pop(); // back screen
                // } else {
                //   Loaders.start(context);
                //   await removeSingleCart(data: {"id": cartId});
                //   context.read<CartProvider>().removerCartData();
                //   Fluttertoast.showToast(msg: language.cartDeleted);
                //   Navigator.of(context).pop(); // Close the dialog
                //   Loaders.stop(context);
                //   Navigator.of(context).pop(); // back screen
                // }
              },
              child: Text(language.lblContinue),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(language.lblCancel),
            ),
          ],
        );
      },
    );
  }

  Widget chooseDeliveryWidget(productionDays) {
    return Container(
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: grey, width: .4)),
      child: Center(
        child: Row(
          children: [
            ic_calendar.iconImage(size: SETTING_ICON_SIZE),
            10.width,
            Expanded(
              child: Text(
                selectedDateTime != null
                    ? getDateTime(date: selectedDateTime)
                    : language.selectDeliveryDate,
                style: primaryTextStyle(),
              ),
            ),
            TextButton(
                onPressed: () {
                  _selectDateTime(productionDays);
                  // _showDateTimePicker(context);
                },
                child: Text(
                  selectedDateTime != null
                      ? language.changeLbl
                      : language.selectLbl,
                  style: boldTextStyle(
                      color: appStore.isDarkMode
                          ? primaryColor
                          : primaryColorDark),
                ))
          ],
        ),
      ),
    );
  }
}

class ApplyCouponWidget extends StatefulWidget {
  const ApplyCouponWidget({
    super.key,
    required TextEditingController couponController,
    required this.formKey,
    required this.func,
  }) : _couponController = couponController;

  final TextEditingController _couponController;
  final GlobalKey<FormState> formKey;
  final Function() func;

  @override
  State<ApplyCouponWidget> createState() => _ApplyCouponWidgetState();
}

class _ApplyCouponWidgetState extends State<ApplyCouponWidget> {
  bool? invalidCode;
  String? msg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      style: TextStyle(
                          color: appStore.isDarkMode ? whiteColor : black),
                      controller: widget._couponController,
                      onChanged: (ss) {
                        invalidCode = null;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return language.lblInvalidCoupon;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: language.lblCoupon,
                        hintStyle: TextStyle(
                            color: appStore.isDarkMode ? whiteColor : black),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 215, 215, 215)),
                            borderRadius: BorderRadius.circular(10)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 4,
                  child: AppButton(
                    onTap: () async {
                      if (widget.formKey.currentState!.validate()) {
                        var resp = await applyCoupon(
                            {"coupon_code": widget._couponController.text});
                        if (resp['message']['status'] == true) {
                          await widget.func();
                          msg = resp['message']['message'];
                          invalidCode = false;
                        } else {
                          msg = resp['message']['message'];
                          invalidCode = true;
                        }
                      }
                      setState(() {});
                    },
                    color: context.primaryColor,
                    child: Text(language.applyCoupon,
                        style: boldTextStyle(color: white)),
                    width: context.width(),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpaceExtraSmall(),
            Visibility(
                visible: invalidCode != null,
                child: invalidCode == true
                    ? Text(
                        msg ?? '',
                        style: TextStyle(color: redColor),
                      )
                    : Text(msg ?? '', style: TextStyle(color: greenColor)))
          ],
        ),
      ),
    );
  }
}

class SummaryView extends StatelessWidget {
  final bool status;
  final String subTotal;
  final String tax;
  final String shippingCost;
  final String discount;
  final String grandTotal;
  final String grandTotalValue;
  final String couponCode;
  final bool couponApplied;
  final TextEditingController couponController;
  final Function() callSummary;

  SummaryView({
    required this.status,
    required this.subTotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    required this.grandTotal,
    required this.grandTotalValue,
    required this.couponCode,
    required this.couponApplied,
    required this.couponController,
    required this.callSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.lblOrderStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                status ? 'Confirmed' : 'Not Confirmed',
                style: TextStyle(
                  color: status ? Colors.green : Colors.red,
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
                language.lblSubTotal,
                style: TextStyle(
                  fontSize: 15.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                subTotal,
                style: TextStyle(
                  fontSize: 14.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.lblTax,
                style: TextStyle(
                  fontSize: 15.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                tax,
                style: TextStyle(
                  fontSize: 14.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.lblShippingChange,
                style: TextStyle(
                  fontSize: 15.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                '${shippingCost.toString()}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.lblDiscount,
                style: TextStyle(
                  fontSize: 15.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                '${discount.toString()}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Visibility(
            visible: couponCode == "" || couponCode == "null" ? false : true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      language.lblCoupon,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    TextButton(
                        onPressed: () async {
                          await removeCoupon();
                          await callSummary();
                        },
                        child: Text(
                          language.remove,
                          style: TextStyle(
                            color: appStore.isDarkMode ? whiteColor : black,
                          ),
                        )),
                  ],
                ),
                Text(
                  couponCode,
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.totalAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
              Text(
                grandTotal,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: appStore.isDarkMode ? whiteColor : black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentView extends StatefulWidget {
  const PaymentView(
      {super.key, required this.combiantionId, required this.url});

  final int combiantionId;
  final String url;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewController paymentController;

  @override
  void initState() {
    super.initState();
    initPayment(widget.url);
  }

  initPayment(url) {
    paymentController = WebViewController();
    paymentController
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      );
    paymentController.addJavaScriptChannel(
      'Print',
      onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
      },
    );
    paymentController.loadRequest(Uri.parse(url));
    paymentController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        log('Start: $url');
      },
      onPageFinished: (url) async {
        if (url.contains('api/tap-result')) {
          var res = await checkPaymentStatus(
              {"combined_order_id": widget.combiantionId});
          Navigator.pop(context);

          if (res['message']['status'] == true) {
            OrderPlacedScreen(
              paymentSuccessful: true,
              isCOD: false,
            ).launch(context);
          } else {
            OrderPlacedScreen(
              paymentSuccessful: false,
              isCOD: false,
            ).launch(context);
          }
          print(res);
        }

        log('End: $url');
        // if (url.contains('https://sadadqa.com/invoicedetail')) getHtmlBody(url);
      },
      onProgress: (progress) {
        //
      },
      onNavigationRequest: (request) {
        return NavigationDecision.navigate;
      },
    ));

    log('URL: $url');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onback(widget.combiantionId),
      child: WebViewWidget(
        controller: paymentController,
      ),
    );
  }
}

Future<bool> onback(combinationOrderId) async {
  try {
    var resp =
        await checkPaymentStatus({"combined_order_id": combinationOrderId});

    Navigator.pop(navigatorKey.currentContext!);

    if (resp['message']['status'] == true) {
      OrderPlacedScreen(
        paymentSuccessful: true,
        isCOD: false,
      ).launch(navigatorKey.currentContext!);
    } else {
      OrderPlacedScreen(
        paymentSuccessful: false,
        isCOD: false,
      ).launch(navigatorKey.currentContext!);
    }
  } catch (e) {
    OrderPlacedScreen(
      paymentSuccessful: false,
      isCOD: false,
    ).launch(navigatorKey.currentContext!);
  }

  return true;
}

Future<DateTime?> showDateTimeAfterNDays(BuildContext context, int days) async {
  final now = DateTime.now();
  final minimumSelectableDate =
      now.add(Duration(days: days)); // Minimum selectable date

  final selectedDateTime = await showDatePicker(
    context: context,
    initialDate: minimumSelectableDate,
    firstDate: minimumSelectableDate,
    lastDate: DateTime(2100), // Adjust lastDate as needed,
  );

  if (selectedDateTime != null) {
    final selectedTime = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );
    if (selectedTime != null) {
      return selectedDateTime.add(
          Duration(hours: selectedTime.hour, minutes: selectedTime.minute));
    }
  }

  return null; // Return null if no date or time is selected
}

// void _showDateTimePicker(BuildContext context) {
//   showCupertinoModalPopup(
//     context: context,
//     builder: (BuildContext builderContext) {
//       return Container(
//         height: 300.0,
//         color: Colors.white,
//         child: CupertinoDatePicker(
//           mode: CupertinoDatePickerMode.dateAndTime,
//           // initialDateTime: _selectedDateTime,
//           onDateTimeChanged: (DateTime newDateTime) {
//             // setState(() {
//             //   _selectedDateTime = newDateTime;
//             // });
//           },
//         ),
//       );
//     },
//   );
// }

// Future<void> _showDatePicker(int days) async {
//   final now = DateTime.now();
//   final minimumDate = now.add(Duration(days: days));

// CupertinoDa

//   final result = await CupertinoDateTimePicker.showDateTimePicker(
//     context: context,
//     initialDateTime: minimumDate,
//     minimumDate: minimumDate,
//   );

//   if (result != null) {
//     setState(() => selectedDateTime = result);
//   }
// }

// class ChooseDeliveryDate extends StatefulWidget {
//   const ChooseDeliveryDate({Key? key, required this.productionDays})
//       : super(key: key);

//   final int productionDays;

//   @override
//   State<ChooseDeliveryDate> createState() => _ChooseDeliveryDateState();
// }

// class _ChooseDeliveryDateState extends State<ChooseDeliveryDate> {

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

getDateTime<String>({date, format}) {
  if (date == null) {
    return null;
  } else {
    var outputFormat = DateFormat(format ?? 'dd-MMM-yyyy - hh:mm a');
    var outputDate = outputFormat.format(date);
    return outputDate;
  }
}
