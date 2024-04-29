import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductThumbPriceWidget extends StatelessWidget {
  final String price;
  final String originalPrice;
  final String discount;
  final double? size;
  final Color? color;
  final Color? hourlyTextColor;
  final bool isBoldText;
  final bool isLineThroughEnabled;
  final bool isDiscountedPrice;
  final bool isHourlyService;
  final bool isFreeService;
  final int? decimalPoint;

  ProductThumbPriceWidget({
    required this.price,
    this.size = 16.0,
    this.color,
    this.hourlyTextColor,
    this.isLineThroughEnabled = false,
    this.isBoldText = true,
    this.isDiscountedPrice = false,
    this.isHourlyService = false,
    this.isFreeService = false,
    this.decimalPoint,
    required this.originalPrice,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle({int? aSize}) {
      return isBoldText
          ? boldTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
            )
          : secondaryTextStyle(
              size: aSize ?? size!.toInt(),
              color: color != null ? color : primaryColor,
            );
    }

    TextStyle _lineThroughStyle() {
      return TextStyle(
        fontSize: 12,
        color: color != null ? color : primaryColor,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.lineThrough,
        decorationColor: Colors.white, // Change the color here
        decorationThickness: 1.0,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Visibility(
        //   visible: isDiscountedPrice,
        //   child: FittedBox(
        //     child: Row(
        //       children: [
        //         Text(
        //           originalPrice,
        //           style: _lineThroughStyle(),
        //         ),
        //         SizedBox(width: 5),
        //       ],
        //     ),
        //   ),
        // ),
        Row(
          children: [
            Text(
              price,
              style: _textStyle(),
            ),
          ],
        ),
      ],
    );
  }
}

class DiscountBatch extends StatelessWidget {
  const DiscountBatch({super.key, required this.discountPercent});
  final String discountPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: 70,
        padding: EdgeInsets.all(4),
        decoration:
            BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            "$discountPercent Off",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ));
  }
}
