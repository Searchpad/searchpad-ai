import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/back_widget.dart';
import '../../utils/constant.dart';

class PaymentStatusScreen extends StatefulWidget {
  final bool paymentSuccessful;
  final dynamic Function(Map<String, dynamic>)? callBack;
  final String? txnId;

  PaymentStatusScreen(
      {required this.paymentSuccessful, this.callBack, this.txnId});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  callFunc() {
    Future.delayed(Duration(seconds: 4), () {
      widget.callBack?.call({
        'transaction_id': widget.txnId,
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.paymentSuccessful) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        backWidget: BackWidget(iconColor: white),
        color: context.primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: context.primaryColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        titleWidget: Text(
          language.paymentStatus,
          style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedCheckIcon(isPaymentSuccessful: widget.paymentSuccessful),
            Text(
              widget.paymentSuccessful
                  ? language.paymentSuccess
                  : language.paymentFailed,
              style: TextStyle(
                  fontSize: 20.0,
                  color: appStore.isDarkMode ? whiteColor : blackColor),
            ),
            SizedBox(height: 20.0),
            Text(
              widget.paymentSuccessful
                  ? language.yourPaymentHasBeenMadeSuccessfully
                  : language.yourPaymentFailedPleaseTryAgain,
              style: TextStyle(
                  fontSize: 18.0,
                  color: appStore.isDarkMode ? whiteColor : blackColor),
            ),
            Visibility(
              replacement: Text('You are redirecting....'),
              visible: !widget.paymentSuccessful,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(language.pleaseTryAgain)),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCheckIcon extends StatefulWidget {
  final bool isPaymentSuccessful;

  const AnimatedCheckIcon({super.key, required this.isPaymentSuccessful});

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
            child: widget.isPaymentSuccessful == false
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
