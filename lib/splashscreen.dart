import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //Using GetX
      Get.to(() => const LoginScreen());

      // auth.authStateChanges().listen((User? user) {
      //   if (user == null) {
      //     Get.to(() => const LoginScreen());
      //   } else {
      //     Get.to(() => const Home());
      //   }
      // });
    });
  }

  @override
  void initState() {
    // call changeScreen
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
            height: 140,
            width: 185,
            child: Center(
                child: Image.asset(
              "assets/images/splash_screen_logo.png",
              fit: BoxFit.fill,
            ))),
      ),
    );
  }
}
