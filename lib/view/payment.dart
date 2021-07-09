import 'dart:async';
import 'package:bunplanet/view/paymentlist.dart';
import 'package:bunplanet/view/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bunplanet/view/trackingscreen.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double total;
  final Payment payment;

  const PaymentScreen({Key key, this.user, this.total, this.payment})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TrackingScreen(
                        user: widget.user, payment: widget.payment)));
          },
        ),
        title: Text('Payment'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: WebView(
                  initialUrl:
                      'https://crimsonwebs.com/s271738/bunplanet/php/billgenerate.php?email=' +
                          widget.user.email +
                          '&mobile=' +
                          widget.user.phonenum +
                          '&name=' +
                          widget.user.name +
                          '&address=' +
                          widget.payment.useraddress +
                          '&pickuptime=' +
                          widget.payment.time +
                          '&amount=' +
                          widget.total.toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
