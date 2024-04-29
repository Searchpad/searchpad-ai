import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/provider_info_screen.dart';
import 'package:booking_system_flutter/screens/products/cart_list_screen.dart';
import 'package:booking_system_flutter/screens/products/cart_provider.dart';
import 'package:booking_system_flutter/screens/products/extended_image.dart';
import 'package:booking_system_flutter/screens/products/product_component.dart';
import 'package:booking_system_flutter/screens/products/product_provider.dart';
import 'package:booking_system_flutter/screens/products/screen_loader.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:booking_system_flutter/screens/products/widgets/product_detail_header_component.dart';
import 'package:booking_system_flutter/screens/products/widgets/product_detail_provider_widget.dart';
import 'package:booking_system_flutter/screens/service/shimmer/service_detail_shimmer.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../model/product_detail_model.dart' as prod;

class ProductDetailsView extends StatefulWidget {
  final int productId;
  final int userId;

  ProductDetailsView({required this.productId, required this.userId});

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(transparentColor);
    callInit();
  }

  callInit() async {
    var dd = await context
        .read<ProductProvider>()
        .init(productId: widget.productId, userId: widget.userId);

    /// Initializing Tab Contrroller
    context.read<ProductProvider>().imagesController = TabController(
        length: dd?.productDetail?.photos?.length ?? 0, vsync: this);

    ///
  }

  Widget providerWidget({required prod.Provider data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lblAboutProvider,
            style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        ProductDetailProviderWidget(providerData: data).onTap(() async {
          await ProviderInfoScreen(providerId: data.id).launch(context);
          setStatusBarColor(Colors.transparent);
        }),
      ],
    ).paddingAll(16);
  }

  Widget relatedServiceWidget(
      {required List<prod.RelatedProducts> productList,
      required int productId}) {
    if (productList.isEmpty) return Offstage();

    productList.removeWhere((element) => element.id == productId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        if (productList.isNotEmpty)
          Text(language.lblRelatedProducts,
                  style: boldTextStyle(size: LABEL_TEXT_SIZE))
              .paddingSymmetric(horizontal: 16),
        if (productList.isNotEmpty)
          HorizontalList(
            itemCount: productList.length,
            padding: EdgeInsets.all(16),
            spacing: 8,
            runSpacing: 16,
            itemBuilder: (_, index) => ProductComponent(
                    productData: productList[index],
                    width: context.width() / 2 - 26)
                .paddingOnly(right: 8),
          ),
        16.height,
      ],
    );
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(transparentColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProductProvider controller = Provider.of<ProductProvider>(context);

    Size screenSize = MediaQuery.of(context).size;
    Widget buildBodyWidget(AsyncSnapshot<prod.ProductDetailModel> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return Stack(
          children: [
            AnimatedScrollView(
              padding: EdgeInsets.only(bottom: 120),
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              onSwipeRefresh: () async {
                appStore.setLoading(true);
                controller.init(
                    productId: widget.productId, userId: widget.userId);
                setState(() {});

                return await 2.seconds.delay;
              },
              children: [
                _buildProductImagesWidgets(snap.data!, controller),
                Visibility(
                  visible: snap.data!.productDetail!.description != "" &&
                      snap.data!.productDetail!.description != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductDetailHeaderComponent(
                        productDetail: snap.data!.productDetail!,
                        variantCode: controller.selectedOptionList.isNotEmpty &&
                                controller.selectedColor != ""
                            ? "${controller.selectedColor}-${controller.selectedOptionList.join('-')}"
                            : controller.selectedOptionList.isEmpty
                                ? "${controller.selectedColor}"
                                : controller.selectedColor == ""
                                    ? "${controller.selectedOptionList.join('-')}"
                                    : "",
                      ),
                      15.height,
                      _buildDivider(screenSize),
                      15.height,
                      Text(language.hintDescription,
                          style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      ReadMoreText(
                        snap.data!.productDetail!.description.validate(),
                        trimLines: 1,
                        style: primaryTextStyle(),
                      ),
                      // Html(
                      //   data: snap.data!.productDetail!.description.validate(),
                      //   style: {
                      //     "html": Style(
                      //       color: appStore.isDarkMode
                      //           ? Colors.white
                      //           : Colors
                      //               .black, // Set the text color of the entire HTML widget to red
                      //     ),
                      //   },
                      // ),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 16, bottom: 5),
                ),
                Column(
                  children: [
                    _buildColorOptions(snap.data!, screenSize, controller),
                    _buildVariantOptions(snap.data!, screenSize, controller),
                    _buildQtyOptions(
                        snap.data!,
                        screenSize,
                        controller.selectedOptionList.isNotEmpty &&
                                controller.selectedColor != ""
                            ? "${controller.selectedColor}-${controller.selectedOptionList.join('-')}"
                            : controller.selectedOptionList.isEmpty
                                ? "${controller.selectedColor}"
                                : controller.selectedColor == ""
                                    ? "${controller.selectedOptionList.join('-')}"
                                    : "",
                        controller),
                  ],
                ).paddingAll(16),
                providerWidget(data: snap.data!.productDetail!.provider!),
                relatedServiceWidget(
                    productList: snap.data!.relatedProducts.validate(),
                    productId: snap.data!.productDetail!.id.validate()),
              ],
            ),
            _buyNow(
                snap,
                context,
                controller.selectedOptionList.isNotEmpty &&
                        controller.selectedColor != ""
                    ? "${controller.selectedColor}-${controller.selectedOptionList.join('-')}"
                    : controller.selectedOptionList.isEmpty
                        ? "${controller.selectedColor}"
                        : controller.selectedColor == ""
                            ? "${controller.selectedOptionList.join('-')}"
                            : "",
                controller)
          ],
        );
      }
      return ServiceDetailShimmer();
    }

    return FutureBuilder<prod.ProductDetailModel>(
      initialData: listOfProductCachedData
          .firstWhere((element) => element?.$1 == widget.productId.validate(),
              orElse: () => null)
          ?.$2,
      future: controller.profuctDetail,
      builder: (context, snap) {
        return Scaffold(
          body: Stack(
            children: [
              buildBodyWidget(snap),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          ),
        );
      },
    );
  }

  Positioned _buyNow(AsyncSnapshot<prod.ProductDetailModel> snap,
      BuildContext context, String varienCode, ProductProvider controller) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: AppButton(
        onTap: () async {
          doIfLoggedIn(context, () async {
            if (controller.selectedQty != 0) {
              if (controller.selectedQty >= snap.data!.productDetail!.minQty!) {
// check same provider exist
                if (context.read<CartProvider>().cartData?.message?.data !=
                        null &&
                    context
                        .read<CartProvider>()
                        .cartData!
                        .message!
                        .data!
                        .isNotEmpty &&
                    snap.data?.productDetail?.provider?.id !=
                        context
                            .read<CartProvider>()
                            .cartData
                            ?.message
                            ?.data
                            ?.first
                            .ownerId) {
                  differentProviderDialog(snap, varienCode, controller);
                } else {
                  try {
                    Loaders.start(context);
                    var resp = await productAddToCart({
                      "id": snap.data!.productDetail?.id,
                      "variant":
                          snap.data!.productDetail?.choiceOptions?.isEmpty ??
                                  true
                              ? controller.selectedColor
                              : varienCode,
                      "quantity": controller.selectedQty
                    });
                    Loaders.stop(context);

                    if (resp['message']['status'] == true) {
                      Fluttertoast.showToast(msg: resp['message']['message']);
                      await context.read<CartProvider>().getCartList();
                      CartListScreen().launch(context);
                    } else {
                      Fluttertoast.showToast(msg: resp['message']['message']);
                    }
                  } catch (e) {
                    Loaders.stop(context);
                    Fluttertoast.showToast(msg: e.toString());
                  }
                }
              } else {
                Fluttertoast.showToast(
                    msg:
                        "${language.pleaseAddMin} ${snap.data!.productDetail!.minQty} ${snap.data!.productDetail!.unit}");
              }
            } else {
              Fluttertoast.showToast(msg: language.pleaseSelectQty);
            }
          });
        },
        color: context.primaryColor,
        child: Text(language.lblBuyNow, style: boldTextStyle(color: white)),
        width: context.width(),
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildProductImagesWidgets(
      prod.ProductDetailModel data, ProductProvider controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
            height: 300.0,
            child: Center(
              child: DefaultTabController(
                length: data.productDetail?.photos?.length ?? 0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    TabBarView(
                        controller: controller.imagesController,
                        children: List.generate(
                            data.productDetail?.photos?.length ?? 0,
                            (index) => InkWell(
                                  onTap: () {
                                    ExtendedImageWidget(
                                            currentPage: index,
                                            imageList:
                                                data.productDetail!.photos!)
                                        .launch(context);
                                  },
                                  child: CachedImageWidget(
                                    url: data.productDetail?.photos?[index]
                                            .path ??
                                        '',
                                    height: 300,
                                  ),
                                ))

                        // children: product.images.map(
                        //   (image) {
                        //     return Image.network(
                        //       image.imageURL,
                        //     );
                        //   },
                        // ).toList(),
                        ),
                    Positioned(
                      bottom: 10,
                      child: FittedBox(
                        child: Container(
                          alignment: FractionalOffset(0.5, 0.95),
                          child: TabPageSelector(
                            controller: controller.imagesController,
                            selectedColor: Colors.grey,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 16,
            child: Container(
              child: BackWidget(iconColor: context.iconColor),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.cardColor.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOptions(
      prod.ProductDetailModel data, screenSize, ProductProvider controller) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Visibility(
        visible: data.productDetail?.colors?.isNotEmpty ?? false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDivider(screenSize),
            SizedBox(height: 12.0),
            Text(
              'Color',
              style: TextStyle(color: appStore.isDarkMode ? whiteColor : black),
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.productDetail!.colors?.length,
                itemBuilder: (BuildContext context, int index) {
                  var color = data.productDetail!.colors?[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        controller.selectedQty = 0;
                        controller.selectedColor = color.name ?? '';
                        controller.changeImageIndex(
                            controller.selectedOptionList.isNotEmpty &&
                                    controller.selectedColor != ""
                                ? "${controller.selectedColor}-${controller.selectedOptionList.join('-')}"
                                : controller.selectedOptionList.isEmpty
                                    ? "${controller.selectedColor}"
                                    : controller.selectedColor == ""
                                        ? "${controller.selectedOptionList.join('-')}"
                                        : "",
                            data);
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: controller.selectedColor == color?.name
                              ? Colors.blue
                              : Colors
                                  .transparent, // Specify the border color here
                          width: 2.0, // Specify the border width here
                        ),
                      ),
                      margin: EdgeInsets.all(3),
                      color: Color(
                          int.parse(color!.code!.substring(1, 7), radix: 16) +
                              0xFF000000),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(5),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.0),
            _buildDivider(screenSize),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyOptions(prod.ProductDetailModel data, screenSize, variantCode,
      ProductProvider controller) {
    int varientQty = 0;

    if (data.productDetail?.choiceOptions?.isNotEmpty ?? false) {
      var matchingVariant = data.productDetail?.variants?.firstWhere(
        (variant) => variant.variant == variantCode,
      );

      if (matchingVariant != null) {
        varientQty = matchingVariant.qty ?? 0;
      } else {
        varientQty = 0;
      }
    } else {
      varientQty = data.productDetail?.currentStock ?? 0;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.lblQuantity,
            style: TextStyle(
                color: appStore.isDarkMode ? Colors.white : Colors.black),
          ),
          UIHelper.verticalSpaceSmall(),
          Row(children: [
            RoundCard(
              child: Container(
                decoration:
                    BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                height: 35,
                width: 35,
                child: IconButton(
                  icon: Icon(Icons.remove,
                      size: 20,
                      color: appStore.isDarkMode ? Colors.black : darkCyan),
                  onPressed: () {
                    controller.quantityDecrement();

                    // setState(() {
                    //   if (controller.selectedQty > 0) {
                    //     controller.selectedQty--;
                    //   }
                    // });
                  },
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              controller.selectedQty.toString(),
              style: TextStyle(
                  fontSize: 20.0,
                  color: appStore.isDarkMode ? Colors.white : Colors.black),
            ),
            SizedBox(width: 16.0),
            RoundCard(
              child: Container(
                decoration:
                    BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                height: 35,
                width: 35,
                child: IconButton(
                  icon: Icon(Icons.add,
                      size: 20,
                      color: appStore.isDarkMode ? Colors.black : darkCyan),
                  onPressed: () {
                    controller.quantityIncrement(varientQty);
// setState(() {
                    //   if (controller.selectedQty < varientQty) {
                    //     controller.selectedQty++;
                    //   }
                    // });
                  },
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              varientQty == 0
                  ? language.lblOutOfStock
                  : '${language.lblTotalStock}: $varientQty',
              style: TextStyle(
                  fontSize: 16.0,
                  color: varientQty == 0
                      ? redColor
                      : appStore.isDarkMode
                          ? Colors.white
                          : Colors.black),
            ),
          ]),
          SizedBox(height: 12.0),
          _buildDivider(screenSize),
        ],
      ),
    );
  }

  Widget _buildVariantOptions(
      prod.ProductDetailModel data, screenSize, ProductProvider controller) {
    return Visibility(
      visible: data.productDetail?.choiceOptions?.isNotEmpty ?? false,
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.productDetail?.choiceOptions?.length,
        itemBuilder: (BuildContext context, int index) {
          var indexData = data.productDetail?.choiceOptions?[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                indexData?.title ?? '',
                style:
                    TextStyle(color: appStore.isDarkMode ? whiteColor : black),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: indexData?.options?.length,
                  itemBuilder: (BuildContext context, int index2) {
                    var optionData = indexData?.options?[index2];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ChoiceChip(
                          label: Text(optionData ?? ''),
                          selected:
                              controller.selectedOptionList[index] == optionData
                                  ? true
                                  : false,
                          onSelected: (ss) {
                            controller.selectedQty = 0;
                            if (ss) {
                              controller.selectedOptionList[index] = optionData;
                              controller.changeImageIndex(
                                  controller.selectedOptionList.isNotEmpty &&
                                          controller.selectedColor != ""
                                      ? "${controller.selectedColor}-${controller.selectedOptionList.join('-')}"
                                      : controller.selectedOptionList.isEmpty
                                          ? "${controller.selectedColor}"
                                          : controller.selectedColor == ""
                                              ? "${controller.selectedOptionList.join('-')}"
                                              : "",
                                  data);
                            }

                            setState(() {});
                          }),
                    ).paddingOnly(bottom: 5);
                  },
                ),
              ),
              SizedBox(height: 12.0),
              _buildDivider(screenSize),
              SizedBox(height: 12.0),
            ],
          );
        },
      ),
    );
  }

  _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  differentProviderDialog(snap, variantCode, ProductProvider controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        CartProvider cartProvider = Provider.of<CartProvider>(context);
        return AlertDialog(
          title: Text(language.removeCartTitle, style: boldTextStyle(size: 18)),
          content: Text(language.removeCartContent,
              style: primaryTextStyle(size: 16)),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  finish(context);
                  Loaders.start(navigatorKey.currentContext!);
                  await deleteAllCartList();

                  var resp = await productAddToCart({
                    "id": snap.data!.productDetail?.id,
                    "variant": variantCode,
                    // snap.data!.productDetail?.choiceOptions?.isEmpty ?? true
                    //     ? ""
                    //     : variantCode,
                    "quantity": controller.selectedQty
                  });

                  Loaders.stop(navigatorKey.currentContext!);
                  if (resp['message']['status'] == true) {
                    Fluttertoast.showToast(msg: resp['message']['message']);
                    // context.read<CartProvider>().cartData = CartListModel();
                    await cartProvider.getCartList();
                    CartListScreen().launch(navigatorKey.currentContext!);
                  } else {
                    Fluttertoast.showToast(msg: resp['message']['message']);
                  }
                } catch (e) {
                  Loaders.stop(navigatorKey.currentContext!);
                  toast(e.toString());
                }
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
}

class RoundCard extends StatelessWidget {
  final Widget child;

  RoundCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(500.0),
      ),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: child,
      ),
    );
  }
}
