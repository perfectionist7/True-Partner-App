import 'package:deevot_new_project/home_screen.dart';
import 'package:deevot_new_project/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => InformationPageState();
}

class InformationPageState extends State<InformationPage> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _feelingController = TextEditingController();
  String? email;
  final TextEditingController _anxietyController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _helpController = TextEditingController();

  bool isDrawerOpen = false;
  String firstname = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

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

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
      email = user.email; // <-- Their email
    } else {
      email = "guest";
    }
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
                    buildTextField(
                      controller: _firstNameController,
                      label: "First Name",
                      hint: "Your First Name",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                      hint: "Your Last Name",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _feelingController,
                      label: "How are you feeling today?",
                      hint: "Answer",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _anxietyController,
                      label:
                          "Have you been experiencing any anxiety or stress recently?",
                      hint: "Answer",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _sleepController,
                      label: "Do you have trouble sleeping at night?",
                      hint: "Answer",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _moodController,
                      label:
                          "How would you rate your overall mood on a scale from 1 to 10?",
                      hint: "Answer",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 25),
                    buildTextField(
                      controller: _helpController,
                      label:
                          "Are you currently receiving any professional help for your mental health?",
                      hint: "Answer",
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                    SizedBox(height: 15),
                    buildSubmitButton(),
                    SizedBox(height: 5),
                    buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required double screenHeight,
    required double screenWidth,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            label,
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
              color: Color(0xff6200EE),
            ),
          ),
          margin: EdgeInsets.only(
            top: (10 / 784) * screenHeight,
            left: (10 / 360) * screenWidth,
            right: (24 / 360) * screenWidth,
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: (value) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            style: GoogleFonts.saira(
              fontSize: (14 / 784) * screenHeight,
              fontWeight: FontWeight.w400,
              color: Color(0xff667085),
            ),
            decoration: InputDecoration(
              hintText: hint,
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
      ],
    );
  }

  Widget buildSubmitButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
      height: 60,
      width: 300,
      child: ElevatedButton(
        onPressed: () async {
          String fullname =
              _firstNameController.text + " " + _lastNameController.text;
          Fluttertoast.showToast(msg: "Thank you! Updating Information...");
          if (_formKey.currentState?.validate() ?? false) {
            FirebaseFirestore.instance.collection("newUsers").doc(email).set({
              'flag': false,
              'fullname': fullname,
              'firstname': _firstNameController.text,
              'lastname': _lastNameController.text,
              'how_are_you_feeling_today': _feelingController.text,
              'have_you_been_experiencing_any_anxiety_or_stress_recently':
                  _anxietyController.text,
              'do_you_have_trouble_sleeping_at_night': _sleepController.text,
              'how_would_you_rate_your_overall_mood_on_a_scale_from_1_to_10':
                  _moodController.text,
              'are_you_currently_receiving_any_professional_help_for_your_mental_health':
                  _helpController.text,
            });
            Fluttertoast.showToast(msg: "Information Updated Successfully!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        child: Text(
          'Save',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff6200EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildLogoutButton() {
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
          _auth.signOut();
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove("email");
          Fluttertoast.showToast(msg: 'Logged out Successfully!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: Text(
          'Logout',
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
}
