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
            backgroundColor: const Color(0xff001F3F),
            actions: [
              Container(
                // padding: EdgeInsets.only(
                //   left: (10 / 411.42857142857144) * screenWidth,
                // ), // Add some margin here
                margin: EdgeInsets.only(right: 230),
                child: IconButton(
                  icon: Icon(
                    Icons.menu_sharp,
                    size: 30,
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
                margin: EdgeInsets.only(right: 20),
                child: Image.asset(
                  "assets/images/app_bar_end_icon.png",
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
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Image.asset(
                      "assets/images/aboutus_devotai.png",
                      scale: 0.4,
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.3,
                    ),
                  ),
                  SizedBox(
                    height: (10 / 890.2857142857143) * screenHeight,
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
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.6,
                    child: Text(
                      "Revolutionizing Industries with AI Solutions",
                      style: GoogleFonts.poppins(
                        fontSize: (16 / 890.2857142857143) * screenHeight,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.6,
                    child: Text(
                      "We are a cutting-edge startup specializing in Artificial Intelligence, Web Development, and App Development.",
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
                    height: (5 / 890.2857142857143) * screenHeight,
                  ),
                  SizedBox(
                      height: screenHeight * 0.13,
                      width: screenWidth * 0.6,
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
                              text: "www.devot.ai",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url = Uri.parse("https://www.devot.ai/");
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Coud not launch $url';
                                  }
                                },
                            ),
                          ])))
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                    (40 / 411.42857142857144) * screenWidth, 0, 0, 0),
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
