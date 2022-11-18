import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/provider/pdf_invoice_api.dart';
import 'package:rentas_adventure/provider/rest.dart';
import 'package:rentas_adventure/screen/submission_date.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:rentas_adventure/widget/badge_cart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_strategy/url_strategy.dart';
import 'model/activity_model.dart';
import 'dart:html';

import 'model/customer.dart';
import 'model/invoice.dart';
import 'model/supplier.dart';

void main() {
  setPathUrlStrategy();
  // WebView.platform = WebWebViewPlatform();
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;

  var uniqueId = params['unique_id'];
  var statusId = params['status_id'];
  var billcode = params['billcode'];
  var orderId = params['order_id'];
  var msg = params['msg'];
  var transactionId = params['transaction_id'];
  runApp(MyApp(
    uniqueId: uniqueId ?? '',
    statusId: statusId ?? '',
    billcode: billcode ?? '',
    orderId: orderId ?? '',
    msg: msg ?? '',
    transactionId: transactionId ?? '',
  ));
}

class MyApp extends StatelessWidget {
  final String uniqueId;
  final String statusId;
  final String billcode;
  final String orderId;
  final String msg;
  final String transactionId;

  const MyApp({
    Key? key,
    required this.uniqueId,
    required this.statusId,
    required this.billcode,
    required this.orderId,
    required this.msg,
    required this.transactionId,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adren x Park Tickets',
        initialRoute: '/',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          uniqueId: uniqueId,
          statusId: statusId,
          billcode: billcode,
          orderId: orderId,
          msg: msg,
          transactionId: transactionId,
        ),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  final String uniqueId;
  final String statusId;
  final String billcode;
  final String orderId;
  final String msg;
  final String transactionId;

  const MyHomePage({
    Key? key,
    required this.uniqueId,
    required this.statusId,
    required this.billcode,
    required this.orderId,
    required this.msg,
    required this.transactionId,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _controller = PageController(initialPage: 0);

  bool isSplashShow = true;
  bool isLoading = false;

  List<Record> listOfActivity = [];

  @override
  void initState() {
    super.initState();
    initCall();
  }

  initCall() async {
    Future.delayed(const Duration(seconds: 5), () async {
      isSplashShow = false;
      isLoading = true;
      setState(() {});
      callApi();
      widget.statusId != "" ? await callApiPayment() : null;
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

  Future callApiPayment() async {
    if (widget.statusId != "") {
      var jsons = {
        "authKey": "key123",
        "billCode": widget.billcode,
        "orderId": widget.orderId,
        "transactionCode": widget.transactionId,
        "msg": widget.msg,
        "temporaryUnique": widget.uniqueId,
        "status_id": widget.statusId,
      };
      var responseBody =
          await HttpAuth.postApi(jsons: jsons, url: 'get_temporary_id.php');

      if (widget.statusId == "1") {
        final jsonDecode = json.decode(responseBody.body);
        String customerName = jsonDecode["name"];
        String customerPhoneNumber = jsonDecode["phone_number"];
        String customerTotalPrice = jsonDecode["total_price"];
        String customerTotalBooked = jsonDecode["total_booked_slot"];
        String invoiceNumber = jsonDecode["invoice_number"];
        String emailCustomer = jsonDecode["emailCustomer"];
        generateInvoice(customerName, customerPhoneNumber, customerTotalPrice,
            customerTotalBooked, invoiceNumber, emailCustomer);
        AwesomeDialog(
          width: checkConditionWidth(),
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
          btnOkOnPress: () {},
        ).show();
      } else {
        AwesomeDialog(
          width: checkConditionWidth(),
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
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  callApi() {
    var jsons = {"authKey": "key123"};
    HttpAuth.postApi(jsons: jsons, url: 'getlistactivity.php').then((value) {
      final activity = activityFromJson(value.body);
      listOfActivity = activity.records!;
      isLoading = false;
      setState(() {});
    });
  }

  generateInvoice(customerName, customerPhoneNumber, customerTotalPrice,
      customerTotalBooked, invoiceNumber, emailCustomer) async {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: customerName,
        address: customerPhoneNumber,
        paymentInfo: 'https://rentasadventures.com/flutter/',
      ),
      customer: const Customer(
        name: 'Adren x Park Tickets',
        address:
            'Yellow Cabin, Jalan 55, KKB - Fraser, 44000\nKuala Kubu Baru, Selangor',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'My description...',
        number: invoiceNumber,
      ),
      items: [
        InvoiceItem(
          description: 'Adult',
          date: DateTime.now(),
          quantity: int.parse(customerTotalBooked),
          vat: 0,
          unitPrice: 200.00,
        ),
      ],
    );

    final pdfFileBase64 = await PdfInvoiceApi.generate(invoice);
    debugPrint('pdfFile: $pdfFileBase64');
    // final anchor = AnchorElement(
    //     href: "data:application/octet-stream;charset=utf-16le;base64,$pdfFile")
    //   ..setAttribute("download", "$invoiceNumber.pdf")
    //   ..click();

    emailToCustomer(
      pdfFileBase64,
      invoiceNumber,
      emailCustomer,
    );
    // PdfApi.openFile(pdfFile);
  }

  emailToCustomer(pdfFileBase64, invoiceNumber, emailCustomer) async {
    var jsons = {
      "authKey": "key123",
      "base64Pdf": pdfFileBase64,
      "invoiceNumber": invoiceNumber,
      "emailCustomer": emailCustomer,
    };
    await HttpAuth.postApi(jsons: jsons, url: 'email/index.php')
        .then((value) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
                  : BoxFit.cover,
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
              : checkConditionPhone(),
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
      return functionForViewWeb();
    } else {
      switch (Device.screenType) {
        case ScreenType.mobile:
          return functionForViewPhone();
        default:
          return functionForViewTablet();
      }
    }
  }

  Widget functionForViewWeb() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: 35.h,
          left: 10.w,
          child: Image.asset(
            'assets/icons/left-arrow.png',
            color: Colors.white,
            height: 4.h,
            width: 4.w,
          ),
        ),
        Positioned(
          top: 35.h,
          right: 10.w,
          child: Image.asset(
            'assets/icons/right-arrow.png',
            color: Colors.white,
            height: 4.h,
            width: 4.w,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: !isSplashShow,
            child: Container(
              margin: const EdgeInsets.only(top: 60, bottom: 60),
              width: 800,
              height: 1000,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0.h,
                  ),
                  CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 8 / 3,
                        viewportFraction: 1,
                      ),
                      items: [
                        ...listOfActivity.map(
                          (item) {
                            var index = listOfActivity.indexOf(item) + 1;
                            return Stack(
                              children: [
                                Container(
                                  height: getProportionateScreenHeight(250),
                                  margin: EdgeInsets.only(
                                    left: getProportionateScreenWidth(10),
                                    right: getProportionateScreenWidth(10),
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          'https://rentasadventures.com/listActivityAsset/${item.activityAsset}'),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    color: Colors.black,
                                  ),
                                  width: double.infinity,
                                ),
                                Positioned(
                                  left: 50,
                                  bottom: 40,
                                  child: Badge(
                                    badgeColor: Colors.white,
                                    badgeContent: Row(
                                      children: [
                                        Text(index.toString()),
                                        const Text("/"),
                                        Text(listOfActivity.length.toString())
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ]),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Container(
                    // margin: EdgeInsets.only(
                    //   top: getProportionateScreenHeight(130),
                    //   left: MediaQuery.of(context).size.width >= 900
                    //       ? getProportionateScreenWidth(60)
                    //       : getProportionateScreenWidth(40),
                    //   right: MediaQuery.of(context).size.width >= 900
                    //       ? getProportionateScreenWidth(60)
                    //       : getProportionateScreenWidth(40),
                    // ),
                    // height: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: getProportionateScreenWidth(5)),
                            // Image.asset(
                            //   'assets/icons/left-arrow.png',
                            //   color: Colors.black,
                            //   height: 4.h,
                            //   width: 4.w,
                            // ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    listOfActivity[0].activityName!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: getProportionateScreenHeight(10)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/Pin.png',
                                        color: Colors.black,
                                        height: 2.5.h,
                                      ),
                                      Text(
                                        listOfActivity[0].activityLocation ??
                                            '',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Image.asset(
                            //   'assets/icons/right-arrow.png',
                            //   color: Colors.black,
                            //   height: 4.h,
                            //   width: 4.w,
                            // ),
                            SizedBox(
                              width: getProportionateScreenWidth(5),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(40),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(60),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubmissionDate(
                                    recordActivity: listOfActivity[0],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.red,
                              child: Center(
                                child: Text(
                                  'Details',
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(40),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
      ],
    );
  }

  // Widget functionForViewWeb() {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: Alignment.center,
  //         child: Visibility(
  //           visible: !isSplashShow,
  //           child: CarouselSlider(
  //             options: CarouselOptions(
  //               aspectRatio: 4 / 3,
  //               viewportFraction: 1,
  //             ),
  //             items: listOfActivity.map((item) {
  //               return Stack(
  //                 children: [
  //                   Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 5.0.h,
  //                       ),
  //                       Expanded(
  //                         child: Container(
  //                           margin: EdgeInsets.only(
  //                             top: getProportionateScreenHeight(130),
  //                             left: MediaQuery.of(context).size.width >= 900
  //                                 ? getProportionateScreenWidth(60)
  //                                 : getProportionateScreenWidth(40),
  //                             right: MediaQuery.of(context).size.width >= 900
  //                                 ? getProportionateScreenWidth(60)
  //                                 : getProportionateScreenWidth(40),
  //                           ),
  //                           height: getProportionateScreenHeight(500),
  //                           decoration: const BoxDecoration(
  //                             borderRadius: BorderRadius.only(
  //                               topRight: Radius.circular(10.0),
  //                               topLeft: Radius.circular(10.0),
  //                               bottomLeft: Radius.circular(10.0),
  //                               bottomRight: Radius.circular(10.0),
  //                             ),
  //                             color: Colors.white,
  //                           ),
  //                           width: double.infinity,
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             crossAxisAlignment: CrossAxisAlignment.end,
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   SizedBox(
  //                                       width: getProportionateScreenWidth(5)),
  //                                   Image.asset(
  //                                     'assets/icons/left-arrow.png',
  //                                     color: Colors.black,
  //                                     height: 4.h,
  //                                     width: 4.w,
  //                                   ),
  //                                   Expanded(
  //                                     child: Column(
  //                                       children: [
  //                                         Text(
  //                                           item.activityName!,
  //                                           textAlign: TextAlign.center,
  //                                           style: GoogleFonts.montserrat(
  //                                             textStyle: TextStyle(
  //                                               color: Colors.black,
  //                                               fontWeight: FontWeight.bold,
  //                                               fontSize: 16.sp,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                             height:
  //                                                 getProportionateScreenHeight(
  //                                                     10)),
  //                                         Row(
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.center,
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.center,
  //                                           children: [
  //                                             Image.asset(
  //                                               'assets/icons/Pin.png',
  //                                               color: Colors.black,
  //                                               height: 2.5.h,
  //                                             ),
  //                                             Text(
  //                                               item.activityLocation ?? '',
  //                                               textAlign: TextAlign.center,
  //                                               style: GoogleFonts.montserrat(
  //                                                 textStyle: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontWeight:
  //                                                       FontWeight.normal,
  //                                                   fontSize: 12.sp,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   Image.asset(
  //                                     'assets/icons/right-arrow.png',
  //                                     color: Colors.black,
  //                                     height: 4.h,
  //                                     width: 4.w,
  //                                   ),
  //                                   SizedBox(
  //                                     width: getProportionateScreenWidth(5),
  //                                   ),
  //                                 ],
  //                               ),
  //                               SizedBox(
  //                                 height: getProportionateScreenHeight(40),
  //                               ),
  //                               SizedBox(
  //                                 height: getProportionateScreenHeight(60),
  //                                 width: double.infinity,
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                         builder: (context) => SubmissionDate(
  //                                           recordActivity: item,
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                   child: Container(
  //                                     color: Colors.red,
  //                                     child: Center(
  //                                       child: Text(
  //                                         'Details',
  //                                         style: GoogleFonts.montserrat(
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.white,
  //                                           fontSize: 14.sp,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: getProportionateScreenHeight(40),
  //                       ),
  //                     ],
  //                   ),
  //                   Container(
  //                     height: getProportionateScreenHeight(400),
  //                     margin: EdgeInsets.only(
  //                       top: getProportionateScreenHeight(80),
  //                       left: MediaQuery.of(context).size.width >= 900
  //                           ? getProportionateScreenWidth(80)
  //                           : getProportionateScreenWidth(60),
  //                       right: MediaQuery.of(context).size.width >= 900
  //                           ? getProportionateScreenWidth(80)
  //                           : getProportionateScreenWidth(60),
  //                     ),
  //                     decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                         fit: BoxFit.cover,
  //                         image: NetworkImage(
  //                             'https://rentasadventures.com/listActivityAsset/${item.activityAsset}'),
  //                       ),
  //                       borderRadius: const BorderRadius.only(
  //                         topRight: Radius.circular(5.0),
  //                         topLeft: Radius.circular(5.0),
  //                         bottomLeft: Radius.circular(5.0),
  //                         bottomRight: Radius.circular(5.0),
  //                       ),
  //                       color: Colors.black,
  //                     ),
  //                     width: double.infinity,
  //                   ),
  //                 ],
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ),
  //       Visibility(
  //         visible: isSplashShow,
  //         child: Container(
  //           margin: const EdgeInsets.all(20),
  //           child: Center(
  //             child: Image.asset('assets/animation/Adren-logo.gif'),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget functionForViewTablet() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: !isSplashShow,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: width / height,
                viewportFraction: 1,
              ),
              items: listOfActivity.map((item) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(130),
                              left: 15.w,
                              right: 15.w,
                            ),
                            height: getProportionateScreenHeight(500),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: getProportionateScreenWidth(5)),
                                    Image.asset(
                                      'assets/icons/left-arrow.png',
                                      color: Colors.black,
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            item.activityName!,
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
                                              height:
                                                  getProportionateScreenHeight(
                                                      10)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/Pin.png',
                                                color: Colors.black,
                                                height: 3.5.h,
                                              ),
                                              Text(
                                                item.activityLocation ?? '',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/right-arrow.png',
                                      color: Colors.black,
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(5),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(40),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(60),
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubmissionDate(
                                            recordActivity: item,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.red,
                                      child: Center(
                                        child: Text(
                                          'Details',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(40),
                        ),
                      ],
                    ),
                    Container(
                      height: getProportionateScreenHeight(400),
                      margin: EdgeInsets.only(
                          top: getProportionateScreenHeight(80),
                          left: getProportionateScreenWidth(80),
                          right: getProportionateScreenWidth(80)),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://rentasadventures.com/listActivityAsset/${item.activityAsset}'),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        color: Colors.black,
                      ),
                      width: double.infinity,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
      ],
    );
  }

  Widget functionForViewPhone() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Visibility(
            visible: !isSplashShow,
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: width / height,
                viewportFraction: 1,
              ),
              items: listOfActivity.map((item) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(130),
                              left: MediaQuery.of(context).size.width >= 900
                                  ? getProportionateScreenWidth(60)
                                  : getProportionateScreenWidth(40),
                              right: MediaQuery.of(context).size.width >= 900
                                  ? getProportionateScreenWidth(60)
                                  : getProportionateScreenWidth(40),
                            ),
                            height: getProportionateScreenHeight(500),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: getProportionateScreenWidth(5)),
                                    Image.asset(
                                      'assets/icons/left-arrow.png',
                                      color: Colors.black,
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            item.activityName!,
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
                                              height:
                                                  getProportionateScreenHeight(
                                                      10)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/Pin.png',
                                                color: Colors.black,
                                                height: 3.5.h,
                                              ),
                                              Text(
                                                item.activityLocation ?? '',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/icons/right-arrow.png',
                                      color: Colors.black,
                                      height: 7.h,
                                      width: 7.w,
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(5),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(40),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(60),
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubmissionDate(
                                            recordActivity: item,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.red,
                                      child: Center(
                                        child: Text(
                                          'Details',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(40),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width >= 1200
                          ? getProportionateScreenHeight(480)
                          : MediaQuery.of(context).size.width >= 900
                              ? getProportionateScreenHeight(300)
                              : getProportionateScreenHeight(340),
                      margin: EdgeInsets.only(
                        top: getProportionateScreenHeight(80),
                        left: MediaQuery.of(context).size.width >= 900
                            ? getProportionateScreenWidth(80)
                            : getProportionateScreenWidth(60),
                        right: MediaQuery.of(context).size.width >= 900
                            ? getProportionateScreenWidth(80)
                            : getProportionateScreenWidth(60),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://rentasadventures.com/listActivityAsset/${item.activityAsset}'),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                        ),
                        color: Colors.black,
                      ),
                      width: double.infinity,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
      ],
    );
  }
}
