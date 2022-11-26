import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/convert24hours.dart';
import '../widget/badge_cart.dart';
import '../widget/question_answer.dart';
import 'form_attendee.dart';

class DisplayAddToCart extends StatefulWidget {
  const DisplayAddToCart({Key? key}) : super(key: key);

  @override
  _DisplayAddToCartState createState() => _DisplayAddToCartState();
}

class _DisplayAddToCartState extends State<DisplayAddToCart> {
  bool isLoading = false;
  double totalAllPrice = 0.0;

  @override
  void initState() {
    super.initState();
  }

  checkConditionWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return getProportionateScreenWidth(200);
    } else {
      switch (Device.screenType) {
        case ScreenType.mobile:
          return double.infinity;
        default:
          return getProportionateScreenWidth(200);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                "assets/images/quadbike_jungle_tour.jpeg",
              ),
              fit: MediaQuery.of(context).size.width >= 900
                  ? BoxFit.fill
                  : BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.8),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : checkConditionPhone(),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 3.h,
            left: 2.w,
            right: 2.w,
          ),
          height: 5.h,
          width: double.infinity,
          child: Row(
            children: const [
              Spacer(),
              QuestionAnswer(),
              SizedBox(width: 20),
              BadgeCart(),
            ],
          ),
        )
      ],
    );
  }

  checkConditionPhone() {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return viewForWeb();
    } else {
      switch (Device.screenType) {
        case ScreenType.mobile:
          return viewForMobile(context);

        default:
          return viewForTablet();
      }
    }
  }

  Widget viewForWeb() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 5.h,
        bottom: 5.h,
        left: 30.w,
        right: 30.w,
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: [
                  ...counterController.listStoreCart.map(
                    (element) {
                      double prices = double.parse(
                              element["recordActivity"].activityPrice) *
                          element["personToJoin"];
                      String doublePrices = prices.toStringAsFixed(2);
                      totalAllPrice += double.parse(doublePrices);
                      return Column(
                        children: [
                          Container(
                            height: 16.h,
                            margin: EdgeInsets.only(
                                left: 3.w, right: 3.w, top: 3.h),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${element["currentSelected"].shiftName}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  element["recordActivity"].activityName,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(element["selectDate"]),
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
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
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                                width: checkConditionWidth(),
                                                bodyHeaderDistance: 60,
                                                context: context,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.WARNING,
                                                body: Center(
                                                  child: Text(
                                                    'Are you sure want to delete? ',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: '',
                                                desc: '',
                                                btnOkOnPress: () {
                                                  counterController
                                                      .listStoreCart
                                                      .removeWhere((item) =>
                                                          item["id"] ==
                                                          element["id"]);
                                                  counterController
                                                          .valueCart.value =
                                                      counterController
                                                          .listStoreCart.length;
                                                  if (counterController
                                                      .listStoreCart.isEmpty) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                btnOkText: 'Yes',
                                                btnCancelOnPress: () {},
                                                btnCancelText: 'No')
                                            .show();
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
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
                ],
              ),
            ),
          ),
          addToCartWidget(),
        ],
      ),
    );
  }

  Row addToCartWidget() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: getProportionateScreenHeight(60),
            width: getProportionateScreenWidth(60),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: const Color.fromARGB(255, 209, 209, 209),
                child: Center(
                  child: Text(
                    'Back',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 94, 172),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: getProportionateScreenHeight(60),
            width: getProportionateScreenWidth(60),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormAttendeeScreen(),
                  ),
                );
              },
              child: Container(
                color: const Color.fromARGB(255, 0, 94, 172),
                child: Center(
                  child: Text(
                    'Make a payment',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget viewForTablet() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 5.h,
        bottom: 5.h,
        left: 15.w,
        right: 15.w,
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: [
                  ...counterController.listStoreCart.map(
                    (element) {
                      double prices = double.parse(
                              element["recordActivity"].activityPrice) *
                          element["personToJoin"];
                      String doublePrices = prices.toStringAsFixed(2);
                      totalAllPrice += double.parse(doublePrices);
                      return Column(
                        children: [
                          Container(
                            height: 16.h,
                            margin: EdgeInsets.only(
                                left: 3.w, right: 3.w, top: 3.h),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${element["currentSelected"].shiftName}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  element["recordActivity"].activityName,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(element["selectDate"]),
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
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
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                                width: checkConditionWidth(),
                                                bodyHeaderDistance: 60,
                                                context: context,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.WARNING,
                                                body: Center(
                                                  child: Text(
                                                    'Are you sure want to delete? ',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: '',
                                                desc: '',
                                                btnOkOnPress: () {
                                                  counterController
                                                      .listStoreCart
                                                      .removeWhere((item) =>
                                                          item["id"] ==
                                                          element["id"]);
                                                  counterController
                                                          .valueCart.value =
                                                      counterController
                                                          .listStoreCart.length;
                                                  if (counterController
                                                      .listStoreCart.isEmpty) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                btnOkText: 'Yes',
                                                btnCancelOnPress: () {},
                                                btnCancelText: 'No')
                                            .show();
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
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
                ],
              ),
            ),
          ),
          addToCartWidget(),
        ],
      ),
    );
  }

  Widget viewForMobile(context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.only(
        top: 5.h,
        bottom: 5.h,
        left: 15.w,
        right: 15.w,
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: [
                  ...counterController.listStoreCart.map(
                    (element) {
                      double prices = double.parse(
                              element["recordActivity"].activityPrice) *
                          element["personToJoin"];
                      String doublePrices = prices.toStringAsFixed(2);
                      totalAllPrice += double.parse(doublePrices);
                      return Column(
                        children: [
                          Container(
                            height: 16.h,
                            margin: EdgeInsets.only(
                                left: 3.w, right: 3.w, top: 3.h),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${element["currentSelected"].shiftName}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  element["recordActivity"].activityName,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(element["selectDate"]),
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
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
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        AwesomeDialog(
                                                width: checkConditionWidth(),
                                                bodyHeaderDistance: 60,
                                                context: context,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.WARNING,
                                                body: Center(
                                                  child: Text(
                                                    'Are you sure want to delete? ',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: '',
                                                desc: '',
                                                btnOkOnPress: () {
                                                  counterController
                                                      .listStoreCart
                                                      .removeWhere((item) =>
                                                          item["id"] ==
                                                          element["id"]);
                                                  counterController
                                                          .valueCart.value =
                                                      counterController
                                                          .listStoreCart.length;
                                                  if (counterController
                                                      .listStoreCart.isEmpty) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                btnOkText: 'Yes',
                                                btnCancelOnPress: () {},
                                                btnCancelText: 'No')
                                            .show();
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
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
                ],
              ),
            ),
          ),
          addToCartWidget(),
        ],
      ),
    );
  }
}
