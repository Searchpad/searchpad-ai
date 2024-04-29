import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/back_widget.dart';
import '../../utils/constant.dart';

class OrderPlacedScreen extends StatefulWidget {
  final bool paymentSuccessful;
  final bool isCOD;

  OrderPlacedScreen({required this.paymentSuccessful, required this.isCOD});

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  int countdownValue = 5;

  void startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        countdownValue--;
        if (countdownValue > 0) {
          startCountdown();
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/first', (route) => false);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        showBack: false,
        backWidget: BackWidget(iconColor: white),
        color: context.primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: context.primaryColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        titleWidget: Text(
          language.lblOrderSuccess,
          style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, '/first', (route) => false);
          return true;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedCheckIcon(isPaymentFailed: widget.paymentSuccessful),
              UIHelper.verticalSpaceMedium(),
              widget.paymentSuccessful && widget.isCOD
                  ? Text(
                      language.lblOrderSuccess,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: appStore.isDarkMode ? white : black),
                    )
                  : widget.paymentSuccessful && !widget.isCOD
                      ? Text(
                          language.paymentSuccess,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: appStore.isDarkMode ? white : black),
                        )
                      : Text(
                          language.paymentFailed,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: appStore.isDarkMode ? white : black),
                        ),
              SizedBox(height: 10.0),
              Text(
                widget.paymentSuccessful
                    ? language.lblOrderPlacedSuccess
                    : language.orderPlacedAsCod,
                style: TextStyle(
                    fontSize: 18.0, color: appStore.isDarkMode ? white : black),
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/first', (route) => false);
                  },
                  child: Text(language.redirectToHome + "...$countdownValue"))
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCheckIcon extends StatefulWidget {
  final bool isPaymentFailed;

  const AnimatedCheckIcon({super.key, required this.isPaymentFailed});

  @override
  _AnimatedCheckIconState createState() => _AnimatedCheckIconState();
}

class _AnimatedCheckIconState extends State<AnimatedCheckIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Interval(0.0, 0.5),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Interval(0.5, 1.0),
    ));

    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation?.value ?? 0,
          child: Transform.scale(
            scale: _scaleAnimation?.value,
            child: !widget.isPaymentFailed
                ? Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 100.0,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
          ),
        );
      },
    );
  }
}
