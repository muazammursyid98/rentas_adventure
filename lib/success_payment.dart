import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/provider/rest.dart';
import 'package:rentas_adventure/utils/size_config.dart';

import 'main.dart';

class PaymentSuccess extends StatefulWidget {
  final String uniqueId;
  final String statusId;
  final String billcode;
  final String orderId;
  final String msg;
  final String transactionId;
  const PaymentSuccess({
    Key? key,
    required this.uniqueId,
    required this.statusId,
    required this.billcode,
    required this.orderId,
    required this.msg,
    required this.transactionId,
  }) : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  bool isLoading = false;

  callApiPayment() async {
    if (widget.statusId != "") {
      if (widget.statusId == "1") {
        AwesomeDialog(
          width: getProportionateScreenWidth(200),
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: Center(
            child: Text(
              'You have successfully registered for our event and we look forward to your attendance!\nA confirmation e-mail with further details will be sent shortly.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.normal, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          title: 'Thank you for your registration',
          desc: '',
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  uniqueId: '',
                  statusId: '',
                  billcode: '',
                  orderId: '',
                  msg: '',
                  transactionId: '',
                ),
              ),
            );
          },
        ).show();
        // var jsons = {
        //   "authKey": "key123",
        //   "billCode": widget.billcode,
        //   "orderId": widget.orderId,
        //   "transactionCode": widget.transactionId,
        //   "msg": widget.msg,
        //   "temporaryUnique": widget.uniqueId,
        //   "status_id": widget.statusId,
        // };
        // await HttpAuth.postApi(jsons: jsons, url: 'get_temporary_id.php')
        //     .then((value) {
        //   setState(() {
        //     isLoading = false;
        //   });

        // });
      } else {
        isLoading = false;
        setState(() {});
        AwesomeDialog(
          width: getProportionateScreenWidth(200),
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              'Payment Failed. Please try again',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.normal, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  uniqueId: '',
                  statusId: '',
                  billcode: '',
                  orderId: '',
                  msg: '',
                  transactionId: '',
                ),
              ),
            );
          },
        ).show();
      }
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      callApiPayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/quadbike_jungle_tour.jpeg",
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.8),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
        const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
