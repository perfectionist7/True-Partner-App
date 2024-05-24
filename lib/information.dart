import 'package:deevot_new_project/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'drawer_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => InformationPageState();
}

class InformationPageState extends State<InformationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  bool isDrawerOpen = false;
  String firstname = '';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              width: 240,
              child: Drawer(
                child: DrawerContent(),
              ),
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          "Profile Form",
                          style: GoogleFonts.saira(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff334C65),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "First Name",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Your First Name',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Last Name",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Your Last Name',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "How are you feeling today?",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Have you been experiencing any anxiety or stress recently?",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Do you have trouble sleeping at night?",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "How would you rate your overall mood on a scale from 1 to 10?",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Are you currently receiving any professional help for your mental health?",
                            style: GoogleFonts.saira(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff334C65),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xff6200EE))),
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (10 / 360) * screenWidth,
                              right: (24 / 360) * screenWidth),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              firstname = value;
                            },
                            style: GoogleFonts.saira(
                              fontSize: (14 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff667085),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              hintStyle: GoogleFonts.saira(
                                fontSize: (14 / 784) * screenHeight,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff667085),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 0.0360416666666667 * screenWidth,
                                right: 0.0260416666666667 * screenWidth,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
                          height: 60,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () async {
                                // print(fullname);
                                // print(phonenumber);
                                // print(email);
                                // print(password);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const LoginPage()),
                                // );
                              },
                              child: Text('Submit',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6200EE),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 22, 10, 40),
                          height: 60,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Color(0xffFFDE59))),
                          child: ElevatedButton(
                              onPressed: () async {
                                // print(fullname);
                                // print(phonenumber);
                                // print(email);
                                // print(password);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const LoginPage()),
                                // );
                              },
                              child: Text('Logout',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff001F3F))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
