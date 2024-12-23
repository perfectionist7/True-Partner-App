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
class Help_Screen extends StatefulWidget {
  const Help_Screen({Key? key}) : super(key: key);

  @override
  State<Help_Screen> createState() => _Help_ScreenState();
}

final _auth = FirebaseAuth.instance;
double screenHeight = 0.0;
double screenWidth = 0.0;

class _Help_ScreenState extends State<Help_Screen> {
  bool isDrawerOpen = false;
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
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xffe6f0ff),
            toolbarHeight: 70,
            actions: [
              Container(
                // padding: EdgeInsets.only(
                //   left: (10 / 411.42857142857144) * screenWidth,
                // ), // Add some margin here
                margin: EdgeInsets.only(right: 300),
                child: IconButton(
                  icon: Icon(
                    Icons.menu_sharp,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _scaffoldKey.currentState?.openDrawer();
                    });
                  },
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          drawer: Container(
            width: 240,
            child: Drawer(
              child: DrawerContent(),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Image.asset(
                          "assets/images/aboutusimg.png",
                          scale: 2,
                          height: screenHeight * 0.203,
                          width: screenWidth * 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 95),
                        child: Text(
                          "About Us",
                          style: GoogleFonts.sourceSerif4(
                            fontSize: (40 / 890.2857142857143) * screenHeight,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: (35 / 890.2857142857143) * screenHeight,
                  ),
                  // Image.asset(
                  //   "assets/images/elevate_playtime.png",
                  //   width: screenWidth * 0.4,
                  //   height: screenHeight * 0.05,
                  // ),
                  // SizedBox(
                  //   height: (20 / 890.2857142857143) * screenHeight,
                  // ),
                  //SingleChildScrollView(
                  //physics: BouncingScrollPhysics(),
                  SizedBox(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.6,
                    child: Text(
                      "Empowering Minds to Thrive: Your Path to Mental Wellness",
                      style: GoogleFonts.poppins(
                        fontSize: (18 / 890.2857142857143) * screenHeight,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: (20 / 890.2857142857143) * screenHeight,
                  ),
                  SizedBox(
                    height: screenHeight * 0.26,
                    width: screenWidth * 0.67,
                    child: Text(
                      "I am a passionate app developer from Manipal Institute of Technology, dedicated to crafting innovative solutions and driving technological advancement in mental health and wellness.",
                      style: GoogleFonts.poppins(
                        fontSize: (16 / 890.2857142857143) * screenHeight,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //),
                  SizedBox(
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.7,
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize:
                                    (16 / 890.2857142857143) * screenHeight,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff0A1621),
                              ),
                              text:
                                  "For queries, feedback, or to know more about us, contact us on ",
                            ),
                            TextSpan(
                              style: GoogleFonts.poppins(
                                  fontSize:
                                      (16 / 890.2857142857143) * screenHeight,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff0A1621),
                                  decoration: TextDecoration.underline),
                              text: "contact@pulsebeat.com",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri _emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: 'contact@pulsebeat.com',
                                      queryParameters: {
                                        'subject': 'Queries/Help'
                                      });
                                  launch(_emailLaunchUri.toString());
                                },
                            ),
                          ])))
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                    (40 / 411.42857142857144) * screenWidth, 35, 0, 0),
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
