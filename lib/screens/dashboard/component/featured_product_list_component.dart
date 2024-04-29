import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/product_list_model.dart';
import 'package:booking_system_flutter/screens/products/product_component.dart';
import 'package:booking_system_flutter/screens/products/view_all_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../component/empty_error_state_widget.dart';

class FeaturedProductListComponent extends StatelessWidget {
  final List<Data> productList;

  FeaturedProductListComponent({required this.productList});

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: BoxDecoration(
        color: appStore.isDarkMode
            ? context.cardColor
            : context.primaryColor.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(
            label: language.lblFeatured + " " + language.products,
            list: productList,
            onTap: () {
              // ViewAllServiceScreen(isFeatured: "1").launch(context);
              ViewAllProductScreen(isFeatured: "1").launch(context);
            },
          ).paddingSymmetric(horizontal: 16),
          if (productList.isNotEmpty)
            HorizontalList(
              itemCount: productList.length,
              spacing: 16,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) => ProductComponent(
                  productData: productList[index],
                  width: 170,
                  // height: 150,
                  // imageHeight: 100,
                  isBorderEnabled: true),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: NoDataWidget(
                title: language.lblNoProductsFound,
                imageWidget: EmptyStateWidget(),
              ),
            ).center(),
        ],
      ),
    );
  }
}
