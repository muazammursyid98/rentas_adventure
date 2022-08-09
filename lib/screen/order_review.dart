import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rentas_adventure/screen/payment_gateway.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/activity_model.dart';
import '../model/session_model.dart';
import 'dart:js' as js;

class OrderReview extends StatefulWidget {
  final Record recordActivity;
  final DateTime selectDate;
  final Session? currentSelected;
  final List<Map<String, String?>>? jsons;

  const OrderReview({
    Key? key,
    required this.recordActivity,
    required this.selectDate,
    this.currentSelected,
    this.jsons,
  }) : super(key: key);

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  String url = "https://rentasadventures.com/API/payment_gateway.php";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchInBrowser() async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true);
      throw 'Could not launch $url';
    }
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
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.8),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(
              top: 60,
              bottom: 60,
              left: MediaQuery.of(context).size.width >= 800
                  ? 200
                  : MediaQuery.of(context).size.width >= 500
                      ? 40
                      : 20,
              right: MediaQuery.of(context).size.width >= 800
                  ? 200
                  : MediaQuery.of(context).size.width >= 500
                      ? 40
                      : 20),
          child: Scaffold(
            body: SafeArea(
              child: Scrollbar(
                radius: const Radius.circular(5),
                interactive: true,
                isAlwaysShown: true,
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: getProportionateScreenHeight(130),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: CircularPercentIndicator(
                                    radius: 40.0,
                                    lineWidth: 4.0,
                                    animation: false,
                                    percent: 1,
                                    center: const Text(
                                      "2 of 2",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.blue,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ticket Review",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "${widget.recordActivity.activityName}",
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: getProportionateScreenHeight(10),
                          right: getProportionateScreenWidth(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SafeArea(
                              child: Text(
                                "Back",
                                style: GoogleFonts.montserrat(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: getProportionateScreenHeight(35),
                      width: double.infinity,
                      color: Color.fromARGB(255, 228, 228, 228),
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.all(getProportionateScreenHeight(20)),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showTitle("Category"),
                          showDescription(widget.recordActivity.activityName!),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          showTitle("Date"),
                          showDescription(
                              "${widget.selectDate.toLocal()}".split(' ')[0]),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          showTitle("Time"),
                          showDescription(widget.currentSelected!.shiftName!),
                          showDescription("10:00am to 12:00pm"),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          showTitle("Location"),
                          showDescription(
                              widget.recordActivity.activityLocation!),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          showTitle("Total Guest"),
                          showDescription(widget.jsons!.length.toString()),
                        ],
                      ),
                    ),
                    Container(
                      height: getProportionateScreenHeight(35),
                      width: double.infinity,
                      color: const Color.fromARGB(255, 228, 228, 228),
                      child: const SizedBox(),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(300),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: getProportionateScreenHeight(30)),
                          Text(
                            "GRAND TOTAL",
                            style: GoogleFonts.montserrat(
                                letterSpacing: 0.5,
                                color: Colors.black45,
                                fontWeight: FontWeight.normal,
                                fontSize: 28),
                          ),
                          Text(
                            "RM 200",
                            style: GoogleFonts.montserrat(
                                letterSpacing: 0.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                            width: getProportionateScreenWidth(200),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.red,
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  )),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentGateway(
                                      recordActivity: widget.recordActivity,
                                      selectDate: widget.selectDate,
                                      currentSelected: widget.currentSelected,
                                      jsons: widget.jsons,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'PAY NOW',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text showDescription(String value) {
    return Text(
      value,
      style: GoogleFonts.montserrat(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Text showTitle(String value) {
    return Text(
      value,
      style: GoogleFonts.montserrat(
          color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 14),
    );
  }
}
