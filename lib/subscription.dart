import 'package:deevot_new_project/razorpay_gateway.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'drawer_content.dart';
import 'main.dart';
import 'drawer_content.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => Subscription_State();
}

final _auth = FirebaseAuth.instance;
double screenHeight = 0.0;
double screenWidth = 0.0;

class Subscription_State extends State<Subscription> {
  bool isDrawerOpen = false;
  int selectedPlan = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        _scaffoldKey.currentState?.openEndDrawer(); // Open the drawer
      } else {
        Navigator.of(context).pop(); // Close the drawer
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPlan = -1;
  }

  void selectPlan(int index) {
    setState(() {
      selectedPlan = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff001F3F),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff352980),
                    Color(0xff604AE6),
                    Color(0xff352980),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            actions: [
              Container(
                // padding: EdgeInsets.only(
                //   left: (10 / 411.42857142857144) * screenWidth,
                // ), // Add some margin here
                margin: EdgeInsets.only(right: (237 / 360) * screenWidth),
                child: IconButton(
                  icon: Icon(
                    Icons.menu_sharp,
                    size: (30 / 784) * screenHeight,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _scaffoldKey.currentState?.openDrawer();
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: (25 / 360) * screenWidth),
                child: Image.asset(
                  "assets/images/app_bar_end_icon.png",
                ),
              ),
            ],
            // title: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     IconButton(
            //         color: Colors.white,
            //         // onPressed: () async {
            //         //   await FirebaseAuth.instance.signOut();
            //         //   clearChatData();
            //         //   Get.back();
            //         // },
            //         icon: const Icon(
            //           Icons.menu_rounded,
            //           size: 30,
            //         )),
            //     // Text(
            //     //   "Back",
            //     //   style: GoogleFonts.raleway(
            //     //       fontSize: (16 / 784) * screenHeight,
            //     //       color: Colors.white,
            //     //       fontWeight: FontWeight.w600),
            //     // ),
            //   ],
            // ),
          ),
          backgroundColor: Colors.white,
          drawer: Container(
            width: (240 / 360) * screenWidth,
            child: Drawer(
              child: DrawerContent(),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: (50 / 360) * screenWidth,
                    right: (50 / 360) * screenWidth,
                    top: (30 / 784) * screenHeight),
                child: Text(
                  'Get Premium',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.saira(
                    fontSize: (24 / 784) * screenHeight,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4600A9),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (16 / 360) * screenWidth,
                    right: (16 / 360) * screenWidth,
                    top: (30 / 784) * screenHeight),
                child: Text(
                  'Unlock all the power of this mobile tool and enjoy digital experience like never before!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.saira(
                    fontSize: (16 / 784) * screenHeight,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1B1B1B),
                  ),
                ),
              ),
              Container(
                child: Image(
                    image: AssetImage('assets/images/subscription_logo.png')),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        (20 / 360) * screenWidth,
                        (20 / 784) * screenHeight,
                        (20 / 360) * screenWidth,
                        (20 / 784) * screenHeight),
                    height: (70 / 784) * screenHeight,
                    width: (320 / 360) * screenWidth,
                    decoration: BoxDecoration(
                      color: Color(0xffF6D748).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        selectPlan(0);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text.rich(
                            textAlign: TextAlign.left,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Annual Plan\n',
                                  style: GoogleFonts.dmSans(
                                    fontSize: (18 / 784) * screenHeight,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Color(0xff334C65), // Color for "Annual"
                                  ),
                                ),
                                TextSpan(
                                  text: 'Just 949 per year',
                                  style: GoogleFonts.dmSans(
                                    fontSize: (16 / 784) * screenHeight,
                                    fontWeight: FontWeight.w400,
                                    color: Color(
                                        0xff1B1B1B), // Color for the text below
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfffffee0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(
                          color: selectedPlan == 0
                              ? Color(
                                  0xff4600A9) // Change border color as needed
                              : Colors
                                  .transparent, // Change border color as needed
                          width: selectedPlan == 0
                              ? 2.0
                              : 0, // Change border width as needed
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: (230 / 360) * screenWidth,
                        top: (30 / 784) * screenHeight),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the value as needed
                      color: Color(
                          0xff26CB63), // Change the color according to your design
                    ),
                    padding: EdgeInsets.only(
                      left: (15 / 360) * screenWidth,
                      right: (15 / 360) * screenWidth,
                      top: (7 / 784) * screenHeight,
                      bottom: (7 / 784) * screenHeight,
                    ), // Adjust padding as needed
                    child: Text(
                      'Best Value',
                      style: GoogleFonts.inter(
                        fontSize: (12 / 784) * screenHeight,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Color for "Annual"
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB((20 / 360) * screenWidth, 0,
                    (20 / 360) * screenWidth, (20 / 784) * screenHeight),
                height: (70 / 784) * screenHeight,
                width: (300 / 360) * screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xfffffee0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    selectPlan(1); // Select the plan
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Semi-Annual Plan\n',
                              style: GoogleFonts.dmSans(
                                fontSize: (18 / 784) * screenHeight,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff334C65), // Color for "Annual"
                              ),
                            ),
                            TextSpan(
                              text: 'Only 499 per 6 months',
                              style: GoogleFonts.dmSans(
                                fontSize: (16 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(
                                    0xff1B1B1B), // Color for the text below
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffffee0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: selectedPlan == 1
                          ? Color(0xff4600A9) // Change border color as needed
                          : Colors.transparent, // Change border color as needed
                      width: selectedPlan == 1
                          ? 2.0
                          : 0, // Change border width as needed
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB((20 / 360) * screenWidth, 0,
                    (20 / 360) * screenWidth, (20 / 784) * screenHeight),
                height: (70 / 784) * screenHeight,
                width: (300 / 360) * screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xffF6D748).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    selectPlan(2);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Monthly Plan\n',
                              style: GoogleFonts.dmSans(
                                fontSize: (18 / 784) * screenHeight,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff334C65), // Color for "Annual"
                              ),
                            ),
                            TextSpan(
                              text: 'Just 99 per month',
                              style: GoogleFonts.dmSans(
                                fontSize: (16 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(
                                    0xff1B1B1B), // Color for the text below
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffffee0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(
                      color: selectedPlan == 2
                          ? Color(0xff4600A9) // Change border color as needed
                          : Colors.transparent, // Change border color as needed
                      width: selectedPlan == 2
                          ? 2.0
                          : 0, // Change border width as needed
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                margin: EdgeInsets.only(
                    top: (15 / 784) * screenHeight,
                    left: (60 / 384) * screenWidth,
                    right: (60 / 384) * screenWidth),
                child: SizedBox(
                  height: (60 / 784) * screenHeight,
                  width: (211 / 384) * screenWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff4600A9),
                          Color(0xff001F7D),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RazorPayGateway(index: selectedPlan)),
                        );
                      },
                      child: Text(
                        selectedPlan == 0
                            ? 'Start Annual Plan'
                            : selectedPlan == 1
                                ? 'Start Semi-Annual Plan'
                                : selectedPlan == 2
                                    ? 'Start Monthly Plan'
                                    : 'Select a Plan',
                        style: GoogleFonts.dmSans(
                            fontSize: (18 / 784) * screenHeight,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffF9FFFF)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (20 / 360) * screenWidth,
                    right: (20 / 360) * screenWidth,
                    top: (20 / 784) * screenHeight),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By placing this order, you agree to the ',
                        style: GoogleFonts.dmSans(
                          fontSize: (12 / 784) * screenHeight,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1B1B1B), // Color for "Annual"
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Service ',
                        style: GoogleFonts.dmSans(
                          fontSize: (12 / 784) * screenHeight,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1B1B1B),
                        ),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: GoogleFonts.dmSans(
                          fontSize: (12 / 784) * screenHeight,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1B1B1B), // Color for "Annual"
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: GoogleFonts.dmSans(
                          fontSize: (12 / 784) * screenHeight,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1B1B1B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                    (40 / 411.42857142857144) * screenWidth,
                    (30 / 784) * screenHeight,
                    0,
                    (30 / 784) * screenHeight),
                padding: const EdgeInsets.all(1),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  iconSize: screenWidth * 0.08,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
