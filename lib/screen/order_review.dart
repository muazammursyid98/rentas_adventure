import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rentas_adventure/screen/payment_gateway.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/activity_model.dart';
import '../model/session_model.dart';

import '../utils/convert24hours.dart';
import '../widget/badge_cart.dart';

class OrderReview extends StatefulWidget {
  final List<Map<String, String?>>? jsons;

  const OrderReview({
    Key? key,
    this.jsons,
  }) : super(key: key);

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  String url = "https://rentasadventures.com/API/payment_gateway.php";

  double totalAllPrice = 0.0;

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

  List<Column> checkConditionPhone() {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return viewForWeb();
    } else {
      switch (Device.screenType) {
        case ScreenType.mobile:
          return viewForMobile();
        default:
          return viewForTablet();
      }
    }
  }

  List<Column> viewForMobile() {
    return [
      ...counterController.listStoreCart.map(
        (element) {
          double prices =
              double.parse(element["recordActivity"].activityPrice) *
                  element["personToJoin"];
          String doublePrices = prices.toStringAsFixed(2);
          totalAllPrice += double.parse(doublePrices);
          return Column(
            children: [
              Container(
                height: 12.h,
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element["recordActivity"].activityName,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('dd/MM/yyyy').format(element["selectDate"]),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "(${element["currentSelected"].shiftName} - ${time24to12Format(element["currentSelected"].startTime)} to ${time24to12Format(element["currentSelected"].endTime)})",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          element["personToJoin"].toString(),
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.person,
                          size: 16.sp,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "RM $doublePrices",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 0.1.h,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          );
        },
      ).toList()
    ];
  }

  List<Column> viewForTablet() {
    return [
      ...counterController.listStoreCart.map(
        (element) {
          double prices =
              double.parse(element["recordActivity"].activityPrice) *
                  element["personToJoin"];
          String doublePrices = prices.toStringAsFixed(2);
          totalAllPrice += double.parse(doublePrices);
          return Column(
            children: [
              Container(
                height: 16.h,
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element["recordActivity"].activityName,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('dd/MM/yyyy').format(element["selectDate"]),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "(${element["currentSelected"].shiftName} - ${time24to12Format(element["currentSelected"].startTime)} to ${time24to12Format(element["currentSelected"].endTime)})",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          element["personToJoin"].toString(),
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.person,
                          size: 20.sp,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "RM $doublePrices",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 0.1.h,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          );
        },
      ).toList()
    ];
  }

  List<Column> viewForWeb() {
    return [
      ...counterController.listStoreCart.map(
        (element) {
          double prices =
              double.parse(element["recordActivity"].activityPrice) *
                  element["personToJoin"];
          String doublePrices = prices.toStringAsFixed(2);
          totalAllPrice += double.parse(doublePrices);
          return Column(
            children: [
              Container(
                height: 16.h,
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      element["recordActivity"].activityName,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat('dd/MM/yyyy').format(element["selectDate"]),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "(${element["currentSelected"].shiftName} - ${time24to12Format(element["currentSelected"].startTime)} to ${time24to12Format(element["currentSelected"].endTime)})",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          element["personToJoin"].toString(),
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.person,
                          size: 16.sp,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "RM $doublePrices",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 0.1.h,
                width: double.infinity,
                color: Colors.black,
              ),
            ],
          );
        },
      ).toList()
    ];
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
            top: 5.h,
            bottom: 5.h,
            left: 10.w,
            right: 10.w,
          ),
          child: Scaffold(
            body: SafeArea(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Ticket Review",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    // Text(
                                    //   "${widget.recordActivity.activityName}",
                                    //   style: GoogleFonts.montserrat(
                                    //     textStyle: const TextStyle(
                                    //       color: Colors.black,
                                    //       fontWeight: FontWeight.w500,
                                    //       fontSize: 12,
                                    //     ),
                                    //   ),
                                    // ),
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
                        ...checkConditionPhone(),
                      ],
                      //[
                      //     showTitle("Category"),
                      //      showDescription(widget.recordActivity.activityName!),
                      //     SizedBox(height: getProportionateScreenHeight(20)),
                      //     showTitle("Date"),
                      //     showDescription(
                      //         "${widget.selectDate.toLocal()}".split(' ')[0]),
                      //     SizedBox(height: getProportionateScreenHeight(20)),
                      //     showTitle("Time"),
                      //      showDescription(widget.currentSelected!.shiftName!),
                      //     showDescription("10:00am to 12:00pm"),
                      //     SizedBox(height: getProportionateScreenHeight(20)),
                      //     showTitle("Location"),
                      //     showDescription(
                      //       widget.recordActivity.activityLocation!),
                      //     SizedBox(height: getProportionateScreenHeight(20)),
                      //     showTitle("Total Guest"),
                      //  showDescription(widget.personToJoin.toString()),
                      //  ],
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
                          "RM ${totalAllPrice.toStringAsFixed(2)}",
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
                                    jsons: widget.jsons,
                                    totalAllPrice: totalAllPrice,
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
