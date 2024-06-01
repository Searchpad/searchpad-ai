import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/base_scaffold_body.dart';
import 'package:booking_system_flutter/component/custom_button.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_up_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/auth/auth_user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class PreSigninScreen extends StatefulWidget {
  final bool? isFromDashboard;
  final bool? isFromServiceBooking;
  final bool returnExpected;
  final bool isRegeneratingToken;

  PreSigninScreen(
      {this.isFromDashboard,
      this.isFromServiceBooking,
      this.returnExpected = false,
      this.isRegeneratingToken = false});
  @override
  _PreSigninScreenState createState() => _PreSigninScreenState();
}

class _PreSigninScreenState extends State<PreSigninScreen> {
  bool _isSwitchon = true;
  void googleSignIn() async {
    appStore.setLoading(true);

    await authService.signInWithGoogle(context).then((value) async {
      appStore.setLoading(false);
      saveDataToPreference(context,
          userData: value!.userData!,
          isSocialLogin: true, onRedirectionClick: () {
        onLoginSuccessRedirection();
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void onLoginSuccessRedirection() {
    TextInput.finishAutofillContext();
    if (widget.isFromServiceBooking.validate() ||
        widget.isFromDashboard.validate() ||
        widget.returnExpected.validate()) {
      if (widget.isFromDashboard.validate()) {
        setStatusBarColor(context.primaryColor);
      }

      finish(context, true);
    } else {
      DashboardScreen().launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }

    appStore.setLoading(false);
  }

  void appleSign() async {
    appStore.setLoading(true);

    await authService.appleSignIn().then((value) async {
      appStore.setLoading(false);

      onLoginSuccessRedirection();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop()
            ? BackWidget(iconColor: context.iconColor)
            : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
        actions: [
          Switch(
              value: _isSwitchon,
              onChanged: ((value) {
                setState(() {
                  _isSwitchon = value;
                  _isSwitchon == true
                      ? appStore.setDarkMode(false)
                      : appStore.setDarkMode(true);
                });
              }),
              activeColor: Color(0xFF6949FF),
              inactiveTrackColor: Color(0xFF0C0C0C),
              )
        ],
      ),
      body: Body(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 120,
                height: 120,
              ),
              16.height,
              Text(
                "Searchpad",
                style: boldTextStyle(size: 30),
              ),
              10.height,
              Text(
                "Welcome! Let's dive in into your account!",
                style: primaryTextStyle(size: 15),
              ),
              70.height,
              InkWell(
                onTap: () {
                  // googleSignIn();
                },
                child: CustomButton(
                  "Continue with Google",
                  0.9,
                  icon: ic_google,
                  index: 2,
                ),
              ),
              15.height,
              InkWell(
                onTap: () {
                  // appleSign();
                },
                child: CustomButton(
                  "Continue with Apple",
                  0.9,
                  icon: ic_apple,
                ),
              ),
              50.height,
              InkWell(
                onTap: () {
                  SignInScreen().launch(context);
                },
                child: CustomButton(
                  "Sign in",
                  0.9,
                  color: thirdColor,
                  index: 3,
                ),
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(language.doNotHaveAccount,
                      style: secondaryTextStyle(
                          color: textPrimaryColorGlobal, size: 14)),
                  TextButton(
                    onPressed: () {
                      hideKeyboard(context);
                      SignUpScreen().launch(context);
                    },
                    child: Text(
                      language.signUp,
                      style: boldTextStyle(
                        color: thirdColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
