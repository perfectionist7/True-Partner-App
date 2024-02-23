import 'package:deevot_new_project/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'check_question.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CheckQuestion.fetchDataFromSpreadsheet();
  //await Firebase.initializeApp();
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
      home: const LoginScreen(),
    );
  }
}
