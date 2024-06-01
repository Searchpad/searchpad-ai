import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/maintenance_mode_screen.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'walk_through_screen.dart';
import 'package:booking_system_flutter/screens/auth/pre_sign_in_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _controller!.repeat(reverse: true);
    Future.delayed(Duration(milliseconds: 2300), () {
      init();
    });
    // init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      setStatusBarColor(Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness:
              appStore.isDarkMode ? Brightness.light : Brightness.dark);

      await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE,
          defaultValue: DEFAULT_LANGUAGE));

      int themeModeIndex =
          getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
      if (themeModeIndex == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(
            MediaQuery.of(context).platformBrightness == Brightness.dark);
      }

      await 500.milliseconds.delay;

      if (getBoolAsync(IN_MAINTENANCE_MODE)) {
        MaintenanceModeScreen().launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
          PreSigninScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else {
          PreSigninScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
        'assets/images/logo.png',
      ),
      ),
      // backgroundColor: primaryColor,
      // body: Center(
      //   child: AnimatedBuilder(
      //     animation: _controller!,
      //     builder: (context, child) {
      //       return Transform.scale(
      //         scale: _animation!.value,
      //         child: Image.asset(appLogo), // Replace with your image asset
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
