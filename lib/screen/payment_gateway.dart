import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import '../model/activity_model.dart';
import '../model/session_model.dart';
import '../provider/rest.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentGateway extends StatefulWidget {
  final Record recordActivity;
  final DateTime selectDate;
  final Session? currentSelected;
  final List<Map<String, String?>>? jsons;

  const PaymentGateway({
    Key? key,
    required this.recordActivity,
    required this.selectDate,
    this.currentSelected,
    this.jsons,
  }) : super(key: key);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  bool isLoading = true;
  bool isFromChrome = false;
  String url = "https://rentasadventures.com/API/payment_gateway.php";

  callApi({
    required String statusId,
    required String billcode,
    required String transactionId,
    required String orderId,
    required String msg,
  }) {
    var jsons = {
      "authKey": "key123",
      "activitiesId": widget.recordActivity.activityId,
      "totalBookedSlot": widget.jsons!.length.toString(),
      "dateSlot": widget.selectDate.toString(),
      "shiftSlotId": widget.currentSelected!.shiftId,
      "listOfAttendee": widget.jsons,
      "billCode": billcode,
      "orderId": orderId,
      "transactionCode": transactionId,
      "msg": msg,
      "firstNameRegister": widget.jsons![0]["name"],
      "firstPhoneNumberRegister": widget.jsons![0]["phone_number"],
      "firstEmailRegister": widget.jsons![0]["email_address"]
    };
    HttpAuth.postApi(jsons: jsons, url: 'insert_attendee.php').then((value) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        body: Center(
          child: Text(
            'Payment Sucessfull',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        title: '',
        desc: '',
        btnOkOnPress: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ).show();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _launchInBrowser(Uri.parse(url));

    if (kIsWeb) {
      isFromChrome = true;
    } else {
      isFromChrome = false;
    }
    isLoading = false;
    setState(() {});
    super.initState();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text("Payment Gateway")),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox()
        //  WebView(
        //     initialUrl: url,
        //     javascriptMode: JavascriptMode.unrestricted,
        //     onWebViewCreated: (WebViewController controller) {
        //       _controller.complete(controller);
        //     },
        //   ),

        // WebView(
        //     javascriptMode: JavascriptMode.unrestricted,
        //     initialUrl:
        //         'https://rentasadventures.com/API/payment_gateway.php',
        //     onProgress: (progress) {
        //       print(progress);
        //     },
        //     onPageFinished: (url) {
        //       if (url.contains(
        //           "https://rentasadventures.com/API/insert_attendee.php")) {
        //         var uri = Uri.dataFromString(url); //converts string to a uri
        //         Map<String, String> params = uri
        //             .queryParameters; // query parameters automatically populated
        //         var statusId = params[
        //             'status_id']; // return value of parameter "statusId" from uri
        //         var billcode = params['billcode'];
        //         var transactionId = params['transaction_id'];
        //         var orderId = params['order_id'];
        //         var msg = params['msg'];
        //         if (statusId.toString() == "1") {
        //           isLoading = true;
        //           setState(() {});
        //           callApi(
        //               statusId: statusId.toString(),
        //               billcode: billcode.toString(),
        //               transactionId: transactionId.toString(),
        //               orderId: orderId.toString(),
        //               msg: msg.toString());
        //         } else {
        //           AwesomeDialog(
        //             context: context,
        //             animType: AnimType.SCALE,
        //             dialogType: DialogType.ERROR,
        //             body: Center(
        //               child: Text(
        //                 'Failed to make a payment please try again. ',
        //                 style: GoogleFonts.montserrat(
        //                     fontWeight: FontWeight.normal, fontSize: 16),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //             title: '',
        //             desc: '',
        //             btnOkOnPress: () {
        //               Navigator.of(context).pop();
        //             },
        //           ).show();
        //         }
        //       }
        //     }),
        );
  }
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 1),
      ),
    );
}
