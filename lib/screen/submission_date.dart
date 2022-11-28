import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/nanoid.dart';
import 'package:rentas_adventure/screen/form_attendee.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:rentas_adventure/widget/disclaimer_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../model/activity_model.dart';
import '../model/list_available.dart';
import '../model/session_model.dart';
import '../provider/rest.dart';
import '../widget/badge_cart.dart';
import '../widget/question_answer.dart';

class SubmissionDate extends StatefulWidget {
  final Record recordActivity;
  const SubmissionDate({Key? key, required this.recordActivity})
      : super(key: key);

  @override
  _SubmissionDateState createState() => _SubmissionDateState();
}

class _SubmissionDateState extends State<SubmissionDate> {
  int personToJoin = 0;
  int availableSlotOri = 0;
  int availableSlot = 0;
  int currentChoose = 0;
  double totalPrice = 0.0;
  double priceOri = 0.0;

  DateTime? selectDate = DateTime.now();

  bool isActivityGotSlot = false;
  bool isLoading = true;

  List<ListSessionRecord> listOfSession = [];
  ListSessionRecord? currentSelected;
  List<ListAvailableElement>? listAvailableBalance = [];

  String displaySlot = "";

  @override
  void initState() {
    availableSlot = widget.recordActivity.activityAvailable == null
        ? 0
        : int.parse(widget.recordActivity.activityAvailable!);
    availableSlotOri = availableSlot;
    isActivityGotSlot =
        widget.recordActivity.activityAvailable == null ? false : true;

    totalPrice = double.parse(widget.recordActivity.activityPrice!);
    priceOri = double.parse(widget.recordActivity.activityPrice!);
    callApi();

    super.initState();
  }

  callApi() {
    try {
      var jsons = {
        "authKey": "key123",
        "activityId": widget.recordActivity.activityId
      };
      HttpAuth.postApi(jsons: jsons, url: 'get_session_by_id.php')
          .then((value) {
        final listSessionRecords = listSessionRecordsFromJson(value.body);
        listOfSession = listSessionRecords.listSessionRecords ?? [];
        callApiBalances();
      });
    } catch (e) {
      listOfSession = [];
      isLoading = false;
      setState(() {});
    }
  }

  callApiBalances() {
    var jsons = {
      "authKey": "key123",
      "selectDate": DateFormat('yyyy-MM-dd').format(selectDate!),
      "activityId": widget.recordActivity.activityId
    };
    HttpAuth.postApi(jsons: jsons, url: 'get_available_balance.php')
        .then((value) {
      final listAvailable = listAvailableFromJson(value.body);
      listAvailableBalance = listAvailable.listAvailable;
      currentChoose = 0;
      isLoading = false;
      availableSlot = 0;
      personToJoin = 0;
      setDisplaySlotValue("N/A");

      setState(() {});
      showDialog(
          context: context,
          builder: (_) {
            return DisclaimerScreen();
          });
    });
  }

  checkAddToCart() {
    try {
      List getValue = counterController.listStoreCart
          .where((element) =>
              DateFormat('yyyy-MM-dd').format(element["selectDate"]) ==
                  DateFormat('yyyy-MM-dd').format(selectDate!) &&
              element["recordActivity"].activityId ==
                  widget.recordActivity.activityId &&
              element["currentSelected"].shiftActivitiesId.toString() ==
                  currentSelected!.shiftActivitiesId.toString())
          .toList();

      if (getValue.isEmpty) {
        return;
      }
      int newValue =
          availableSlot - int.parse(getValue[0]["personToJoin"].toString());
      availableSlot = newValue;
      setState(() {});
      setDisplaySlotValue(newValue.toString());
    } catch (e) {}
  }

  prosesDoTheBalances() {
    List<ListAvailableElement> getValueBalances = listAvailableBalance!
        .where((element) =>
            element.shiftSlotId.toString() ==
            currentSelected!.shiftActivitiesId.toString())
        .toList();
    if (getValueBalances.isEmpty) {
      availableSlot = availableSlotOri;
      setDisplaySlotValue(availableSlot.toString());
      checkAddToCart();
    } else {
      availableSlot =
          availableSlotOri - int.parse(getValueBalances[0].purchased!);
      setDisplaySlotValue(availableSlot.toString());
      checkAddToCart();
    }
  }

