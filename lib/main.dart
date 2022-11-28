import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/provider/pdf_invoice_api.dart';
import 'package:rentas_adventure/provider/rest.dart';
import 'package:rentas_adventure/screen/submission_date.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'package:rentas_adventure/widget/badge_cart.dart';
import 'package:rentas_adventure/widget/question_answer.dart';
import 'package:rentas_adventure/widget/receipt.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_strategy/url_strategy.dart';
import 'model/activity_model.dart';
import 'dart:html';

import 'model/customer.dart';
import 'model/image_details_model.dart';
import 'model/invoice.dart';
import 'model/list_order.dart';
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
  List<ImageDetail>? listImageByActivity = [];
  List<ImageDetail>? listOfImageDetailsDisplay = [];

  String displayBackground = "";

  @override
  void initState() {
    super.initState();
    initCall();
  }

  initCall() async {
    Future.delayed(const Duration(seconds: 5), () async {
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
      //   var jsons = {
      //     "records": "success",
      //     "name": "asda@gmail.com",
      //     "phone_number": "123",
      //     "total_price": "20",
      //     "total_booked_slot": "1",
      //     "invoice_number": "Woq_5-6r6t",
      //     "emailCustomer": "muazammursyid@gmail.com",
      //     "message": "success",
      //     "reason": "successfully"
      //   };
      //   final jsonDecode = jsons;
      //   String customerName = jsonDecode["name"]!;
      //   String customerPhoneNumber = jsonDecode["phone_number"]!;
      //   String customerTotalPrice = jsonDecode["total_price"]!;
      //   String customerTotalBooked = jsonDecode["total_booked_slot"]!;
      //   String invoiceNumber = jsonDecode["invoice_number"]!;
      //   String emailCustomer = jsonDecode["emailCustomer"]!;

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
        final listOrder = listOrderFromJson(responseBody.body);
        String customerName = listOrder.name!;
        String customerPhoneNumber = listOrder.phoneNumber!;
        String customerTotalPrice = listOrder.totalPrice!;
        String invoiceNumber = listOrder.invoiceNumber!;
        // String emailCustomer = listOrder.emailCustomer!;
        String emailCustomer = "muazammursyid@gmail.com";
        generateInvoice(
          customerName: customerName,
          customerPhoneNumber: customerPhoneNumber,
          customerTotalPrice: customerTotalPrice,
          invoiceNumber: invoiceNumber,
          emailCustomer: emailCustomer,
          listOrder: listOrder,
        );
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
        ).show().then((value) => showDialog(
            context: context,
            builder: (_) {
              return ReceiptDisplay(
                listOrder: listOrder,
              );
            }));
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
      callApiAllImageActivity();
    });
  }

  callApiAllImageActivity() {
    var jsons = {"authKey": "key123"};
    HttpAuth.postApi(jsons: jsons, url: 'get_all_image_activity.php')
        .then((value) {
      final imageDetails = imageDetailsFromJson(value.body);
      listImageByActivity = imageDetails.imageDetails!;
      List<ImageDetail>? listOfImageDetails = listImageByActivity!
          .where(
            (element) => element.activitiesId == listOfActivity[0].activityId,
          )
          .toList();
      listOfImageDetailsDisplay = listOfImageDetails;
      isSplashShow = false;
      isLoading = false;
      setState(() {});
    });
  }

  generateInvoice({
    customerName,
    customerPhoneNumber,
    customerTotalPrice,
    invoiceNumber,
    emailCustomer,
    ListOrder? listOrder,
  }) async {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    final invoice = Invoice(
      supplier: Supplier(
        name: customerName,
        address: customerPhoneNumber,
        paymentInfo: 'https://rentasadventures.com/ticket/',
      ),
      customer: const Customer(
        name: 'Adren x Park Tickets',
        address:
            'Yellow Cabin, Jalan 55, KKB - Fraser, 44000\nKuala Kubu Baru, Selangor',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: '',
        number: invoiceNumber,
      ),
      items: [
        ...listOrder!.listOrder!.map((ListOrderElement element) {
          return InvoiceItem(
            description: '${element.activityName}\n(${element.shiftName})',
            date: DateTime.parse(element.bookedDate!),
            quantity: int.parse(element.totalBookedSlot!),
            vat: 0,
            unitPrice: double.parse(element.totalPrice!) /
                double.parse(element.totalBookedSlot!),
          );
        }).toList(),
      ],
    );

    final pdfFileBase64 = await PdfInvoiceApi.generate(invoice);
    // debugPrint('pdfFile: $pdfFileBase64');
    // final anchor = AnchorElement(
    //     href: "data:application/octet-stream;charset=utf-16le;base64,$pdfFile")
    //   ..setAttribute("download", "$invoiceNumber.pdf")
    //   ..click();

    emailToCustomer(
      pdfFileBase64,
      invoiceNumber,
      emailCustomer,
      customerName,
    );
    // PdfApi.openFile(pdfFile);
  }

  emailToCustomer(
      pdfFileBase64, invoiceNumber, emailCustomer, customerName) async {
    var jsons = {
      "authKey": "key123",
      "base64Pdf": pdfFileBase64,
      "invoiceNumber": invoiceNumber,
      "emailCustomer": emailCustomer,
      "nameCustomer": customerName
    };
    debugPrint('movieTitle: $jsons');
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
          decoration: displayBackground == ""
              ? BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                      "assets/images/quadbike_jungle_tour.jpeg",
                    ),
                    fit: MediaQuery.of(context).size.width >= 900
                        ? BoxFit.fill
                        : BoxFit.cover,
                  ),
                )
              : BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://rentasadventures.com/listActivityAsset/$displayBackground",
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
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 35.h,
            left: 10.w,
            child: Image.asset(
              'assets/icons/left-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 35.h,
            right: 10.w,
            child: Image.asset(
              'assets/icons/right-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(onPageChanged: ((index, reason) {
            displayBackground = listOfActivity[index].activityAsset!;
            List<ImageDetail>? listOfImageDetails = listImageByActivity!
                .where(
                  (element) =>
                      element.activitiesId == listOfActivity[index].activityId,
                )
                .toList();
            listOfImageDetailsDisplay = listOfImageDetails;
            setState(() {});
          })),
          items: [
            ...listOfActivity.map(
              (itemActivity) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(top: 60, bottom: 60),
                        width: 800,
                        height: 1000,
                        color: Colors.white,
                        child: SingleChildScrollView(
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
                                    ...listOfImageDetailsDisplay!.map(
                                      (item) {
                                        var index = listOfImageDetailsDisplay!
                                                .indexOf(item) +
                                            1;
                                        return Stack(
                                          children: [
                                            Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      250),
                                              margin: EdgeInsets.only(
                                                left:
                                                    getProportionateScreenWidth(
                                                        10),
                                                right:
                                                    getProportionateScreenWidth(
                                                        10),
                                              ),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      'https://rentasadventures.com/listActivityAsset/${item.imageName}'),
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(5.0),
                                                  topLeft: Radius.circular(5.0),
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(5.0),
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
                                                    Text(
                                                        listOfImageDetailsDisplay!
                                                            .length
                                                            .toString())
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      itemActivity.activityName!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 80, right: 80),
                                      child: Center(
                                        child: HtmlWidget(
                                          // the first parameter (`html`) is required
                                          itemActivity.shortDescription!,

                                          // all other parameters are optional, a few notable params:

                                          // specify custom styling for an element
                                          // see supported inline styling below
                                          customStylesBuilder: (element) {
                                            if (element.classes
                                                .contains('foo')) {
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
                                          onErrorBuilder: (context, element,
                                                  error) =>
                                              Text('$element error: $error'),
                                          onLoadingBuilder: (context, element,
                                                  loadingProgress) =>
                                              CircularProgressIndicator(),

                                          // this callback will be triggered when user taps a link

                                          // select the render mode for HTML body
                                          // by default, a simple `Column` is rendered
                                          // consider using `ListView` or `SliverList` for better performance
                                          renderMode: RenderMode.column,

                                          // set the default styling for text
                                          textStyle: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    itemActivity.packageIclusive == ""
                                        ? const SizedBox()
                                        : Column(
                                            children: [
                                              const Divider(
                                                  height: 15,
                                                  color: Colors.grey),
                                              SizedBox(height: 2.h),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      HtmlWidget(
                                                        // the first parameter (`html`) is required
                                                        itemActivity
                                                            .packageIclusive!,

                                                        // all other parameters are optional, a few notable params:

                                                        // specify custom styling for an element
                                                        // see supported inline styling below
                                                        customStylesBuilder:
                                                            (element) {
                                                          if (element.classes
                                                              .contains(
                                                                  'foo')) {
                                                            return {
                                                              'color': 'red'
                                                            };
                                                          }

                                                          return null;
                                                        },

                                                        // render a custom widget
                                                        customWidgetBuilder:
                                                            (element) {
                                                          return null;
                                                        },

                                                        // these callbacks are called when a complicated element is loading
                                                        // or failed to render allowing the app to render progress indicator
                                                        // and fallback widget
                                                        onErrorBuilder: (context,
                                                                element,
                                                                error) =>
                                                            Text(
                                                                '$element error: $error'),
                                                        onLoadingBuilder: (context,
                                                                element,
                                                                loadingProgress) =>
                                                            CircularProgressIndicator(),

                                                        // this callback will be triggered when user taps a link

                                                        // select the render mode for HTML body
                                                        // by default, a simple `Column` is rendered
                                                        // consider using `ListView` or `SliverList` for better performance
                                                        renderMode:
                                                            RenderMode.column,

                                                        // set the default styling for text
                                                        textStyle: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/Pin.png',
                                          color: Colors.black,
                                          height: 2.5.h,
                                        ),
                                        Text(
                                          itemActivity.activityLocation ?? '',
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
                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      height: 60,
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubmissionDate(
                                                recordActivity: itemActivity,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          // fixedSize: Size(250, 50),
                                        ),
                                        child: const Text(
                                          "Details",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
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
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 45.h,
            left: 5.w,
            child: Image.asset(
              'assets/icons/left-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 45.h,
            right: 5.w,
            child: Image.asset(
              'assets/icons/right-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(10.h),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1 / 2,
              viewportFraction: 1,
              onPageChanged: ((index, reason) {
                displayBackground = listOfActivity[index].activityAsset!;
                List<ImageDetail>? listOfImageDetails = listImageByActivity!
                    .where(
                      (element) =>
                          element.activitiesId ==
                          listOfActivity[index].activityId,
                    )
                    .toList();
                listOfImageDetailsDisplay = listOfImageDetails;
                setState(() {});
              }),
            ),
            items: [
              ...listOfActivity.map(
                (itemActivity) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 60, bottom: 60),
                          width: 800,
                          height: 1000,
                          color: Colors.white,
                          child: SingleChildScrollView(
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
                                      ...listOfImageDetailsDisplay!.map(
                                        (item) {
                                          var index = listOfImageDetailsDisplay!
                                                  .indexOf(item) +
                                              1;
                                          return Stack(
                                            children: [
                                              Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        250),
                                                margin: EdgeInsets.only(
                                                  left:
                                                      getProportionateScreenWidth(
                                                          10),
                                                  right:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        'https://rentasadventures.com/listActivityAsset/${item.imageName}'),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
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
                                                      Text(
                                                          listOfImageDetailsDisplay!
                                                              .length
                                                              .toString())
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        itemActivity.activityName!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, right: 80),
                                        child: Center(
                                          child: HtmlWidget(
                                            // the first parameter (`html`) is required
                                            itemActivity.shortDescription!,

                                            // all other parameters are optional, a few notable params:

                                            // specify custom styling for an element
                                            // see supported inline styling below
                                            customStylesBuilder: (element) {
                                              if (element.classes
                                                  .contains('foo')) {
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
                                            onErrorBuilder: (context, element,
                                                    error) =>
                                                Text('$element error: $error'),
                                            onLoadingBuilder: (context, element,
                                                    loadingProgress) =>
                                                CircularProgressIndicator(),

                                            // this callback will be triggered when user taps a link

                                            // select the render mode for HTML body
                                            // by default, a simple `Column` is rendered
                                            // consider using `ListView` or `SliverList` for better performance
                                            renderMode: RenderMode.column,

                                            // set the default styling for text
                                            textStyle: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      itemActivity.packageIclusive == ""
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                const Divider(
                                                    height: 15,
                                                    color: Colors.grey),
                                                SizedBox(height: 2.h),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        HtmlWidget(
                                                          // the first parameter (`html`) is required
                                                          itemActivity
                                                              .packageIclusive!,

                                                          // all other parameters are optional, a few notable params:

                                                          // specify custom styling for an element
                                                          // see supported inline styling below
                                                          customStylesBuilder:
                                                              (element) {
                                                            if (element.classes
                                                                .contains(
                                                                    'foo')) {
                                                              return {
                                                                'color': 'red'
                                                              };
                                                            }

                                                            return null;
                                                          },

                                                          // render a custom widget
                                                          customWidgetBuilder:
                                                              (element) {
                                                            return null;
                                                          },

                                                          // these callbacks are called when a complicated element is loading
                                                          // or failed to render allowing the app to render progress indicator
                                                          // and fallback widget
                                                          onErrorBuilder: (context,
                                                                  element,
                                                                  error) =>
                                                              Text(
                                                                  '$element error: $error'),
                                                          onLoadingBuilder: (context,
                                                                  element,
                                                                  loadingProgress) =>
                                                              CircularProgressIndicator(),

                                                          // this callback will be triggered when user taps a link

                                                          // select the render mode for HTML body
                                                          // by default, a simple `Column` is rendered
                                                          // consider using `ListView` or `SliverList` for better performance
                                                          renderMode:
                                                              RenderMode.column,

                                                          // set the default styling for text
                                                          textStyle: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/Pin.png',
                                            color: Colors.black,
                                            height: 2.5.h,
                                          ),
                                          Text(
                                            itemActivity.activityLocation ?? '',
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
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height: 60,
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SubmissionDate(
                                                  recordActivity: itemActivity,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            // fixedSize: Size(250, 50),
                                          ),
                                          child: const Text(
                                            "Details",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
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
        Visibility(
          visible: isSplashShow,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Image.asset('assets/animation/Adren-logo.gif'),
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 45.h,
            left: 2.w,
            child: Image.asset(
              'assets/icons/left-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        Visibility(
          visible: !isSplashShow,
          child: Positioned(
            top: 45.h,
            right: 2.w,
            child: Image.asset(
              'assets/icons/right-arrow.png',
              color: Colors.white,
              height: 5.h,
              width: 5.w,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(5.h),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1 / 2,
              viewportFraction: 1,
              onPageChanged: ((index, reason) {
                displayBackground = listOfActivity[index].activityAsset!;
                List<ImageDetail>? listOfImageDetails = listImageByActivity!
                    .where(
                      (element) =>
                          element.activitiesId ==
                          listOfActivity[index].activityId,
                    )
                    .toList();
                listOfImageDetailsDisplay = listOfImageDetails;
                setState(() {});
              }),
            ),
            items: [
              ...listOfActivity.map(
                (itemActivity) {
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 60, bottom: 60),
                          width: 800,
                          height: 1000,
                          color: Colors.white,
                          child: SingleChildScrollView(
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
                                      ...listOfImageDetailsDisplay!.map(
                                        (item) {
                                          var index = listOfImageDetailsDisplay!
                                                  .indexOf(item) +
                                              1;
                                          return Stack(
                                            children: [
                                              Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        250),
                                                margin: EdgeInsets.only(
                                                  left:
                                                      getProportionateScreenWidth(
                                                          10),
                                                  right:
                                                      getProportionateScreenWidth(
                                                          10),
                                                ),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        'https://rentasadventures.com/listActivityAsset/${item.imageName}'),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                  color: Colors.black,
                                                ),
                                                width: double.infinity,
                                              ),
                                              Positioned(
                                                left: 10,
                                                bottom: 5,
                                                child: Badge(
                                                  badgeColor: Colors.white,
                                                  badgeContent: Row(
                                                    children: [
                                                      Text(index.toString()),
                                                      const Text("/"),
                                                      Text(
                                                          listOfImageDetailsDisplay!
                                                              .length
                                                              .toString())
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        itemActivity.activityName!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, right: 80),
                                        child: Center(
                                          child: HtmlWidget(
                                            // the first parameter (`html`) is required
                                            itemActivity.shortDescription!,

                                            // all other parameters are optional, a few notable params:

                                            // specify custom styling for an element
                                            // see supported inline styling below
                                            customStylesBuilder: (element) {
                                              if (element.classes
                                                  .contains('foo')) {
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
                                            onErrorBuilder: (context, element,
                                                    error) =>
                                                Text('$element error: $error'),
                                            onLoadingBuilder: (context, element,
                                                    loadingProgress) =>
                                                CircularProgressIndicator(),

                                            // this callback will be triggered when user taps a link

                                            // select the render mode for HTML body
                                            // by default, a simple `Column` is rendered
                                            // consider using `ListView` or `SliverList` for better performance
                                            renderMode: RenderMode.column,

                                            // set the default styling for text
                                            textStyle: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      itemActivity.packageIclusive == ""
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                const Divider(
                                                    height: 15,
                                                    color: Colors.grey),
                                                SizedBox(height: 2.h),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        HtmlWidget(
                                                          // the first parameter (`html`) is required
                                                          itemActivity
                                                              .packageIclusive!,

                                                          // all other parameters are optional, a few notable params:

                                                          // specify custom styling for an element
                                                          // see supported inline styling below
                                                          customStylesBuilder:
                                                              (element) {
                                                            if (element.classes
                                                                .contains(
                                                                    'foo')) {
                                                              return {
                                                                'color': 'red'
                                                              };
                                                            }

                                                            return null;
                                                          },

                                                          // render a custom widget
                                                          customWidgetBuilder:
                                                              (element) {
                                                            return null;
                                                          },

                                                          // these callbacks are called when a complicated element is loading
                                                          // or failed to render allowing the app to render progress indicator
                                                          // and fallback widget
                                                          onErrorBuilder: (context,
                                                                  element,
                                                                  error) =>
                                                              Text(
                                                                  '$element error: $error'),
                                                          onLoadingBuilder: (context,
                                                                  element,
                                                                  loadingProgress) =>
                                                              CircularProgressIndicator(),

                                                          // this callback will be triggered when user taps a link

                                                          // select the render mode for HTML body
                                                          // by default, a simple `Column` is rendered
                                                          // consider using `ListView` or `SliverList` for better performance
                                                          renderMode:
                                                              RenderMode.column,

                                                          // set the default styling for text
                                                          textStyle: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/Pin.png',
                                            color: Colors.black,
                                            height: 2.5.h,
                                          ),
                                          Text(
                                            itemActivity.activityLocation ?? '',
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
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(20),
                                      ),
                                      Container(
                                        width: getProportionateScreenWidth(200),
                                        height: 60,
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SubmissionDate(
                                                  recordActivity: itemActivity,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            // fixedSize: Size(250, 50),
                                          ),
                                          child: const Text(
                                            "Details",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
