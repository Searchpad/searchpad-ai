import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Loaders {
  static bool? _isOpen;
  static void start(context) {
    _isOpen = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
                height: 50,
                width: 1,
                margin: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    UIHelper.horizontalSpaceLarge(),
                    Text('Loading', style: primaryTextStyle())
                  ],
                )));
      },
    ).then((_) => _isOpen = false);
  }

  static void stop(context) {
    if (_isOpen == true) {
      Navigator.pop(context);
    }
  }
}
