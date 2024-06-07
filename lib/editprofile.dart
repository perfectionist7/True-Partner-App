import 'dart:io';
import 'package:deevot_new_project/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'drawer_content.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  String? currentemail;
  bool showSpinner = false;
  final _firestore = FirebaseFirestore.instance;
  late final userData;
  String fullname = "";
  String oldpass = "";
  String newpass = "";
  String reenterpass = "";
  File? _imageFile;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("newUsers");
  String firstname = "";
  String lastname = "";
  late Future<String?> fullnamefuture;
  String? email;
  var _controller = TextEditingController();
  var _lastcontroller = TextEditingController();
  var _controllernew = TextEditingController();
  final _fullnameController = TextEditingController();
  String password = '';
  var _passwordcontroller = TextEditingController();
  late Future<String?> profileImageUrlFuture;
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

  Future<void> deleteUserWithSubcollection(String? userEmail) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('userCollection').doc(userEmail);
    final subcollectionRef = userDocRef.collection('conversations');

    // Get all documents in the subcollection
    final subcollectionSnapshot = await subcollectionRef.get();

    // Delete each document in the subcollection
    for (var doc in subcollectionSnapshot.docs) {
      await doc.reference.delete();
    }

    // Finally, delete the main document
    await userDocRef.delete();
  }

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
      email = user.email; // <-- Their email
    } else {
      email = "guest";
    }
  }

  Future<void> fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection("newUsers")
              .doc(currentUser?.email)
              .get();

      if (snapshot.exists) {
        // Convert the Firestore data to a Map<String, dynamic>
        userData = snapshot.data()!;
        setState(() {});
      } else {
        // print("Document does not exist.");
      }
    } catch (e) {
      // print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    profileImageUrlFuture = fetchProfileImageUrl();
    fullnamefuture = fetchFullName();
    _requestPermissions();
    if (currentUser != null) {
      getCurrentUser();
      fetchUserData();
      currentemail = currentUser?.email;
    } else {
      currentemail = "guest";
    }
  }

  Future<String?> fetchFullName() async {
    email = _auth.currentUser?.email;
    if (email != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('newUsers').doc(email).get();
        if (userDoc.exists) {
          return userDoc['fullname'];
        }
      } catch (e) {
        print('Error fetching full name: $e');
      }
    }
    return null;
  }

  Future<void> _requestPermissions() async {
    // Request permission to access the camera
    var cameraStatus = await Permission.camera.request();
    // Request permission to access the photo library
    var photoLibraryStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photoLibraryStatus.isGranted) {
      // Permissions denied, handle accordingly (e.g., show error message)
      print('Permissions denied. Cannot access camera or photo library.');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    _uploadImage();
  }

  Future<void> _uploadImage() async {
    Fluttertoast.showToast(msg: "Uploading Image");
    // Get current user
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Create a reference to the profile image in Firebase Storage
        var reference = firebase_storage.FirebaseStorage.instance
            .ref('images/${user.email}.jpg');

        // Upload the image file to Firebase Storage
        await reference.putFile(_imageFile!);

        // Retrieve the download URL for the image
        String downloadURL = await reference.getDownloadURL();

        // Do something with the download URL (e.g., save it to user profile)
        // For now, print the download URL
        print('Image uploaded successfully. Download URL: $downloadURL');
        Fluttertoast.showToast(msg: "Image uploaded Successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EditProfile()),
        );
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // print(screenHeight);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff001F3F),
          actions: [
            Container(
              height: 200,
              child: Container(
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
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30),
                      child: FutureBuilder<String?>(
                        future: profileImageUrlFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            if (snapshot.hasError || snapshot.data == null) {
                              return CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/images/profileimg.jpg"),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(snapshot.data!),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 152, left: 210),
                      child: IconButton(
                        onPressed: () => _showOptionsDialog(context),
                        icon: Image.asset('assets/images/editprofilecam.png'),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<String?>(
                      future: fullnamefuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError || snapshot.data == null) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                              child: TextField(
                                readOnly: true,
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  hintText: 'Not set yet',
                                  hintStyle: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff708090)),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16, 18, 5, 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xff6200EE), width: 1),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                              child: TextField(
                                readOnly: true,
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  hintText: snapshot.data,
                                  hintStyle: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff708090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16, 18, 19, 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(0xff6200EE),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(
                                          0xff6200EE), // Change color to the desired border color
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    Container(
                      height: 53,
                      width: 343,
                      decoration: new BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(
                                  0, 7), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Color(0xff6200EE), width: 1)),
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                      child: TextField(
                        readOnly: true,
                        controller: _passwordcontroller,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          // password = value;
                        },
                        decoration: InputDecoration(
                          hintText: '$email',
                          hintStyle: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff708090)),
                          contentPadding: EdgeInsets.fromLTRB(16, 18, 19, 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      margin: EdgeInsets.only(
                          top: (50 / 784) * screenHeight,
                          left: (26 / 384) * screenWidth,
                          right: (26 / 384) * screenWidth),
                      child: SizedBox(
                        height: (50 / 784) * screenHeight,
                        width: (350 / 384) * screenWidth,
                        child: ElevatedButton(
                          onPressed: () async {
                            _showupdatedialog(context);
                            // Fluttertoast.showToast(msg: "Updating information");
                            // updateDetails();
                            // Fluttertoast.showToast(
                            //     msg: "Information updated successfully!");
                          },
                          child: Text(
                            'Update Details +',
                            style: GoogleFonts.poppins(
                                fontSize: (16 / 784) * screenHeight,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffF9FFFF)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff6200EE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      margin: EdgeInsets.only(
                          top: (30 / 784) * screenHeight,
                          left: (26 / 384) * screenWidth,
                          right: (26 / 384) * screenWidth),
                      child: SizedBox(
                        height: (50 / 784) * screenHeight,
                        width: (350 / 384) * screenWidth,
                        child: ElevatedButton(
                          onPressed: () async {
                            _showchangepassworddialog(context);
                          },
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.poppins(
                                fontSize: (16 / 784) * screenHeight,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffF9FFFF)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff6200EE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      margin: EdgeInsets.only(
                          top: (30 / 784) * screenHeight,
                          left: (26 / 384) * screenWidth,
                          right: (26 / 384) * screenWidth),
                      child: SizedBox(
                        height: (50 / 784) * screenHeight,
                        width: (350 / 384) * screenWidth,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (currentemail == "guest") {
                              Fluttertoast.showToast(
                                  msg:
                                      "You must be logged in to delete your account!");
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete your Account?'),
                                    content: const Text(
                                        '''If you select Delete we will delete your account on our server.\n\nYour app data will also be deleted and you won't be able to retrieve it.\n\nSelect delete if you wish to proceed.'''),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Delete',
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          await deleteUserWithSubcollection(
                                              currentemail);
                                          await deleteUserAccount();
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          pref.remove("email");
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Your account has been deleted successfully!');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                          );
                                          setState(() {
                                            showSpinner = false;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            ;
                          },
                          child: Text(
                            'Delete Profile',
                            style: GoogleFonts.poppins(
                                fontSize: (16 / 784) * screenHeight,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff6200EE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      // ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   margin: EdgeInsets.fromLTRB(
                      //       (40 / 411.42857142857144) * screenWidth, 10, 0, 0),
                      //   padding: const EdgeInsets.all(1),
                      //   child: IconButton(
                      //     icon: const Icon(
                      //       Icons.arrow_back_ios_rounded,
                      //       color: Color(0xff001F3F),
                      //     ),
                      //     iconSize: screenWidth * 0.08,
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  void _showupdatedialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 210, bottom: 110),
              child: AlertDialog(
                contentPadding:
                    EdgeInsets.only(left: 10, bottom: 20, top: 20, right: 20),
                backgroundColor: Colors.white,
                title: Container(
                  margin: EdgeInsets.only(top: 5, left: 0),
                  child: Row(
                    children: [
                      Text(
                        'Update Details',
                        style: GoogleFonts.saira(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff001F3E)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 75),
                        child: IconButton(
                          icon: Image.asset('assets/images/closedialog.png'),
                          iconSize: 24.0, // You can adjust the size as needed
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "First Name",
                        style: GoogleFonts.saira(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff344054),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xff6200EE))),
                      margin: EdgeInsets.only(
                          top: (10 / 784) * screenHeight,
                          left: (12 / 360) * screenWidth,
                          right: (0 / 360) * screenWidth),
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
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Last Name",
                        style: GoogleFonts.saira(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff344054),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xff6200EE))),
                      margin: EdgeInsets.only(
                          top: (10 / 784) * screenHeight,
                          left: (10 / 360) * screenWidth,
                          right: (0 / 360) * screenWidth),
                      child: TextField(
                        controller: _lastcontroller,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          lastname = value;
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
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 25, 10, 0),
                          height: 50,
                          width: 105,
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                              child: Text('Cancel',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff6750A4))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffF3EDF7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Color(0xffFFDE59), width: 1),
                                ),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 25, 0, 0),
                          height: 50,
                          width: 105,
                          child: ElevatedButton(
                              onPressed: () async {
                                showSpinner = true;
                                String actualfullname =
                                    firstname + " " + lastname;
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                    msg: "Updating Information");
                                FirebaseFirestore.instance
                                    .collection("newUsers")
                                    .doc(email)
                                    .set({
                                  'firstname': firstname,
                                  'lastname': lastname,
                                  'fullname': actualfullname
                                });

                                Fluttertoast.showToast(
                                    msg: "Information Updated Successfully!");
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                                showSpinner = false;
                              },
                              child: Text('Save',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6200EE),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      // Handle the result here
      if (value != null) {
        print("Selected Option: $value");
      }
    });
  }

  void _showchangepassworddialog(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 210, bottom: 110),
            child: AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 10, bottom: 20, top: 20, right: 20),
              backgroundColor: Colors.white,
              title: Container(
                margin: EdgeInsets.only(top: 15, left: 0),
                child: Row(
                  children: [
                    Text(
                      'Change Password',
                      style: GoogleFonts.saira(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff001F3E)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: IconButton(
                        icon: Image.asset('assets/images/closedialog.png'),
                        iconSize: 24.0, // You can adjust the size as needed
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xff6200EE))),
                      margin: EdgeInsets.only(
                          top: (0 / 784) * screenHeight,
                          left: (12 / 360) * screenWidth,
                          right: (0 / 360) * screenWidth),
                      child: TextField(
                        obscureText: true,
                        controller: _controller,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          oldpass = value;
                        },
                        style: GoogleFonts.dmSans(
                          fontSize: (14 / 784) * screenHeight,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff708090),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Old Password',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: (14 / 784) * screenHeight,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff708090),
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
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xff6200EE))),
                      margin: EdgeInsets.only(
                          top: (10 / 784) * screenHeight,
                          left: (12 / 360) * screenWidth,
                          right: (0 / 360) * screenWidth),
                      child: TextField(
                        obscureText: true,
                        controller: _lastcontroller,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          newpass = value;
                        },
                        style: GoogleFonts.dmSans(
                          fontSize: (14 / 784) * screenHeight,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff708090),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter New Password',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: (14 / 784) * screenHeight,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff708090),
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
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xff6200EE))),
                      margin: EdgeInsets.only(
                          top: (10 / 784) * screenHeight,
                          left: (12 / 360) * screenWidth,
                          right: (0 / 360) * screenWidth),
                      child: TextField(
                        obscureText: true,
                        controller: _controllernew,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          reenterpass = value;
                        },
                        style: GoogleFonts.dmSans(
                          fontSize: (14 / 784) * screenHeight,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff708090),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Re-enter Password',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: (14 / 784) * screenHeight,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff708090),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 0.0360416666666667 * screenWidth,
                            right: 0.0260416666666667 * screenWidth,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 25, 10, 0),
                          height: 50,
                          width: 105,
                          child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                              child: Text('Cancel',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff6750A4))),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffF3EDF7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: Color(0xffFFDE59), width: 1),
                                ),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 25, 0, 0),
                          height: 50,
                          width: 110,
                          child: ElevatedButton(
                              onPressed: () async {
                                showSpinner = true;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile()));
                                if (newpass != reenterpass) {
                                  Fluttertoast.showToast(
                                      msg: "Passwords do not match!");
                                  showSpinner = false;
                                  return;
                                }
                                AuthCredential credential =
                                    EmailAuthProvider.credential(
                                  email: email!,
                                  password: oldpass,
                                );

                                try {
                                  Fluttertoast.showToast(
                                      msg: "Updating your password...");
                                  // Attempt to reauthenticate the user
                                  await FirebaseAuth.instance.currentUser!
                                      .reauthenticateWithCredential(credential);

                                  // If reauthentication is successful, proceed to change the password
                                  await FirebaseAuth.instance.currentUser!
                                      .updatePassword(newpass);
                                  Fluttertoast.showToast(
                                      msg: "Password updated successfully!");
                                  showSpinner = false;
                                } catch (e) {
                                  // If reauthentication fails, handle the error
                                  print("Error: $e");
                                  Fluttertoast.showToast(
                                      msg:
                                          "Failed to update password. Please check your old password and try again.");
                                  showSpinner = false;
                                }
                              },
                              child: Text('Update',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6200EE),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      // Handle the result here
      if (value != null) {
        print("Selected Option: $value");
      }
    });
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.only(left: 10, bottom: 20, top: 10, right: 5),
          backgroundColor: Color(0xffF3EDF7),
          title: Row(
            children: [
              Text(
                'Upload image',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1D1B20)),
              ),
              Container(
                margin: EdgeInsets.only(left: 25),
                child: IconButton(
                  icon: Image.asset('assets/images/closedialog.png'),
                  iconSize: 24.0, // You can adjust the size as needed
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop('Option 1');
                },
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Row(
                    children: [
                      Text(
                        'From Device',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6750A4),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Image.asset(
                          'assets/images/upload_icon.png', // Replace with your asset path
                          color: Colors.black,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Row(
                    children: [
                      Text(
                        'Capture',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff6750A4),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Image.asset(
                          'assets/images/editprofilecam.png', // Replace with your asset path
                          color: Colors.black,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      // Handle the result here
      if (value != null) {
        print("Selected Option: $value");
      }
    });
  }

  void updateDetails() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      print(user);

      print(fullname);
      print(password);
      if (user != null) {
        await _updateFirebaseAuth(user);
        await _updateFirestore(user);
        // Show success message

        // Clear text fields
        _controller.clear();
        _passwordcontroller.clear();
      }
    } catch (e) {
      // Show error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    }
  }

  Future<void> _updateFirebaseAuth(User user) async {
    if (password.isNotEmpty) {
      await user.updatePassword(password);
    }
  }

  Future<void> _updateFirestore(User user) async {
    print(user.email);
    await _firestore.collection('newUsers').doc(user.email).update({
      'fullname': fullname.isNotEmpty ? fullname : user.displayName,
      // You can add more fields to update here
    });
    print("after");
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final providerData = currentUser.providerData;
      if (providerData.isNotEmpty) {
        if (AppleAuthProvider().providerId == providerData.first.providerId) {
          await currentUser.reauthenticateWithProvider(AppleAuthProvider());
        } else if (GoogleAuthProvider().providerId ==
            providerData.first.providerId) {
          await currentUser.reauthenticateWithProvider(GoogleAuthProvider());
        }
      } else {
        print('no authenticatin provider');
      }
    } else {
      print('not signed in');
    }
  }
}
