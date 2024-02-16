import 'package:deevot_new_project/home_screen.dart';
import 'package:deevot_new_project/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
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
              Text(
                "Create an Account",
                style: GoogleFonts.saira(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffFFFFFF),
                ),
              ).box.padding(const EdgeInsets.fromLTRB(24, 124, 24, 0)).make(),
              Text(
                "Chat with an Assistant!",
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffFFFFFF),
                ),
              ).box.padding(const EdgeInsets.fromLTRB(26, 0, 66, 0)).make(),
              50.heightBox,
              customTextField(
                      title: "Your Name", hint: "Type your name", isPass: false)
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .make(),
              customTextField(
                      title: "E-mail ID",
                      hint: "Type your email ID",
                      isPass: false)
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .make(),
              customTextField(
                      title: "Password",
                      hint: "Create a password",
                      isPass: true)
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .make(),
              30.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: const Color(0xff6200EE),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {},
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
              )
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .width(context.screenWidth)
                  .height(48)
                  .rounded
                  .make(),
              40.heightBox,
              Image.asset(
                "assets/images/divider.png",
                width: context.screenWidth,
              ),
              50.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: const Color(0xffFFFFFF),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/googleLogo.png"),
                    5.widthBox,
                    Text(
                      "Sign in with Google",
                      style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff001F3F)),
                    ),
                  ],
                ),
              )
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .width(context.screenWidth)
                  .height(48)
                  .rounded
                  .make(),
              20.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: const Color(0xffFFFFFF),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {
                  Get.to(() => const HomeScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/facebookLogo.png"),
                    5.widthBox,
                    Text(
                      "Sign in with Faceebook",
                      style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff001F3F)),
                    ),
                  ],
                ),
              )
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .width(context.screenWidth)
                  .height(48)
                  .rounded
                  .make(),
              50.heightBox,
              Center(
                  child: "Already have an Account"
                      .text
                      .color(Colors.white)
                      .make()),
              5.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: const Color(0xff6200EE),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {
                  Get.to(() => const LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffFFFFFF)),
                    ),
                  ],
                ),
              )
                  .box
                  .padding(const EdgeInsets.only(left: 24, right: 24))
                  .width(context.screenWidth)
                  .height(48)
                  .rounded
                  .make(),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
