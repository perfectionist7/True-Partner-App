import 'package:deevot_new_project/editprofile.dart';
import 'package:deevot_new_project/help.dart';
import 'package:deevot_new_project/home_screen.dart';
import 'package:deevot_new_project/subscription.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'profile_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:deevot_new_project/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'information.dart';

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
  late Future<String?> fullNameFuture;
  late Future<String?> profileImageUrlFuture;
  var controller = Get.put(ChatsController());
  @override
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
  }

  void clearChatData() {
    controller.chats.clear();
  }

  @override
  void initState() {
    getCurrentUser();
    fullNameFuture = fetchFullName();
    profileImageUrlFuture = fetchProfileImageUrl();
    super.initState();
  }

  Future<String?> fetchFullName() async {
    // Get current user's email
    String? email = _auth.currentUser?.email;
    if (email != null) {
      // Retrieve data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('newUsers')
          .doc(email)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        // Get the full name from the document
        return userDoc['fullname'];
      } else {
        print('Document does not exist');
      }
    }
    return null;
  }

  Future<String?> fetchProfileImageUrl() async {
    // Get current user
    User? user = _auth.currentUser;

    // Check if user is not null
    if (user != null) {
      try {
        // Get reference to the profile image in Firebase Storage
        var reference = firebase_storage.FirebaseStorage.instance
            .ref('images/${user.email}.jpg');

        // Get the download URL for the image
        String downloadURL = await reference.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('Error fetching profile image: $e');
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    double screenHeight = MediaQuery.of(context).size.height;
    print(screenHeight);
    return ModalProgressHUD(
      inAsyncCall: false, // Always set inAsyncCall to false
      child: Container(
        color: Color(0xff352980),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: (225 / 784) * screenHeight,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: (10 / 784) * screenHeight,
                              left: (50 / 360) * screenWidth,
                              right: (20 / 360) * screenWidth),
                          child: FutureBuilder<String?>(
                            future: profileImageUrlFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return CircleAvatar(
                                    radius: (45 / 784) * screenHeight,
                                    backgroundImage:
                                        AssetImage("assets/profileimg.jpg"),
                                  );
                                } else {
                                  return CircleAvatar(
                                    radius: (45 / 784) * screenHeight,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: (120 / 784) * screenHeight),
                          child: FutureBuilder<String?>(
                            future: fullNameFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError ||
                                    snapshot.data == null) {
                                  return Text(
                                    'Error Fetching Name',
                                    style: GoogleFonts.saira(
                                      fontSize: (16 / 784) * screenHeight,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff001F3F),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      '${snapshot.data}',
                                      style: GoogleFonts.saira(
                                        fontSize: (18 / 784) * screenHeight,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff001F3F),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 0,
                              left: (170 / 360) * screenWidth,
                              right: (5 / 360) * screenWidth),
                          child: IconButton(
                            icon: ImageIcon(
                              AssetImage('assets/images/sidebarcross.png'),
                              size: (32 / 784) * screenHeight,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: (30 / 384) * screenWidth),
              // leading: ImageIcon(
              //   AssetImage('assets/images/home_icon.png'),
              //   color: Color(0xff0A1621),
              // ),
              title: Text(
                'Home',
                style: GoogleFonts.saira(
                  fontSize: (16 / 784) * screenHeight,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
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
              thickness: 2,
              color: Colors.white,
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: (30 / 384) * screenWidth),
              // leading: ImageIcon(
              //   AssetImage('assets/images/home_icon.png'),
              //   color: Color(0xff0A1621),
              // ),
              title: Text(
                'Edit Profile',
                style: GoogleFonts.saira(
                  fontSize: (16 / 784) * screenHeight,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
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
              color: Colors.white,
              thickness: 2,
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: (30 / 384) * screenWidth),
              title: Text(
                'Subscription',
                style: GoogleFonts.saira(
                  fontSize: (16 / 784) * screenHeight,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Subscription()),
                );
              },
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: (30 / 384) * screenWidth),
              title: Text(
                'About Us',
                style: GoogleFonts.saira(
                  fontSize: (16 / 784) * screenHeight,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
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
              color: Colors.white,
              thickness: 2,
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: (30 / 384) * screenWidth),
              // leading: ImageIcon(
              //   AssetImage('assets/images/logout_icon.png'),
              //   color: Color(0xff0A1621),
              // ),
              title: Text(
                'Logout',
                style: GoogleFonts.saira(
                  fontSize: (16 / 784) * screenHeight,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
                _auth.signOut();
                clearChatData();
                Fluttertoast.showToast(msg: 'Logged out Successfully!');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
