import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String fullname = '';
  String password = '';
  late bool _passwordVisible;
  String? errorMessage;
  bool showSpinner = false;
  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
    showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
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
                  margin: EdgeInsets.only(
                      top: (80 / 784) * screenHeight,
                      left: (24 / 360) * screenWidth),
                  child: Text(
                    "Create an Account",
                    style: GoogleFonts.saira(
                      fontSize: (30 / 784) * screenHeight,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: (24 / 360) * screenWidth,
                        top: (10 / 784) * screenHeight),
                    child: Text(
                      "Chat with an Assistant!",
                      style: GoogleFonts.dmSans(
                        fontSize: (16 / 784) * screenHeight,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xffFFFFFF),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(
                    left: (24 / 360) * screenWidth,
                    top: 0.0701530612244898 * screenHeight,
                  ),
                  height: 0.0229591836734694 * screenHeight,
                  width: 0.265625 * screenWidth,
                  child: Text(
                    'Your Name',
                    style: GoogleFonts.dmSans(
                      fontSize: (14 / 784) * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: (34 / 784) * screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(
                      top: (8 / 784) * screenHeight,
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth),
                  child: TextField(
                    style: GoogleFonts.dmSans(
                      fontSize: (12 / 784) * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    controller: _namecontroller,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      fullname = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your name',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: (12 / 784) * screenHeight,
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
                    left: (24 / 360) * screenWidth,
                    top: (15 / 784) * screenHeight,
                  ),
                  height: 0.0229591836734694 * screenHeight,
                  width: 0.265625 * screenWidth,
                  child: Text(
                    'E-mail ID',
                    style: GoogleFonts.dmSans(
                      fontSize: (14 / 784) * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: (34 / 784) * screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(
                      top: (8 / 784) * screenHeight,
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth),
                  child: TextField(
                    style: GoogleFonts.dmSans(
                      fontSize: 0.0153061224489796 * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    controller: _emailcontroller,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your email ID',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: (12 / 784) * screenHeight,
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
                    left: (24 / 360) * screenWidth,
                    top: (15 / 784) * screenHeight,
                  ),
                  height: 0.0229591836734694 * screenHeight,
                  width: 0.265625 * screenWidth,
                  child: Text(
                    'Password',
                    style: GoogleFonts.dmSans(
                      fontSize: (14 / 784) * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: (34 / 784) * screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(
                      top: (8 / 784) * screenHeight,
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth),
                  child: TextField(
                    controller: _passwordcontroller,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: !_passwordVisible,
                    style: GoogleFonts.dmSans(
                      fontSize: 0.0153061224489796 * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: (12 / 784) * screenHeight,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff708090),
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 0.0360416666666667 * screenWidth,
                          right: 0.0260416666666667 * screenWidth,
                          bottom: 0.0166836734693878 * screenHeight),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        padding: EdgeInsets.only(right: 10),
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff636D77),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth,
                      top: (36 / 784) * screenHeight),
                  height: (48 / 784) * screenHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      // ignore: deprecated_member_use
                      backgroundColor: const Color(0xff6200EE),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });
                      signUp(email, password);
                      _emailcontroller.clear();
                      _passwordcontroller.clear();
                      _namecontroller.clear();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Up",
                          style: GoogleFonts.dmSans(
                              fontSize: (14 / 784) * screenHeight,
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
                  margin: EdgeInsets.only(top: (36 / 784) * screenHeight),
                  child: Image.asset(
                    "assets/images/divider.png",
                    width: context.screenWidth,
                  ),
                ),
                Container(
                  height: (48 / 784) * screenHeight,
                  margin: EdgeInsets.only(
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth,
                      top: (36 / 784) * screenHeight),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // ignore: deprecated_member_use
                        backgroundColor: const Color(0xffFFFFFF),
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      showSpinner = true;
                      signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/googleLogo.png"),
                        12.widthBox,
                        Text(
                          "Sign in with Google",
                          style: GoogleFonts.dmSans(
                              fontSize: (11 / 784) * screenHeight,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff001F3F)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: (48 / 784) * screenHeight,
                  margin: EdgeInsets.only(
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth,
                      top: (16 / 784) * screenHeight),
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
                        Image.asset("assets/images/applelogo.png"),
                        12.widthBox,
                        Text(
                          "Sign in with Apple",
                          style: GoogleFonts.dmSans(
                              fontSize: (11 / 784) * screenHeight,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff001F3F)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB((60 / 360) * screenWidth,
                      (25 / 784) * screenHeight, (20 / 360) * screenWidth, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                      _emailcontroller.clear();
                      _passwordcontroller.clear();
                      _namecontroller.clear();
                    },
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Already have an account?',
                          style: GoogleFonts.dmSans(
                            fontSize: (14 / 784) * screenHeight,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          )),
                      TextSpan(
                          text: ' Login',
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            fontSize: (14 / 784) * screenHeight,
                            color: Color(0xFF4178F3),
                          ))
                    ])),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance
          .collection("newUsers")
          .doc(userCredential.user!.email)
          .set({
        'fullname': fullname,
        'email': email,
        'flag': true,
      });
      setState(() {
        showSpinner = false;
      });

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const VerificationPage()),
      // );
      Fluttertoast.showToast(msg: 'Successfully Registered!');
    } catch (e) {
      String errorcode = '';
      errorcode = e.toString();
      // print(errorcode);
      switch (errorcode) {
        case "[firebase_auth/invalid-email] The email address is badly formatted.":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
          errorMessage =
              "The email address is already associated with an existing account.";
          break;
        case "[firebase_auth/weak-password] Password should be at least 6 characters":
          errorMessage =
              "The password is too weak. It should atleast be 6 characters.";
          break;
        case "[firebase_auth/operation-not-allowed] Password sign-in is disabled for this project.":
          errorMessage = "Password sign-in is currently disabled.";
          break;
        case '[firebase_auth/unknown] Given String is empty or null':
          errorMessage = 'Empty fields! Enter some input to continue';
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined error occurred.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      setState(() {
        showSpinner = false;
      });
      errorMessage = '';
    }
  }
}
