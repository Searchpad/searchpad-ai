import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/gallery/gallery_component.dart';
import 'package:booking_system_flutter/screens/gallery/gallery_screen.dart';
import 'package:booking_system_flutter/screens/products/product_thumb_price_widget.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/product_detail_model.dart' as prod;

class ProductDetailHeaderComponent extends StatefulWidget {
  final prod.ProductDetail productDetail;
  final String variantCode;

  const ProductDetailHeaderComponent(
      {required this.productDetail, Key? key, required this.variantCode})
      : super(key: key);

  @override
  State<ProductDetailHeaderComponent> createState() =>
      _ProductDetailHeaderComponentState();
}

class _ProductDetailHeaderComponentState
    extends State<ProductDetailHeaderComponent> {
  List<String>? getPhotoList(List<prod.Photos> pics) {
    List<String>? photo = [];
    if (pics.isNotEmpty) {
      for (var element in pics) {
        photo.add(element.path ?? '');
      }
    }
    return photo;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPriceWidget(),
        4.width,
        if (widget.productDetail.discount.validate() != "0" ||
            widget.productDetail.discount.validate() != "")
          Text(
            '(${widget.productDetail.discount.validate()} ${language.lblOff})',
            style: boldTextStyle(color: Colors.green),
          ),
      ],
    );

    // SizedBox(
    //   height: 475,
    //   width: context.width(),
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       if (widget.productDetail.photos.validate().isNotEmpty)
    //         SizedBox(
    //           height: 400,
    //           width: context.width(),
    //           child: CachedImageWidget(
    //             url: widget.productDetail.photos?.first.path ?? '',
    //             fit: BoxFit.cover,
    //             height: 400,
    //           ),
    //         ),
    //       Positioned(
    //         top: context.statusBarHeight + 8,
    //         left: 16,
    //         child: Container(
    //           child: BackWidget(iconColor: context.iconColor),
    //           decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: context.cardColor.withOpacity(0.7)),
    //         ),
    //       ),
    //       // Positioned(
    //       //   top: context.statusBarHeight + 8,
    //       //   child: Container(
    //       //     padding: EdgeInsets.all(10),
    //       //     margin: EdgeInsets.only(right: 8),
    //       //     decoration: boxDecorationWithShadow(
    //       //         boxShape: BoxShape.circle,
    //       //         backgroundColor: context.cardColor),
    //       //     child: widget.productDetail.isFavourite == 1
    //       //         ? ic_fill_heart.iconImage(color: favouriteColor, size: 24)
    //       //         : ic_heart.iconImage(color: unFavouriteColor, size: 24),
    //       //   ).onTap(() async {
    //       //     if (appStore.isLoggedIn) {
    //       //       onTapFavourite();
    //       //     } else {
    //       //       push(SignInScreen(returnExpected: true)).then((value) {
    //       //         setStatusBarColor(transparentColor,
    //       //             delayInMilliSeconds: 1000);
    //       //         if (value) {
    //       //           onTapFavourite();
    //       //         }
    //       //       });
    //       //     }
    //       //   },
    //       //       highlightColor: Colors.transparent,
    //       //       splashColor: Colors.transparent,
    //       //       hoverColor: Colors.transparent),
    //       //   right: 8,
    //       // ),
    //       Positioned(
    //         bottom: 0,
    //         left: 16,
    //         right: 16,
    //         child: Column(
    //           children: [
    //             Row(
    //               children: [
    //                 Wrap(
    //                   spacing: 16,
    //                   runSpacing: 16,
    //                   children: List.generate(
    //                     widget.productDetail.photos!.take(2).length,
    //                     (i) => Container(
    //                       decoration: BoxDecoration(
    //                           border: Border.all(color: white, width: 2),
    //                           borderRadius: radius()),
    //                       child: GalleryComponent(
    //                           images:
    //                               getPhotoList(widget.productDetail.photos!) ??
    //                                   [],
    //                           index: i,
    //                           padding: 32,
    //                           height: 60,
    //                           width: 60),
    //                     ),
    //                   ),
    //                 ),
    //                 16.width,
    //                 if (widget.productDetail.photos!.length > 2)
    //                   Blur(
    //                     borderRadius: radius(),
    //                     padding: EdgeInsets.zero,
    //                     child: Container(
    //                       height: 60,
    //                       width: 60,
    //                       decoration: BoxDecoration(
    //                         border: Border.all(color: white, width: 2),
    //                         borderRadius: radius(),
    //                       ),
    //                       alignment: Alignment.center,
    //                       child: Text(
    //                           '+'
    //                           '${widget.productDetail.photos!.length - 2}',
    //                           style: boldTextStyle(color: white)),
    //                     ),
    //                   ).onTap(() {
    //                     GalleryScreen(
    //                       serviceName: widget.productDetail.name.validate(),
    //                       attachments:
    //                           getPhotoList(widget.productDetail.photos!)
    //                               .validate(),
    //                     ).launch(context);
    //                   }),
    //               ],
    //             ),
    //             16.height,
    //             Container(
    //               width: context.width(),
    //               padding: EdgeInsets.all(16),
    //               decoration: boxDecorationDefault(
    //                 color: context.scaffoldBackgroundColor,
    //                 border: Border.all(color: context.dividerColor),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   if (widget.productDetail.subCategory!.name
    //                       .validate()
    //                       .isNotEmpty)
    //                     Marquee(
    //                       child: Row(
    //                         children: [
    //                           Text('${widget.productDetail.category!.name}',
    //                               style: boldTextStyle(
    //                                   color: textSecondaryColorGlobal,
    //                                   size: 12)),
    //                           Text('  >  ',
    //                               style: boldTextStyle(
    //                                   color: textSecondaryColorGlobal)),
    //                           Text(
    //                               '${widget.productDetail.subCategory?.name ?? ''}',
    //                               style: boldTextStyle(
    //                                   color: primaryColor, size: 12)),
    //                         ],
    //                       ),
    //                     )
    //                   else
    //                     Text('${widget.productDetail.category?.name ?? ''}',
    //                         style:
    //                             boldTextStyle(size: 14, color: primaryColor)),
    //                   8.height,
    //                   Marquee(
    //                     child: Text('${widget.productDetail.name.validate()}',
    //                         style: boldTextStyle(size: 18)),
    //                     directionMarguee: DirectionMarguee.oneDirection,
    //                   ),
    //                   8.height,
    //                   Row(
    //                     children: [
    //                       _buildPriceWidget(),
    //                       4.width,
    //                       if (widget.productDetail.discount.validate() != "0" ||
    //                           widget.productDetail.discount.validate() != "")
    //                         Text(
    //                           '(${widget.productDetail.discount.validate()} ${language.lblOff})',
    //                           style: boldTextStyle(color: Colors.green),
    //                         ),
    //                     ],
    //                   ),
    //                   4.height,
    //                   // TextIcon(
    //                   //   edgeInsets:
    //                   //       EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    //                   //   text: '${language.duration}',
    //                   //   textStyle: secondaryTextStyle(size: 14),
    //                   //   expandedText: true,
    //                   //   suffix: Text(
    //                   //     "${widget.productDetail.duration.validate()} ${language.lblHour}",
    //                   //     style: boldTextStyle(color: primaryColor),
    //                   //   ),
    //                   // ),
    //                   // TextIcon(
    //                   //   text: '${language.lblRating}',
    //                   //   textStyle: secondaryTextStyle(size: 14),
    //                   //   edgeInsets: EdgeInsets.symmetric(vertical: 4),
    //                   //   expandedText: true,
    //                   //   suffix: Row(
    //                   //     children: [
    //                   //       Image.asset(ic_star_fill,
    //                   //           height: 18,
    //                   //           color: getRatingBarColor(widget
    //                   //               .productDetail.totalRating
    //                   //               .validate()
    //                   //               .toInt())),
    //                   //       4.width,
    //                   //       Text(
    //                   //           "${widget.productDetail.totalRating.validate().toStringAsFixed(1)}",
    //                   //           style: boldTextStyle()),
    //                   //     ],
    //                   //   ),
    //                   // ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  ProductThumbPriceWidget _buildPriceWidget() {
    var price = "";
    var stockedPrice = "";

    if (widget.productDetail.variants?.isNotEmpty ?? false) {
      var matchingVariant = widget.productDetail.variants?.where(
        (variant) => variant.variant == widget.variantCode,
      );

      if (matchingVariant?.isNotEmpty ?? false) {
        // You can iterate through all matching variants here
        matchingVariant?.forEach((variant) {
          price = variant.mainPrice ?? "";
          stockedPrice = variant.strokedPrice ?? "";
        });
      } else {
        price = "";
        stockedPrice = "";
      }

      // if (matchingVariant != null) {
      //   price = matchingVariant.mainPrice ?? "";
      //   stockedPrice = matchingVariant.strokedPrice ?? "";
      // } else {
      //   price = "";
      //   stockedPrice = "";
      // }
    } else {
      price = widget.productDetail.mainPrice.toString();
      stockedPrice = widget.productDetail.strokedPrice ?? '';
    }

    return ProductThumbPriceWidget(
      price: price.validate(),
      originalPrice: stockedPrice.validate(),
      discount: widget.productDetail.discount.validate(),
      // isHourlyService:
      //     widget.productDetail.isHourlyService,
      // hourlyTextColor: textSecondaryColorGlobal,
      // isFreeService:
      //     widget.productDetail.type.validate() ==
      //         SERVICE_TYPE_FREE,
    );
  }
}
