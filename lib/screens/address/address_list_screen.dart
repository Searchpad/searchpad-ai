import 'package:booking_system_flutter/screens/products/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';

import '../../component/empty_error_state_widget.dart';
import '../../component/loader_widget.dart';
import '../../model/address_list_model.dart';
import '../../network/rest_apis.dart';
import '../products/product_details_screen.dart';
import 'address_create_screen.dart';
import 'address_edit_screen.dart';

class AddressListScreen extends StatefulWidget {
  final Function(Data dd)? callBack;
  final bool isFromCartPage;
  const AddressListScreen({
    Key? key,
    this.callBack,
    required this.isFromCartPage,
  }) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  Future<AddressListModel>? futureAddress;
  List<Data> addressList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getAddressList(false);
  }

  // void fetchCategoryList() async {
  //   futureCategory = getSubCategoryListAPI(catId: widget.categoryId!);
  // }

  void getAddressList(isSearch) async {
    futureAddress = fetchAddressList(
      offset: page,
      dataLimit: 10,
    );

    AddressListModel dd;

    dd = await futureAddress!;
    if (page == dd.pagination?.totalPages) {
      isLastPage = true;
    }
    if (isSearch) {
      addressList = [];
    }
    for (var element in dd.data!) {
      addressList.add(element);
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle:
          widget.isFromCartPage ? language.selectAddress : language.hintAddress,
      actions: [
        Visibility(
          visible: addressList.isNotEmpty,
          child: TextButton.icon(
              onPressed: () {
                AddressAddScreen(
                  callBack: () {
                    addressList = [];
                    page = 1;
                    isLastPage = false;
                    init();
                  },
                ).launch(context);
              },
              icon: Icon(Icons.add),
              label: Text(
                language.add,
                style: primaryTextStyle(),
              )),
        )
      ],
      child: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          children: [
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                page = 1;
                appStore.setLoading(true);
                getAddressList(true);
                setState(() {});

                return Future.value(false);
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  appStore.setLoading(true);
                  getAddressList(false);
                  setState(() {});
                }
              },
              children: [
                SnapHelperWidget(
                  future: futureAddress,
                  loadingWidget: LoaderWidget(),
                  errorBuilder: (p0) {
                    return NoDataWidget(
                      title: p0,
                      retryText: language.reload,
                      imageWidget: ErrorStateWidget(),
                      onRetry: () {
                        page = 1;
                        appStore.setLoading(true);
                        getAddressList(true);
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
                          itemCount: addressList.length,
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration:
                              FadeInConfiguration(duration: 2.seconds),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          emptyWidget: NoDataWidget(
                            title: language.noDataAvailable,
                            imageWidget: EmptyStateWidget(),
                            onRetry: () {
                              AddressAddScreen(
                                callBack: () {
                                  addressList = [];
                                  page = 1;
                                  isLastPage = false;
                                  init();
                                },
                              ).launch(context);
                            },
                            retryText: language.lblAddAddress,
                          ),
                          itemBuilder: (_, index) {
                            var dd = data.data?[index];
                            return InkWell(
                              onTap: !widget.isFromCartPage
                                  ? null
                                  : () {
                                      widget.callBack?.call(dd!);
                                      Navigator.pop(context);
                                    },
                              child: Card(
                                  color: appStore.isDarkMode
                                      ? darkSlateGrey
                                      : white,
                                  elevation: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(dd?.name ?? '',
                                              style: boldTextStyle(
                                                  size: 18,
                                                  weight: FontWeight.w600)),
                                          Text.rich(TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  "${dd?.address}, ${dd?.city}",
                                              style: primaryTextStyle(),
                                            ),
                                          ])),
                                          Text.rich(TextSpan(children: [
                                            TextSpan(
                                                text: 'Phone: ',
                                                style: boldTextStyle(
                                                    size: 14,
                                                    weight: FontWeight.w600)),
                                            TextSpan(
                                              text: "${dd?.phone ?? ''}",
                                              style: primaryTextStyle(),
                                            ),
                                          ])),
                                          Text.rich(TextSpan(children: [
                                            TextSpan(
                                                text: 'Email: ',
                                                style: boldTextStyle(
                                                    size: 14,
                                                    weight: FontWeight.w600)),
                                            TextSpan(
                                              text: "${dd?.email ?? ''}",
                                              style: primaryTextStyle(),
                                            )
                                          ])),
                                        ],
                                      ).expand(flex: 6),
                                      Column(
                                        children: [
                                          Visibility(
                                            visible: dd?.setDefault == 1,
                                            child: Column(
                                              children: [
                                                Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                primaryColor)),
                                                    child: Text(
                                                      'Default',
                                                      style: primaryTextStyle(
                                                          size: 12),
                                                    ).paddingOnly(
                                                        left: 10, right: 10)),
                                                10.height
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RoundCard(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      height: 40,
                                                      width: 40,
                                                      child: IconButton(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          onPressed: () {
                                                            AddressEditScreen(
                                                              addressDetail: dd,
                                                              callBack: () {
                                                                addressList =
                                                                    [];
                                                                page = 1;
                                                                isLastPage =
                                                                    false;
                                                                init();
                                                              },
                                                            ).launch(context);
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            size: 16,
                                                          ))),
                                                ),
                                                RoundCard(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: redColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      height: 40,
                                                      width: 40,
                                                      child: IconButton(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          onPressed: () {
                                                            showConfirmDialogCustom(
                                                              context,
                                                              dialogType:
                                                                  DialogType
                                                                      .DELETE,
                                                              title:
                                                                  '${language.deleteMessage}?',
                                                              positiveText:
                                                                  language
                                                                      .lblYes,
                                                              negativeText:
                                                                  language
                                                                      .lblNo,
                                                              onAccept:
                                                                  (p0) async {
                                                                var resp =
                                                                    await deleteShippingAddress(
                                                                        dd?.id);

                                                                if (resp['message']
                                                                        [
                                                                        'status'] ==
                                                                    true) {
                                                                  Fluttertoast.showToast(
                                                                      msg: resp[
                                                                              'message']
                                                                          [
                                                                          'message']);
                                                                  addressList
                                                                      .removeAt(
                                                                          index);
                                                                  setState(
                                                                      () {});
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg: resp[
                                                                              'message']
                                                                          [
                                                                          'message']);
                                                                }
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.delete,
                                                            color: white,
                                                            size: 16,
                                                          ))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).expand(flex: 4)
                                    ],
                                  ).paddingAll(10)

                                  // ListTile(
                                  //     title:
                                  //     subtitle: Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         Text.rich(TextSpan(children: [
                                  //           TextSpan(
                                  //             text:
                                  //                 "${dd?.address}, ${dd?.city}",
                                  //             style: primaryTextStyle(),
                                  //           ),
                                  //         ])),
                                  //         Text.rich(TextSpan(children: [
                                  //           TextSpan(
                                  //               text: 'Phone: ',
                                  //               style: boldTextStyle(
                                  //                   size: 14,
                                  //                   weight: FontWeight.w600)),
                                  //           TextSpan(
                                  //             text: "${dd?.phone ?? ''}",
                                  //             style: primaryTextStyle(),
                                  //           ),
                                  //         ])),
                                  //         Text.rich(TextSpan(children: [
                                  //           TextSpan(
                                  //               text: 'Email: ',
                                  //               style: boldTextStyle(
                                  //                   size: 14,
                                  //                   weight: FontWeight.w600)),
                                  //           TextSpan(
                                  //             text: "${dd?.email ?? ''}",
                                  //             style: primaryTextStyle(),
                                  //           )
                                  //         ])),
                                  //       ],
                                  //     ),
                                  //     trailing: ),
                                  ),
                            );
                          },
                        ).paddingAll(8),
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
