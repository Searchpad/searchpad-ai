import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/dashboard/component/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/providers_model.dart';
import '../../booking/provider_info_screen.dart';
import '../../providers/provider_list_screen.dart';

class ProviderComponent extends StatefulWidget {
  final List<Data>? providerList;

  ProviderComponent({this.providerList});

  @override
  ProviderComponentState createState() => ProviderComponentState();
}

class ProviderComponentState extends State<ProviderComponent> {
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
    if (widget.providerList.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.provider,
          list: widget.providerList!,
          onTap: () {
            ProviderListScreen().launch(context).then((value) {
              setStatusBarColor(Colors.transparent);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        HorizontalList(
          itemCount: widget.providerList.validate().length,
          padding: EdgeInsets.only(left: 16, right: 16),
          runSpacing: 8,
          spacing: 12,
          itemBuilder: (_, i) {
            Data data = widget.providerList![i];
            return GestureDetector(
              onTap: () async {
                if (data.id != appStore.userId.validate()) {
                  await ProviderInfoScreen(providerId: data.id.validate())
                      .launch(context);
                  setStatusBarColor(Colors.transparent);
                }

                // ViewAllProductScreen(
                //   providerId: data.id,
                // ).launch(context);
              },
              child: ProviderWid(data: data),
            );
          },
        ),
      ],
    );
  }
}
