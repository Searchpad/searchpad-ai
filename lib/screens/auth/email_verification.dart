import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:booking_system_flutter/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key, required this.response});
  final String response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: BackWidget(iconColor: context.iconColor),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image.asset('assets/images/email_verifcation.png')
                  .paddingAll(30)),
          Text(
            response,
            style: primaryTextStyle(),
            textAlign: TextAlign.center,
          ),
          UIHelper.verticalSpaceLarge(),
          AppButton(
            child: Text(language.lblBack),
            color: primaryColor,
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ).paddingAll(30),
    );
  }
}
