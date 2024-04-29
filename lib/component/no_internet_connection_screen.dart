import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            appStore.isDarkMode
                ? 'assets/lottie/no_internet.json'
                : 'assets/lottie/no_internet.json',
            height: 300,
          ),
          Text(language.internetNotAvailable,
                  style: boldTextStyle(size: 18), textAlign: TextAlign.center)
              .center(),
          8.height,
          Text(language.lblCatchUpAfterAWhile,
                  style: secondaryTextStyle(), textAlign: TextAlign.center)
              .center(),
          16.height,
          TextButton(
            onPressed: () async {
              // await setupFirebaseRemoteConfig();
              RestartAppWidget.init(context);
            },
            child: Text(language.lblRecheck),
          ),
        ],
      ),
    );
  }
}
