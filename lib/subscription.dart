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
    Widget onemonth() {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 22, 10, 20),
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            style: BorderStyle.solid,
            color: Color(0xffFFDE59),
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RazorPayGateway(amount: "99")),
            );
          },
          child: Text(
            '1 month @ 99/-',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff001F3F),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    Widget sixmonths() {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 22, 10, 20),
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            style: BorderStyle.solid,
            color: Color(0xffFFDE59),
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RazorPayGateway(amount: "499")),
            );
          },
          child: Text(
            '6 months  @ 499/-',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff001F3F),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    Widget oneyear() {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 22, 10, 40),
        height: 60,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            style: BorderStyle.solid,
            color: Color(0xffFFDE59),
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RazorPayGateway(amount: "949")),
            );
          },
          child: Text(
            '1 year @ 949/-',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff001F3F),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

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
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 50),
                child: Text(
                  'Please select your choice of subscription',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.saira(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff001F3F),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 50, right: 50, top: 40),
                  child: onemonth()),
              Container(
                  margin: EdgeInsets.only(left: 50, right: 50, top: 0),
                  child: sixmonths()),
              Container(
                  margin: EdgeInsets.only(left: 50, right: 50, top: 0),
                  child: oneyear()),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                    (40 / 411.42857142857144) * screenWidth, 100, 0, 0),
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
