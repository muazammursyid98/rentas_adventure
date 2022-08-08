import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rentas_adventure/screen/order_review.dart';
import 'package:rentas_adventure/utils/size_config.dart';

import '../model/activity_model.dart';
import '../model/session_model.dart';
import '../widget/input_text.dart';

class FormAttendeeScreen extends StatefulWidget {
  final Record recordActivity;
  final DateTime selectDate;
  final int personToJoin;
  final int? currentStage;
  final Session? currentSelected;

  const FormAttendeeScreen({
    Key? key,
    required this.recordActivity,
    required this.selectDate,
    required this.personToJoin,
    this.currentStage,
    this.currentSelected,
  }) : super(key: key);

  @override
  _FormAttendeeScreenState createState() => _FormAttendeeScreenState();
}

class _FormAttendeeScreenState extends State<FormAttendeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _noTel;
  String? _name;

  late int personToJoin;
  late int chooseSession;
  late DateTime selectDate;

  int currentStage = 0;

  List<Map<String, String?>> jsons = [];

  List<Widget> columnDynamic = [];

  @override
  void initState() {
    super.initState();
    selectDate = widget.selectDate;
    personToJoin = widget.personToJoin;
    currentStage = widget.currentStage ?? 1;
    dynamicView();
  }

  void dynamicView() {
    //  columnDynamic.add(registrantColumn());

    for (var i = 0; i < personToJoin; i++) {
      final jsonsLocal = [
        {
          "name": "",
          "phone_number": "",
          "email_address": "",
        }
      ];
      jsons.addAll(jsonsLocal);
      columnDynamic.add(attendee1(i, i + 1));
    }
  }

  Column registrantColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentStage == 1 ? "REGISTRANT" : "Atendee $currentStage",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Name',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            _name = val;
          },
          validator: (value) {
            if (value == "") {
              return null;
            }
            return "Invalid name";
          },
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Phone Number',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            _noTel = val;
          },
          validator: (value) {
            if (value == "") {
              return null;
            }
            return "Invalid phone number";
          },
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Email Address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            _email = val;
          },
          validator: (email) {
            if (email != null && EmailValidator.validate(email)) {
              return null;
            }
            return "Invalid email address";
          },
        ),
      ],
    );
  }

  Column attendee1(count, display) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        Text(
          "ATTENDEE $display",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Name',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            jsons[count]["name"] = val;
          },
          validator: (value) {
            if (value != "") {
              return null;
            }
            return "Invalid name";
          },
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Phone Number',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            jsons[count]["phone_number"] = val;
          },
          validator: (value) {
            if (value != "") {
              return null;
            }
            return "Invalid phone number";
          },
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        JDInputText(
          hintText: 'Enter Email Address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            jsons[count]["email_address"] = val;
          },
          validator: (email) {
            if (email != null && EmailValidator.validate(email)) {
              return null;
            }
            return "Invalid email address";
          },
        ),
      ],
    );
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
                                    percent: 0.4,
                                    center: const Text(
                                      "1 of 2",
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
                                        "Submission Attendee",
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
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      color: Color.fromARGB(255, 219, 219, 219),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: columnDynamic,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20),
                          right: getProportionateScreenWidth(20)),
                      child: SizedBox(
                        height: getProportionateScreenHeight(50),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 0, 94, 172),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              )),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderReview(
                                    recordActivity: widget.recordActivity,
                                    selectDate: selectDate,
                                    currentSelected: widget.currentSelected,
                                    jsons: jsons,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Next',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
