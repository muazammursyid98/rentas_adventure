import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanoid/nanoid.dart';
import '../model/activity_model.dart';
import '../model/session_model.dart';
import '../provider/rest.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;

import '../toyibPaySdk/lib/toyyibpay_dart.dart';
import '../utils/size_config.dart';
import '../widget/badge_cart.dart';

class PaymentGateway extends StatefulWidget {
  final List<Map<String, String?>>? jsons;
  final double totalAllPrice;

  const PaymentGateway({Key? key, this.jsons, required this.totalAllPrice})
      : super(key: key);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  bool isLoading = true;
  bool isFromChrome = false;
  //String url = "https://rentasadventures.com/API/payment_gateway";
  //String url = "https://dev.toyyibpay.com/w5njfkxq";
  String url = "";

  insertTemporary() {
    double harga = widget.totalAllPrice;

    var customLengthId = nanoid(10);

    List listOfActivitiesBooked = [];
    for (var element in counterController.listStoreCart) {
      var jsonsByItemBooked = {
        "activitiesId": element["recordActivity"].activityId,
        "totalBookedSlot": element["personToJoin"].toString(),
        "dateSlot": element["selectDate"].toString(),
        "shiftSlotId": element["currentSelected"].shiftActivitiesId,
      };
      listOfActivitiesBooked.add(jsonsByItemBooked);
    }

    var jsons = {
      "authKey": "key123",
      "listOfActivitiesBooked": listOfActivitiesBooked,
      // "activitiesId": widget.recordActivity.activityId,
      // "totalBookedSlot": widget.personToJoin.toString(),
      // "dateSlot": widget.selectDate.toString(),
      // "shiftSlotId": widget.currentSelected!.shiftId,
      "firstNameRegister": widget.jsons![0]["name"],
      "firstPhoneNumberRegister": widget.jsons![0]["phone_number"],
      "firstEmailRegister": widget.jsons![0]["email_address"],
      "temporaryUnique": customLengthId,
      "listOfAttendee": widget.jsons,
      "totalPrice": harga.toStringAsFixed(2)
    };
    HttpAuth.postApi(jsons: jsons, url: 'temporary_insert.php').then((value) {
      if (value.statusCode == 200) {
        sendToPaymentGateway(customLengthId);
      } else {
        AwesomeDialog(
          width: getProportionateScreenWidth(200),
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              'Please try again. Thank you',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.normal, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
      }
    });
  }

  // callApi({
  //   required String statusId,
  //   required String billcode,
  //   required String transactionId,
  //   required String orderId,
  //   required String msg,
  // }) {
  //   var jsons = {
  //     "authKey": "key123",
  //     // "activitiesId": widget.recordActivity.activityId,
  //     // "totalBookedSlot": widget.personToJoin.toString(),
  //     // "dateSlot": widget.selectDate.toString(),
  //     // "shiftSlotId": widget.currentSelected!.shiftId,
  //     "listOfAttendee": widget.jsons,
  //     "billCode": billcode,
  //     "orderId": orderId,
  //     "transactionCode": transactionId,
  //     "msg": msg,
  //     "firstNameRegister": widget.jsons![0]["name"],
  //     "firstPhoneNumberRegister": widget.jsons![0]["phone_number"],
  //     "firstEmailRegister": widget.jsons![0]["email_address"]
  //   };
  //   HttpAuth.postApi(jsons: jsons, url: 'insert_attendee.php').then((value) {
  //     AwesomeDialog(
  //       width: getProportionateScreenWidth(200),
  //       bodyHeaderDistance: 60,
  //       context: context,
  //       animType: AnimType.SCALE,
  //       dialogType: DialogType.SUCCES,
  //       body: Center(
  //         child: Text(
  //           'Payment Sucessfull',
  //           style: GoogleFonts.montserrat(
  //               fontWeight: FontWeight.normal, fontSize: 16),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //       title: '',
  //       desc: '',
  //       btnOkOnPress: () {
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop();
  //         Navigator.of(context).pop();
  //       },
  //     ).show();
  //   });
  // }

  sendToPaymentGateway(String customLengthId) async {
    ToyyibPay toyyibpay;
    toyyibpay =
        ToyyibPay('zkkx33km-tz3f-cwiy-kq2w-7h1pwpfpj1tr', sandbox: true);

    String nama = 'testing';
    String email = 'testing@gmail.com';
    String telefon = '0139968055';
    double harga = widget.totalAllPrice;
    double rmx100 = (harga * 100);
    var model = await toyyibpay.createBill(
      categoryCode: '6ljcsgax',
      billName: 'Development Purpose',
      billDescription: 'Jumlah Harga ${harga.toStringAsFixed(2)}',
      billPriceSetting: '1',
      billPayorInfo: '1',
      billAmount: rmx100.toString(),
      billReturnUrl:
          "https://rentasadventures.com/flutter/?unique_id=$customLengthId",
      billCallbackUrl: '',
      billExternalReferenceNo: '',
      billTo: nama,
      billEmail: email,
      billPhone: telefon,
      billSplitPayment: '0',
      billSplitPaymentArgs: '',
      billPaymentChannel: '0',
      // 'billDisplayMerchant': '',
      // 'billContentEmail': '',
      // 'billAdditionalField': '',
      // 'billChargeToCustomer': '',
    );
    // var model = await toyyibpay.createBill(
    //   categoryCode: '6ljcsgax',
    //   billName: 'dasfsdfa ',
    //   billDescription: 'fsdfas dsdf',
    //   billPriceSetting: '1',
    //   billPayorInfo: '0',
    //   billAmount: '2520',
    //   billReturnUrl: '',
    //   billCallbackUrl: '',
    //   billExternalReferenceNo: '',
    //   billTo: 'Support',
    //   billEmail: 'aiman@gmail.com',
    //   billPhone: '60132345596',
    //   billSplitPayment: '0',
    //   billSplitPaymentArgs: '',
    //   billPaymentChannel: '2',
    //   billDisplayMerchant: '1',
    //   billChargeToCustomer: '2',
    // );
    url = "https://dev.toyyibpay.com/${model[0].billCode!}";
    // url =
    //     "https://stackoverflow.com/questions/67270250/how-can-i-avoid-blocking-popup-windows";
    _launchInBrowser();
    // var params = {
    //   'userSecretKey': "zkkx33km-tz3f-cwiy-kq2w-7h1pwpfpj1tr",
    //   'categoryCode': '6ljcsgax',
    //   'billName': '(Lifetime)',
    //   'billDescription': 'Jumlah Harga RM Jumlah Peserta',
    //   'billPriceSetting': 1,
    //   'billPayorInfo': 1,
    //   'billAmount': rmx100,
    //   'billReturnUrl': "https://rentasadventures.com/flutter",
    //   'billCallbackUrl': '',
    //   'billExternalReferenceNo': '',
    //   'billTo': nama,
    //   'billEmail': email,
    //   'billPhone': telefon,
    //   'billSplitPayment': 0,
    //   'billSplitPaymentArgs': '',
    //   'billPaymentChannel': 0,
    //   // 'billDisplayMerchant': '',
    //   // 'billContentEmail': '',
    //   // 'billAdditionalField': '',
    //   // 'billChargeToCustomer': '',
    // };

    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    //  _launchInBrowser();

    if (kIsWeb) {
      isFromChrome = true;
    } else {
      isFromChrome = false;
    }
    insertTemporary();
    super.initState();
  }

  Future<void> _launchInBrowser() async {
    js.context.callMethod('open', [url]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text("Payment Gateway")),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox()

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
