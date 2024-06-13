import 'package:deevot_new_project/home_screen.dart';
import 'package:deevot_new_project/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package
import 'package:get/get.dart';
import 'check_question.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editprofile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? email;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CheckQuestion.fetchDataFromSpreadsheet();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString("email");
  // Lock the orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chat - Assistant",
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            //to set appbar icons color
          ),
          fontFamily: "sans_regular",
        ),
        home: email == null ? LoginScreen() : HomeScreen());
  }
}
