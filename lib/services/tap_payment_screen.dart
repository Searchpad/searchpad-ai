import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/services/payment_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main.dart';
import '../network/network_utils.dart';

class TapPayScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;
  final int bookingId;
  const TapPayScreen({
    Key? key,
    required this.onComplete,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<TapPayScreen> createState() => _TapPayScreenState();
}

class _TapPayScreenState extends State<TapPayScreen> {
  late WebViewController paymentController;

  //StripPayment
  initPayment() {
    String payUrl =
        "https://admin.munasbat.app/api/pay-with-tap-booking?booking_id=${widget.bookingId}&user_id=${appStore.userId}";
    // "https://munasbat.thtbh.com/api/pay-with-tap-booking?booking_id=${widget.bookingId}&user_id=${appStore.userId}";
    paymentController = WebViewController();
    paymentController
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      );
    // paymentController.addJavaScriptChannel(
    //   'Print',
    //   onMessageReceived: (JavaScriptMessage message) {
    //     print(message.message);
    //   },
    // );

    paymentController.loadRequest(Uri.parse(
      payUrl,
    ));
    paymentController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        log('Start: $url');
      },
      onPageFinished: (url) async {
        if (url.contains('api/tap-result')) {
          //   var responseData =
          //       await paymentController.runJavaScriptReturningResult('''
          //   var responseData = await fetch('/api/payment/status').then(response => response.json());
          //   return responseData;
          // ''');

          Uri uri = Uri.parse(url);

          // Extracting tap_id from the query parameters
          String tapId = uri.queryParameters['tap_id'] ?? '';

          //   print(responseData);
          try {
            var res = await checkServicePaymentStatus({"tap_id": tapId});
            Navigator.pop(context);
            if (res['message']['status'] == true) {
              // widget.onComplete.call({
              //   'transaction_id': res['message']['txn_id'],
              // });

              return PaymentStatusScreen(
                paymentSuccessful: true,
                callBack: widget.onComplete.call({
                  'transaction_id': res['message']['txn_id'],
                }),
                txnId: res['message']['txn_id'],
              ).launch(context);
            } else {
              return PaymentStatusScreen(
                paymentSuccessful: false,
              ).launch(context);
            }
          } catch (e) {
            PaymentStatusScreen(
              paymentSuccessful: false,
            ).launch(context);
          }
        }

        log('End: $url');
        // if (url.contains('https://sadadqa.com/invoicedetail')) getHtmlBody(url);
      },
      onProgress: (progress) {
        //
      },
      onNavigationRequest: (request) {
        return NavigationDecision.navigate;
      },
    ));

    log('URL: $payUrl');
  }

  @override
  void initState() {
    initPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: paymentController),
    );
  }
}
