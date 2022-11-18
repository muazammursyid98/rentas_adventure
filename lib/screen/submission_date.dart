import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:rentas_adventure/screen/form_attendee.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../model/activity_model.dart';
import '../model/session_model.dart';
import '../provider/rest.dart';
import '../widget/badge_cart.dart';

class SubmissionDate extends StatefulWidget {
  final Record recordActivity;
  const SubmissionDate({Key? key, required this.recordActivity})
      : super(key: key);

  @override
  _SubmissionDateState createState() => _SubmissionDateState();
}

class _SubmissionDateState extends State<SubmissionDate> {
  int personToJoin = 1;
  int availableSlot = 0;
  int currentChoose = 0;
  double totalPrice = 0.0;
  double priceOri = 0.0;

  DateTime? selectDate = DateTime.now();

  bool isActivityGotSlot = false;
  bool isLoading = true;

  List<Session>? listOfSession = [];
  Session? currentSelected;

  @override
  void initState() {
    availableSlot = widget.recordActivity.activityAvailable == null
        ? 0
        : int.parse(widget.recordActivity.activityAvailable!);

    isActivityGotSlot =
        widget.recordActivity.activityAvailable == null ? false : true;

    totalPrice = double.parse(widget.recordActivity.activityPrice!);
    priceOri = double.parse(widget.recordActivity.activityPrice!);

    callApi();

    super.initState();
  }

