import 'package:booking_system_flutter/component/image_border_component.dart';

import 'package:booking_system_flutter/model/product_detail_model.dart';

import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductDetailProviderWidget extends StatefulWidget {
  final Provider providerData;

  ProductDetailProviderWidget({required this.providerData});

  @override
  ProductDetailProviderWidgetState createState() =>
      ProductDetailProviderWidgetState();
}

class ProductDetailProviderWidgetState
    extends State<ProductDetailProviderWidget> {
  Provider userData = Provider();

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userData = widget.providerData;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageBorder(
                  src: widget.providerData.profileImage.validate(), height: 50),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${widget.providerData.firstName.validate()} ${widget.providerData.lastName.validate()}",
                              style: boldTextStyle())
                          .flexible(),
                      16.width,
                      ic_info.iconImage(size: 20),
                    ],
                  ),
                  4.height,
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}
