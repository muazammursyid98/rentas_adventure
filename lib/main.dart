import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/provider/rest.dart';
import 'package:rentas_adventure/screen/submission_date.dart';
import 'package:rentas_adventure/utils/size_config.dart';
import 'model/activity_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rentas Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
    Future.delayed(const Duration(seconds: 5), () {
      isSplashShow = false;
      isLoading = true;
      setState(() {});
      callApi();
    });
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: !isSplashShow,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio:
                                MediaQuery.of(context).size.width >= 900
                                    ? 4 / 3
                                    : width / height,
                            viewportFraction: 1,
                          ),
                          items: listOfActivity.map((item) {
                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(40),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            getProportionateScreenHeight(700),
                                        width: double.infinity,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: getProportionateScreenHeight(
                                                130),
                                            left:
                                                getProportionateScreenWidth(40),
                                            right:
                                                getProportionateScreenWidth(40),
                                          ),
                                          height:
                                              getProportionateScreenHeight(500),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                            ),
                                            color: Colors.white,
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Spacer(),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          width:
                                                              getProportionateScreenWidth(
                                                                  5)),
                                                      Image.asset(
                                                          'assets/icons/left-arrow.png',
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  40),
                                                          width:
                                                              getProportionateScreenWidth(
                                                                  40)),
                                                      Flexible(
                                                        fit: FlexFit.loose,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              item.activityName!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/icons/Pin.png',
                                                                  color: Colors
                                                                      .black,
                                                                  height:
                                                                      getProportionateScreenHeight(
                                                                          20),
                                                                ),
                                                                Text(
                                                                  item.activityLocation ??
                                                                      '',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          14,
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
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  40),
                                                          width:
                                                              getProportionateScreenWidth(
                                                                  40)),
                                                      SizedBox(
                                                          width:
                                                              getProportionateScreenWidth(
                                                                  5)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          50)),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        60),
                                                width: double.infinity,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            SubmissionDate(
                                                          recordActivity: item,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    color: Colors.red,
                                                    child: Center(
                                                      child: Text(
                                                        'LET\'S GO',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(40),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: getProportionateScreenHeight(340),
                                  margin: EdgeInsets.only(
                                    top: getProportionateScreenHeight(80),
                                    left: getProportionateScreenWidth(60),
                                    right: getProportionateScreenWidth(60),
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/${item.activityAsset}'),
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
                        margin: EdgeInsets.all(20),
                        child: Center(
                          child: Image.asset('assets/animation/Adren-logo.gif'),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