  setDisplaySlotValue(value) {
    displaySlot = value;
    setState(() {});
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
    var value = checkValidation();
    if (value == null) {
      return;
    }
    if (availableSlot == 0 && isActivityGotSlot == true) {
      return;
    }
    personToJoin++;
    availableSlot--;
    totalPrice = 0.0;
    totalPrice = personToJoin * priceOri;
    setDisplaySlotValue(availableSlot.toString());
  }

  decrementPerson() {
    var value = checkValidation();
    if (value == null) {
      return;
    }
    if (personToJoin < 1) {
      return;
    }
    availableSlot++;
    personToJoin--;
    totalPrice = 0.0;
    totalPrice = personToJoin * priceOri;
    setDisplaySlotValue(availableSlot.toString());
  }

  int? checkValidation() {
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
      return null;
    }

    if (availableSlot == 0 && currentSelected != null && personToJoin < 1) {
      AwesomeDialog(
        width: checkConditionWidth(),
        bodyHeaderDistance: 60,
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.INFO,
        body: Center(
          child: Text(
            'Sorry this session already full. Thank you',
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
      return null;
    }
    return -1;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectDate!,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectDate) {
      selectDate = picked;
      isLoading = true;
      setState(() {});
      callApiBalances();
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
              height: 4.h,
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
                        fontSize: 14.sp,
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(left: 100, right: 100),
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
                    const SizedBox(width: 15),
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
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () => incrementPerson(),
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 4.5.h,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Divider(height: 15, color: Colors.grey),
                    listOfSession.isEmpty
                        ? const SizedBox()
                        : Text(
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
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HtmlWidget(
                          // the first parameter (`html`) is required
                          currentSelected == null
                              ? ""
                              : currentSelected!.timeDescription!,

                          // all other parameters are optional, a few notable params:

                          // specify custom styling for an element
                          // see supported inline styling below
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },

                          // render a custom widget
                          customWidgetBuilder: (element) {
                            return null;
                          },

                          // these callbacks are called when a complicated element is loading
                          // or failed to render allowing the app to render progress indicator
                          // and fallback widget
                          onErrorBuilder: (context, element, error) =>
                              Text('$element error: $error'),
                          onLoadingBuilder:
                              (context, element, loadingProgress) =>
                                  CircularProgressIndicator(),

                          // this callback will be triggered when user taps a link

                          // select the render mode for HTML body
                          // by default, a simple `Column` is rendered
                          // consider using `ListView` or `SliverList` for better performance
                          renderMode: RenderMode.column,

                          // set the default styling for text
                          textStyle: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ...listOfSession.map(
                      (ListSessionRecord element) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                currentChoose =
                                    int.parse(element.shiftActivitiesId!);
                                currentSelected = element;
                                setState(() {});
                                prosesDoTheBalances();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(20),
                                  right: getProportionateScreenWidth(20),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: currentChoose ==
                                            int.parse(
                                                element.shiftActivitiesId!)
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                height: 6.h,
                                width: 11.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      element.shiftName!,
                                      style: GoogleFonts.montserrat(
                                        color: currentChoose ==
                                                int.parse(
                                                    element.shiftActivitiesId!)
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
                            SizedBox(height: 2.h),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "Available Slot :",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "$displaySlot Left",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Price :",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
            SizedBox(height: 4.h),
            addToCartWidget(),
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
                var value = checkValidation();
                if (value == null) {
                  return;
                }
                if (personToJoin == 0) {
                  AwesomeDialog(
                    width: checkConditionWidth(),
                    bodyHeaderDistance: 60,
                    context: context,
                    animType: AnimType.BOTTOMSLIDE,
                    dialogType: DialogType.INFO,
                    body: Center(
                      child: Text(
                        'Please select how many person.',
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
                  return;
                }

                List getValue = counterController.listStoreCart
                    .where((element) =>
                        DateFormat('yyyy-MM-dd')
                                .format(element["selectDate"]) ==
                            DateFormat('yyyy-MM-dd').format(selectDate!) &&
                        element["recordActivity"].activityId ==
                            widget.recordActivity.activityId &&
                        element["currentSelected"]
                                .shiftActivitiesId
                                .toString() ==
                            currentSelected!.shiftActivitiesId.toString())
                    .toList();

                if (getValue.isEmpty) {
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
                } else {
                  getValue[0]["personToJoin"] += personToJoin;
                }

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
                  fontSize: 15.sp,
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
                        fontSize: 14.sp,
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
                      size: 2.h,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h, color: Colors.grey),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40),
              width: double.infinity,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: getProportionateScreenWidth(3)),
                    Icon(
                      Icons.person,
                      size: 3.5.h,
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
                        size: 3.5.h,
                      ),
                    ),
                    const SizedBox(width: 15),
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
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () => incrementPerson(),
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 3.5.h,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Divider(height: 15, color: Colors.grey),
                    listOfSession.isEmpty
                        ? const SizedBox()
                        : Text(
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
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HtmlWidget(
                          // the first parameter (`html`) is required
                          currentSelected == null
                              ? ""
                              : currentSelected!.timeDescription!,

                          // all other parameters are optional, a few notable params:

                          // specify custom styling for an element
                          // see supported inline styling below
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },

                          // render a custom widget
                          customWidgetBuilder: (element) {
                            return null;
                          },

                          // these callbacks are called when a complicated element is loading
                          // or failed to render allowing the app to render progress indicator
                          // and fallback widget
                          onErrorBuilder: (context, element, error) =>
                              Text('$element error: $error'),
                          onLoadingBuilder:
                              (context, element, loadingProgress) =>
                                  CircularProgressIndicator(),

                          // this callback will be triggered when user taps a link

                          // select the render mode for HTML body
                          // by default, a simple `Column` is rendered
                          // consider using `ListView` or `SliverList` for better performance
                          renderMode: RenderMode.column,

                          // set the default styling for text
                          textStyle: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ...listOfSession.map(
                      (ListSessionRecord element) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                currentChoose =
                                    int.parse(element.shiftActivitiesId!);
                                currentSelected = element;
                                setState(() {});
                                prosesDoTheBalances();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(20),
                                  right: getProportionateScreenWidth(20),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: currentChoose ==
                                            int.parse(
                                                element.shiftActivitiesId!)
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                height: 5.h,
                                width: 16.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      element.shiftName!,
                                      style: GoogleFonts.montserrat(
                                        color: currentChoose ==
                                                int.parse(
                                                    element.shiftActivitiesId!)
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
                            SizedBox(height: 2.h),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "Available Slot :",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "$displaySlot Left",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Price :",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
            SizedBox(height: 4.h),
            addToCartWidget(),
          ],
        ),
      ),
    );
  }

  Widget viewForMobile() {
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
                  fontSize: 15.sp,
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
                        fontSize: 15.sp,
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
                      size: 2.5.h,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h, color: Colors.grey),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: getProportionateScreenWidth(3)),
                    Icon(
                      Icons.person,
                      size: 3.5.h,
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
                        size: 3.5.h,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => incrementPerson(),
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 3.5.h,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Divider(height: 15, color: Colors.grey),
                    listOfSession.isEmpty
                        ? const SizedBox()
                        : Text(
                            "CHOOSE SLOT",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HtmlWidget(
                          // the first parameter (`html`) is required
                          currentSelected == null
                              ? ""
                              : currentSelected!.timeDescription!,

                          // all other parameters are optional, a few notable params:

                          // specify custom styling for an element
                          // see supported inline styling below
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },

                          // render a custom widget
                          customWidgetBuilder: (element) {
                            return null;
                          },

                          // these callbacks are called when a complicated element is loading
                          // or failed to render allowing the app to render progress indicator
                          // and fallback widget
                          onErrorBuilder: (context, element, error) =>
                              Text('$element error: $error'),
                          onLoadingBuilder:
                              (context, element, loadingProgress) =>
                                  CircularProgressIndicator(),

                          // this callback will be triggered when user taps a link

                          // select the render mode for HTML body
                          // by default, a simple `Column` is rendered
                          // consider using `ListView` or `SliverList` for better performance
                          renderMode: RenderMode.column,

                          // set the default styling for text
                          textStyle: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ...listOfSession.map(
                      (ListSessionRecord element) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                currentChoose =
                                    int.parse(element.shiftActivitiesId!);
                                currentSelected = element;
                                setState(() {});
                                prosesDoTheBalances();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(20),
                                  right: getProportionateScreenWidth(20),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    color: currentChoose ==
                                            int.parse(
                                                element.shiftActivitiesId!)
                                        ? Colors.green
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                height: 5.h,
                                width: 18.5.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      element.shiftName!,
                                      style: GoogleFonts.montserrat(
                                        color: currentChoose ==
                                                int.parse(
                                                    element.shiftActivitiesId!)
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
                            SizedBox(height: 2.h),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "Available Slot :",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                    isActivityGotSlot == false || displaySlot == ""
                        ? const SizedBox()
                        : Text(
                            "$displaySlot Left",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.sp,
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Price :",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
            SizedBox(height: 4.h),
            addToCartWidget(),
          ],
        ),
      ),
    );
  }
}
