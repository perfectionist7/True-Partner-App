import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Login_screen_bg.png"),
              fit: BoxFit.fill)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          //padding: const EdgeInsets.fromLTRB(24, 124, 24, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 100, left: 24),
                child: Text(
                  "Create an Account",
                  style: GoogleFonts.saira(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 24, top: 10),
                  child: Text(
                    "Chat with an Assistant!",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFFFFFF),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(
                  left: 24,
                  top: 0.0701530612244898 * screenHeight,
                ),
                height: 0.0229591836734694 * screenHeight,
                width: 0.265625 * screenWidth,
                child: Text(
                  'Your Name',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(top: 8, left: 24, right: 24),
                child: TextField(
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    // email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Type your name',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff708090),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 0.0360416666666667 * screenWidth,
                        right: 0.0260416666666667 * screenWidth,
                        bottom: 0.0166836734693878 * screenHeight),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 24,
                  top: 15,
                ),
                height: 0.0229591836734694 * screenHeight,
                width: 0.265625 * screenWidth,
                child: Text(
                  'E-mail ID',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(top: 8, left: 24, right: 24),
                child: TextField(
                  style: GoogleFonts.dmSans(
                    fontSize: 0.0153061224489796 * screenHeight,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    // email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Type your email ID',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff708090),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 0.0360416666666667 * screenWidth,
                        right: 0.0260416666666667 * screenWidth,
                        bottom: 0.0166836734693878 * screenHeight),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 24,
                  top: 15,
                ),
                height: 0.0229591836734694 * screenHeight,
                width: 0.265625 * screenWidth,
                child: Text(
                  'Password',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(top: 8, left: 24, right: 24),
                child: TextField(
                  obscureText: true,
                  style: GoogleFonts.dmSans(
                    fontSize: 0.0153061224489796 * screenHeight,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    // email = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff708090),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 0.0360416666666667 * screenWidth,
                        right: 0.0260416666666667 * screenWidth,
                        bottom: 0.0166836734693878 * screenHeight),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24, top: 36),
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // ignore: deprecated_member_use
                    backgroundColor: const Color(0xff6200EE),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    // Get.to(() => const HomeScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      5.widthBox,
                      Image.asset("assets/images/double_chevron.png")
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 36),
                child: Image.asset(
                  "assets/images/divider.png",
                  width: context.screenWidth,
                ),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(left: 24, right: 24, top: 36),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      backgroundColor: const Color(0xffFFFFFF),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/googleLogo.png"),
                      12.widthBox,
                      Text(
                        "Sign in with Google",
                        style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff001F3F)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 48,
                margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      backgroundColor: const Color(0xffFFFFFF),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/facebookLogo.png"),
                      12.widthBox,
                      Text(
                        "Sign in with Facebook",
                        style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff001F3F)),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(80, 40, 70, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                    // _passwordcontroller.clear();
                    // _controller.clear();
                  },
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account?',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        )),
                    TextSpan(
                        text: ' Login',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF4178F3),
                        ))
                  ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
