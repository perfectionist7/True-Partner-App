import 'package:deevot_new_project/editprofile.dart';
import 'package:deevot_new_project/help.dart';
import 'package:deevot_new_project/home_screen.dart';
import 'profile_page.dart';
import 'package:deevot_new_project/login_screen.dart';

import 'package:flutter/material.dart';

import 'main.dart';
import 'controllers/chat_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class DrawerContent extends StatefulWidget {
  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  final _auth = FirebaseAuth.instance;
  var controller = Get.put(ChatsController());
  @override
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
  }

  void clearChatData() {
    controller.chats.clear();
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    double screenHeight = MediaQuery.of(context).size.height;
    print(screenHeight);
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: (250 / 784) * screenHeight,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff001F3F),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 0,
                      left: (150 / 384) * screenWidth,
                      // right: (10 / 384) * screenWidth,
                    ),
                    child: IconButton(
                        icon: ImageIcon(
                          AssetImage('assets/images/sidebarcross.png'),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: (38 / 784) * screenHeight,
                        left: (70 / 384) * screenWidth,
                        right: (70 / 384) * screenWidth),
                    // child: Image.asset('assets/images/sidebar_image.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: (10 / 784) * screenHeight,
                        left: (20 / 384) * screenWidth,
                        right: (20 / 384) * screenWidth),
                    child: Text(
                      '${_auth.currentUser?.email}',
                      style: GoogleFonts.poppins(
                        fontSize: (16 / 784) * screenHeight,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                top: (10 / 784) * screenHeight, left: (35 / 384) * screenWidth),
            // leading: ImageIcon(
            //   AssetImage('assets/images/home_icon.png'),
            //   color: Color(0xff0A1621),
            // ),
            title: Text(
              'home',
              style: GoogleFonts.poppins(
                fontSize: (16 / 784) * screenHeight,
                fontWeight: FontWeight.w500,
                color: Color(0xff001F3F),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          Divider(
            color: Color(0xff001F3F),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
                top: (10 / 784) * screenHeight, left: (35 / 384) * screenWidth),
            // leading: ImageIcon(
            //   AssetImage('assets/images/home_icon.png'),
            //   color: Color(0xff0A1621),
            // ),
            title: Text(
              'edit profile',
              style: GoogleFonts.poppins(
                fontSize: (16 / 784) * screenHeight,
                fontWeight: FontWeight.w500,
                color: Color(0xff001F3F),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
            },
          ),
          Divider(
            color: Color(0xff001F3F),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: (35 / 384) * screenWidth),
            title: Text(
              'about us',
              style: GoogleFonts.poppins(
                fontSize: (16 / 784) * screenHeight,
                fontWeight: FontWeight.w500,
                color: Color(0xff001F3F),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Help_Screen()),
              );
            },
          ),
          Divider(
            color: Color(0xff001F3F),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: (35 / 384) * screenWidth),
            // leading: ImageIcon(
            //   AssetImage('assets/images/logout_icon.png'),
            //   color: Color(0xff0A1621),
            // ),
            title: Text(
              'log out',
              style: GoogleFonts.poppins(
                fontSize: (16 / 784) * screenHeight,
                fontWeight: FontWeight.w500,
                color: Color(0xff001F3F),
              ),
            ),
            onTap: () async {
              // showSpinner = true;
              _auth.signOut();
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove("email");
              clearChatData();
              Fluttertoast.showToast(msg: 'Logged out Successfully!');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
              // showSpinner = false;
            },
          ),
          Divider(
            color: Color(0xff001F3F),
          ),
        ],
      ),
    );
  }
}
