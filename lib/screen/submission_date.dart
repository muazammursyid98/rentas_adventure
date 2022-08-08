import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/screen/form_attendee.dart';
import 'package:rentas_adventure/utils/size_config.dart';

import '../model/activity_model.dart';
import '../model/session_model.dart';
import '../provider/rest.dart';

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

  incrementPerson() {
    if (availableSlot == 0 && isActivityGotSlot == true) {
      return;
    }
    personToJoin++;
    availableSlot--;
    setState(() {});
  }

  decrementPerson() {
    if (personToJoin == 1) {
      return;
    }
    availableSlot++;
    personToJoin--;
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.white,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "PICK DATE",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          'Select a Date Time',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${selectDate!.toLocal()}".split(' ')[0],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
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
                      const Divider(height: 15, color: Colors.grey),
                      Text(
                        "TOTAL GUEST",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                              const Icon(Icons.person),
                              SizedBox(width: getProportionateScreenWidth(8)),
                              SizedBox(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Person",
                                      style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
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
                              const Expanded(child: SizedBox()),
                              InkWell(
                                onTap: () => decrementPerson(),
                                child: const Icon(
                                  Icons.arrow_circle_left_outlined,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                personToJoin.toString(),
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: () => incrementPerson(),
                                child: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 15, color: Colors.grey),
                      Text(
                        "CHOOSE SLOT",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: getProportionateScreenHeight(10)),
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
                                                left:
                                                    getProportionateScreenWidth(
                                                        50),
                                                right:
                                                    getProportionateScreenWidth(
                                                        50),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                  color: currentChoose ==
                                                          element.shiftId!
                                                      ? Colors.green
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              height:
                                                  getProportionateScreenHeight(
                                                      70),
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    element.shiftName!,
                                                    style: GoogleFonts.montserrat(
                                                        color: currentChoose ==
                                                                element.shiftId!
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "${element.startTime!} - ${element.endTime!}",
                                                    style: GoogleFonts.montserrat(
                                                        color: currentChoose ==
                                                                element.shiftId!
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            isActivityGotSlot == false
                                ? const SizedBox()
                                : Text(
                                    "Available Slot :",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                            isActivityGotSlot == false
                                ? const SizedBox()
                                : Text(
                                    availableSlot.toString() + " Left",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: getProportionateScreenHeight(50),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 209, 209, 209),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          )),
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'BACK',
                                        style: GoogleFonts.montserrat(
                                            color: const Color.fromARGB(
                                                255, 0, 94, 172),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: getProportionateScreenHeight(50),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 0, 94, 172),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          )),
                                      onPressed: () {
                                        if (currentChoose == 0) {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.BOTTOMSLIDE,
                                            dialogType: DialogType.WARNING,
                                            body: Center(
                                              child: Text(
                                                'Please select session time',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            title: '',
                                            desc: '',
                                            btnOkOnPress: () {},
                                          ).show();
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FormAttendeeScreen(
                                                recordActivity:
                                                    widget.recordActivity,
                                                selectDate: selectDate!,
                                                personToJoin: personToJoin,
                                                currentSelected:
                                                    currentSelected,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'NEXT',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