  callApi() {
    var jsons = {"authKey": "key123"};
    HttpAuth.postApi(jsons: jsons, url: 'sessiontime.php').then((value) {
      final sessionTime = sessionTimeFromJson(value.body);
      listOfSession = sessionTime.records!;
      isLoading = false;
      setState(() {});
    });
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

  incrementPerson() {
    if (availableSlot == 0 && isActivityGotSlot == true) {
      return;
    }
    personToJoin++;
    availableSlot--;
    totalPrice = 0.0;
    totalPrice = personToJoin * priceOri;
    setState(() {});
  }

  decrementPerson() {
    if (personToJoin == 1) {
      return;
    }
    availableSlot++;
    personToJoin--;
    totalPrice = 0.0;
    totalPrice = personToJoin * priceOri;
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectDate)
      setState(() {
        selectDate = picked;
      });
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
          return viewForMobile();
        default:
          return viewForTablet();
      }
    }
  }

  Widget viewForWeb() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.only(
          top: 5.h,
          bottom: 5.h,
          left: 14.w,
          right: 14.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              "PICK DATE",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(selectDate!),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.5.h,
                  ),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.red,
                      size: 4.5.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            // SizedBox(
            //   height: getProportionateScreenHeight(150),
            //   child: CupertinoDatePicker(
            //     mode: CupertinoDatePickerMode.date,
            //     initialDateTime: DateTime.now(),
            //     onDateTimeChanged: (DateTime newDateTime) {
            //       selectDate = newDateTime;
            //       //Do Some thing
            //     },
            //     use24hFormat: false,
            //     minuteInterval: 1,
            //   ),
            // ),
            Divider(height: 3.h, color: Colors.grey),
            Text(
              "TOTAL GUEST",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: getProportionateScreenWidth(8)),
                    Icon(
                      Icons.person,
                      size: 4.5.h,
                    ),
                    SizedBox(width: getProportionateScreenWidth(8)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: getProportionateScreenHeight(12)),
                        Text(
                          "Person",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Text(
                          "${widget.recordActivity.activityName}",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(12))
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () => decrementPerson(),
                      child: Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 4.5.h,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      personToJoin.toString(),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () => incrementPerson(),
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 4.5.h,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
            const Divider(height: 15, color: Colors.grey),
            Text(
              "CHOOSE SLOT",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 2.h),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset(
                        'assets/images/table1.png',
                        fit: BoxFit.contain,
                        height: 30.h,
                        width: double.infinity,
                      ),
                    ),
                    ...listOfSession!.map(
                      (Session element) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                currentChoose = element.shiftId!;
                                currentSelected = element;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(50),
                                  right: getProportionateScreenWidth(50),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: currentChoose == element.shiftId!
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                height: 10.h,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      element.shiftName!,
                                      style: GoogleFonts.montserrat(
                                        color: currentChoose == element.shiftId!
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    Text(
                                      "${element.startTime!} - ${element.endTime!}",
                                      style: GoogleFonts.montserrat(
                                        color: currentChoose == element.shiftId!
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isActivityGotSlot == false
                        ? const SizedBox()
                        : Text(
                            "Available Slot :",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                    Text(
                      "Total Price :",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isActivityGotSlot == false
                        ? const SizedBox()
                        : Text(
                            "$availableSlot Left",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                    Text(
                      "RM ${totalPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                addToCartWidget(),
                // Row(
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 209, 209, 209),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () => Navigator.pop(context),
                //           child: Text(
                //             'BACK',
                //             style: GoogleFonts.montserrat(
                //               color: const Color.fromARGB(255, 0, 94, 172),
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),

                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 0, 94, 172),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () {
                //             if (currentChoose == 0) {
                //               AwesomeDialog(
                //                 width: checkConditionWidth(),
                //                 bodyHeaderDistance: 60,
                //                 context: context,
                //                 animType: AnimType.BOTTOMSLIDE,
                //                 dialogType: DialogType.WARNING,
                //                 body: Center(
                //                   child: Text(
                //                     'Please select session time',
                //                     style: GoogleFonts.montserrat(
                //                       fontWeight: FontWeight.normal,
                //                       fontSize: 16,
                //                     ),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 ),
                //                 title: '',
                //                 desc: '',
                //                 btnOkOnPress: () {},
                //               ).show();
                //             } else {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => FormAttendeeScreen(
                //                     recordActivity: widget.recordActivity,
                //                     selectDate: selectDate!,
                //                     personToJoin: personToJoin,
                //                     currentSelected: currentSelected,
                //                   ),
                //                 ),
                //               );
                //             }
                //           },
                //           child: Text(
                //             'NEXT',
                //             style: GoogleFonts.montserrat(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            )
          ],
        ),
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
                if (currentChoose == 0) {
                  AwesomeDialog(
                    width: checkConditionWidth(),
                    bodyHeaderDistance: 60,
                    context: context,
                    animType: AnimType.BOTTOMSLIDE,
                    dialogType: DialogType.WARNING,
                    body: Center(
                      child: Text(
                        'Please select session time',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: '',
                    desc: '',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  counterController.valueCart.value =
                      counterController.valueCart.value + 1;

                  var customLengthId = nanoid(3);

                  var jsonsInsert = {
                    "id": customLengthId,
                    "recordActivity": widget.recordActivity,
                    "selectDate": selectDate!,
                    "personToJoin": personToJoin,
                    "currentSelected": currentSelected,
                  };

                  counterController.listStoreCart.add(jsonsInsert);

                  AwesomeDialog(
                    width: checkConditionWidth(),
                    bodyHeaderDistance: 60,
                    context: context,
                    animType: AnimType.BOTTOMSLIDE,
                    dialogType: DialogType.SUCCES,
                    body: Center(
                      child: Text(
                        'Successfull insert add to cart',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: '',
                    desc: '',
                    btnOkOnPress: () {},
                  ).show().then((value) => Navigator.of(context).pop());

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => FormAttendeeScreen(
                  //       recordActivity: widget.recordActivity,
                  //       selectDate: selectDate!,
                  //       personToJoin: personToJoin,
                  //       currentSelected: currentSelected,
                  //     ),
                  //   ),
                  // );
                }
              },
              child: Container(
                color: const Color.fromARGB(255, 0, 94, 172),
                child: Center(
                  child: Text(
                    'Add to Cart',
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
        left: 10.w,
        right: 10.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 2.h,
          ),
          Text(
            "PICK DATE",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 5.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(selectDate!),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.5.h,
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 4.5.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          // SizedBox(
          //   height: getProportionateScreenHeight(150),
          //   child: CupertinoDatePicker(
          //     mode: CupertinoDatePickerMode.date,
          //     initialDateTime: DateTime.now(),
          //     onDateTimeChanged: (DateTime newDateTime) {
          //       selectDate = newDateTime;
          //       //Do Some thing
          //     },
          //     use24hFormat: false,
          //     minuteInterval: 1,
          //   ),
          // ),
          Divider(height: 3.h, color: Colors.grey),
          Text(
            "TOTAL GUEST",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: getProportionateScreenHeight(100),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Icon(
                    Icons.person,
                    size: 4.5.h,
                  ),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Person",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.recordActivity.activityName}",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () => decrementPerson(),
                    child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 4.5.h,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    personToJoin.toString(),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () => incrementPerson(),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 4.5.h,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
          const Divider(height: 15, color: Colors.grey),
          Text(
            "CHOOSE SLOT",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 2.h),
                Expanded(
                  child: Column(
                    children: [
                      Placeholder(),
                      ...listOfSession!.map(
                        (Session element) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  currentChoose = element.shiftId!;
                                  currentSelected = element;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(50),
                                    right: getProportionateScreenWidth(50),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: currentChoose == element.shiftId!
                                          ? Colors.green
                                          : Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  height: 10.h,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        element.shiftName!,
                                        style: GoogleFonts.montserrat(
                                          color:
                                              currentChoose == element.shiftId!
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      Text(
                                        "${element.startTime!} - ${element.endTime!}",
                                        style: GoogleFonts.montserrat(
                                          color:
                                              currentChoose == element.shiftId!
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isActivityGotSlot == false
                            ? const SizedBox()
                            : Text(
                                "Available Slot :",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                        isActivityGotSlot == false
                            ? const SizedBox()
                            : Text(
                                "$availableSlot Left",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.sp,
                                ),
                              ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Price :",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "RM ${totalPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                addToCartWidget(),
                // Row(
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 209, 209, 209),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () => Navigator.pop(context),
                //           child: Text(
                //             'BACK',
                //             style: GoogleFonts.montserrat(
                //               color: const Color.fromARGB(255, 0, 94, 172),
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 0, 94, 172),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () {
                //             if (currentChoose == 0) {
                //               AwesomeDialog(
                //                 width: checkConditionWidth(),
                //                 bodyHeaderDistance: 60,
                //                 context: context,
                //                 animType: AnimType.BOTTOMSLIDE,
                //                 dialogType: DialogType.WARNING,
                //                 body: Center(
                //                   child: Text(
                //                     'Please select session time',
                //                     style: GoogleFonts.montserrat(
                //                       fontWeight: FontWeight.normal,
                //                       fontSize: 16,
                //                     ),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 ),
                //                 title: '',
                //                 desc: '',
                //                 btnOkOnPress: () {},
                //               ).show();
                //             } else {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => FormAttendeeScreen(
                //                     recordActivity: widget.recordActivity,
                //                     selectDate: selectDate!,
                //                     personToJoin: personToJoin,
                //                     currentSelected: currentSelected,
                //                   ),
                //                 ),
                //               );
                //             }
                //           },
                //           child: Text(
                //             'NEXT',
                //             style: GoogleFonts.montserrat(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget viewForMobile() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.only(
          top: 5.h,
          bottom: 5.h,
          left: MediaQuery.of(context).size.width >= 1000
              ? 450
              : MediaQuery.of(context).size.width >= 500
                  ? 40
                  : 20,
          right: MediaQuery.of(context).size.width >= 1000
              ? 450
              : MediaQuery.of(context).size.width >= 500
                  ? 40
                  : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 2.h,
          ),
          Text(
            "SELECT DATE",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 5.h,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(selectDate!),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.5.h,
                ),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.red,
                    size: 4.5.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          // SizedBox(
          //   height: getProportionateScreenHeight(150),
          //   child: CupertinoDatePicker(
          //     mode: CupertinoDatePickerMode.date,
          //     initialDateTime: DateTime.now(),
          //     onDateTimeChanged: (DateTime newDateTime) {
          //       selectDate = newDateTime;
          //       //Do Some thing
          //     },
          //     use24hFormat: false,
          //     minuteInterval: 1,
          //   ),
          // ),
          Divider(height: 3.h, color: Colors.grey),
          Text(
            "TOTAL GUEST",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            height: getProportionateScreenHeight(100),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Icon(
                    Icons.person,
                    size: 4.5.h,
                  ),
                  SizedBox(width: getProportionateScreenWidth(8)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Person",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.recordActivity.activityName}",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () => decrementPerson(),
                    child: Icon(
                      Icons.arrow_circle_left_outlined,
                      size: 4.5.h,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    personToJoin.toString(),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () => incrementPerson(),
                    child: Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 4.5.h,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
          const Divider(height: 15, color: Colors.grey),
          Text(
            "CHOOSE SLOT",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 2.h),
                Expanded(
                  child: Column(
                    children: [
                      ...listOfSession!.map(
                        (Session element) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  currentChoose = element.shiftId!;
                                  currentSelected = element;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(50),
                                    right: getProportionateScreenWidth(50),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: currentChoose == element.shiftId!
                                          ? Colors.green
                                          : Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  height: 10.h,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        element.shiftName!,
                                        style: GoogleFonts.montserrat(
                                          color:
                                              currentChoose == element.shiftId!
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      Text(
                                        "${element.startTime!} - ${element.endTime!}",
                                        style: GoogleFonts.montserrat(
                                          color:
                                              currentChoose == element.shiftId!
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isActivityGotSlot == false
                            ? const SizedBox()
                            : Text(
                                "Available Slot :",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                        isActivityGotSlot == false
                            ? const SizedBox()
                            : Text(
                                "$availableSlot Left",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.sp,
                                ),
                              ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Price :",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "RM ${totalPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: getProportionateScreenHeight(15)),
                addToCartWidget(),

                // Row(
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 209, 209, 209),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () => Navigator.pop(context),
                //           child: Text(
                //             'BACK',
                //             style: GoogleFonts.montserrat(
                //               color: const Color.fromARGB(255, 0, 94, 172),
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: SizedBox(
                //         height: getProportionateScreenHeight(50),
                //         width: double.infinity,
                //         child: ElevatedButton(
                //           style: ButtonStyle(
                //               foregroundColor: MaterialStateProperty.all<Color>(
                //                   Colors.white),
                //               backgroundColor: MaterialStateProperty.all<Color>(
                //                 const Color.fromARGB(255, 0, 94, 172),
                //               ),
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(
                //                 const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.zero,
                //                 ),
                //               )),
                //           onPressed: () {
                //             if (currentChoose == 0) {
                //               AwesomeDialog(
                //                 width: checkConditionWidth(),
                //                 bodyHeaderDistance: 60,
                //                 context: context,
                //                 animType: AnimType.BOTTOMSLIDE,
                //                 dialogType: DialogType.WARNING,
                //                 body: Center(
                //                   child: Text(
                //                     'Please select session time',
                //                     style: GoogleFonts.montserrat(
                //                       fontWeight: FontWeight.normal,
                //                       fontSize: 18.sp,
                //                     ),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 ),
                //                 title: '',
                //                 desc: '',
                //                 btnOkOnPress: () {},
                //               ).show();
                //             } else {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => FormAttendeeScreen(
                //                     recordActivity: widget.recordActivity,
                //                     selectDate: selectDate!,
                //                     personToJoin: personToJoin,
                //                     currentSelected: currentSelected,
                //                   ),
                //                 ),
                //               );
                //             }
                //           },
                //           child: Text(
                //             'NEXT',
                //             style: GoogleFonts.montserrat(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
