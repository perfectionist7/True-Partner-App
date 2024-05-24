import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'drawer_content.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/app_bar_end_icon.png",
                  scale: 0.4,
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.3,
                ),
              ),
              SizedBox(
                height: (30 / 890.2857142857143) * screenHeight,
              ),
              SizedBox(
                height: screenHeight * 0.10,
                width: screenWidth * 0.6,
                child: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.10,
                width: screenWidth * 0.6,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.10,
                width: screenWidth * 0.6,
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.10,
                width: screenWidth * 0.6,
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                ),
              ),
              SizedBox(
                height: (30 / 890.2857142857143) * screenHeight,
              ),
              SizedBox(
                height: screenHeight * 0.08,
                width: screenWidth * 0.6,
                child: ElevatedButton(
                  onPressed: () {
                    // Save profile changes
                    String fullName = _fullNameController.text;
                    String email = _emailController.text;
                    String phoneNumber = _phoneNumberController.text;
                    String address = _addressController.text;

                    // Perform saving operations with the retrieved data
                  },
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(
              (40 / 411.42857142857144) * screenWidth,
              60,
              0,
              0,
            ),
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
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
