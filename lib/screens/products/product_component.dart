import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/screens/products/product_details_view.dart';
import 'package:booking_system_flutter/screens/products/product_thumb_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class ProductComponent extends StatefulWidget {
  final productData;
  final BookingPackage? selectedPackage;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final double? height;
  final double? imageHeight;

  ProductComponent(
      {this.productData,
      this.width,
      this.height,
      this.imageHeight,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate,
      this.selectedPackage});

  @override
  ProductComponentState createState() => ProductComponentState();
}

class ProductComponentState extends State<ProductComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        // ProductDetailPage(
        //   productId: widget.productData.id.toString(),
        // ).launch(context);
        ProductDetailsView(
          productId: widget.productData.id,
          userId: appStore.userId ?? 0,
        ).launch(context);
        // ServiceDetailScreen(
        //         serviceId: widget.isFavouriteService
        //             ? widget.productData!.serviceId.validate().toInt()
        //             : widget.serviceData!.id.validate())
        //     .launch(context)
        //     .then((value) {
        //   setStatusBarColor(context.primaryColor);
        // });
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
        ),
        width: widget.width,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.imageHeight ?? 205,
              width: context.width(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CachedImageWidget(
                    url: widget.isFavouriteService
                        ? widget.productData!.productThumbnailImage.isNotEmpty
                            ? widget.productData!.productGalleryImages!.first
                            : ''
                        : widget.productData!.productGalleryImages.isNotEmpty
                            ? widget.productData!.productGalleryImages!.first
                            : '',
                    fit: BoxFit.cover,
                    height: 180,
                    width: context.width(),
                    circle: false,
                  ).cornerRadiusWithClipRRectOnly(
                      topRight: defaultRadius.toInt(),
                      topLeft: defaultRadius.toInt()),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      constraints:
                          BoxConstraints(maxWidth: context.width() * 0.3),
                      decoration: boxDecorationWithShadow(
                        backgroundColor: context.cardColor.withOpacity(0.9),
                        borderRadius: radius(24),
                      ),
                      child: Marquee(
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          "${widget.productData!.category.name.isNotEmpty ? widget.productData!.category.name : widget.productData!.category.name}"
                              .toUpperCase(),
                          style: boldTextStyle(
                              color: appStore.isDarkMode ? white : primaryColor,
                              size: 12),
                        ).paddingSymmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: boxDecorationWithShadow(
                        backgroundColor: primaryColor,
                        borderRadius: radius(24),
                        border: Border.all(color: context.cardColor, width: 2),
                      ),
                      child: ProductThumbPriceWidget(
                          isDiscountedPrice:
                              widget.productData?.hasDiscount ?? false,
                          price: widget.productData!.mainPrice.toString(),
                          originalPrice:
                              widget.productData!.strokedPrice.toString(),
                          discount: widget.productData!.discount.toString(),
                          isHourlyService: false,
                          color: Colors.white,
                          hourlyTextColor: Colors.white,
                          size: 14,
                          isFreeService: false),
                    ),
                  ),
                  Visibility(
                    visible:
                        widget.productData?.hasDiscount == true ? true : false,
                    child: Positioned(
                        bottom: 12,
                        left: 8,
                        child: DiscountBatch(
                          discountPercent: widget.productData?.discount ?? '',
                        )),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(widget.productData!.name.toString(),
                          style: boldTextStyle())
                      .paddingSymmetric(horizontal: 16),
                ),
                //    Row(
                //   children: [
                //     ImageBorder(
                //         src: widget.serviceData!.providerImage.validate(),
                //         height: 30),
                //     8.width,
                //     if (widget.serviceData!.providerName.validate().isNotEmpty)
                //       Text(
                //         widget.serviceData!.providerName.validate(),
                //         style: secondaryTextStyle(
                //             size: 12,
                //             color: appStore.isDarkMode
                //                 ? Colors.white
                //                 : appTextSecondaryColor),
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //       ).expand()
                //   ],
                // ).onTap(() async {
                //   if (widget.serviceData!.providerId !=
                //       appStore.userId.validate()) {
                //     await ProviderInfoScreen(
                //             providerId:
                //                 widget.serviceData!.providerId.validate())
                //         .launch(context);
                //     setStatusBarColor(Colors.transparent);
                //   } else {
                //     //
                //   }
                // }).paddingSymmetric(horizontal: 16),
                16.height,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
