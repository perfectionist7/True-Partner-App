import 'package:deevot_new_project/information.dart';
import 'package:deevot_new_project/signup_screen.dart';
import 'package:deevot_new_project/welcomescreen.dart';
import 'package:deevot_new_project/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isCheck = false;
  var _controller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  String email = '';
  String password = '';
  String? errorMessage;
  late bool _passwordVisible;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    showSpinner = false;
    setState(() {});
    _passwordVisible = false;
  }

  void _checkAuthentication() async {
    // Check if user is signed in
    User? user = _auth.currentUser;
    if (user != null) {
      // User is signed in, retrieve user's email
      String userEmail = user.email ?? "";

      // Retrieve flag from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('newUsers').doc(userEmail).get();
      bool flag = userDoc.exists ? userDoc.get('flag') ?? false : false;

      // Navigate based on the flag
      if (flag) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      // User is not signed in, navigate to authentication screen
      setState(() {
        showSpinner = false;
      });
    }
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
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
    showSpinner = false;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //height: 827, width: 393
    print(screenHeight);
    print(screenWidth);
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
                    "Welcome Back!",
                    style: GoogleFonts.saira(
                      fontSize: (30 / 784) * screenHeight,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: (10 / 784) * screenHeight,
                      left: (24 / 360) * screenWidth),
                  child: Text(
                    "Chat with an Assistant!",
                    style: GoogleFonts.dmSans(
                      fontSize: (16 / 784) * screenHeight,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: (24 / 360) * screenWidth,
                    top: 0.0701530612244898 * screenHeight,
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
                    controller: _controller,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      email = value;
                    },
                    style: GoogleFonts.dmSans(
                      fontSize: 0.0153061224489796 * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
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
                      fontSize: (12 / 784) * screenHeight,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '************',
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
                        padding:
                            EdgeInsets.only(right: (10 / 360) * screenWidth),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Theme(
                    //         data: Theme.of(context).copyWith(
                    //           unselectedWidgetColor: Colors.white,
                    //         ),
                    //         child: Checkbox(
                    //             activeColor: Colors.red,
                    //             checkColor: Colors.white,
                    //             focusColor: Colors.white,
                    //             value: isCheck,
                    //             onChanged: (newValue) {
                    //               setState(() {
                    //                 isCheck = newValue!;
                    //               });
                    //             })),
                    //     Text(
                    //       "Remember Me",
                    //       style: GoogleFonts.dmSans(
                    //           fontSize: (12 / 784) * screenHeight,
                    //           fontWeight: FontWeight.w400,
                    //           color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                    Container(
                      margin: EdgeInsets.only(
                          right: (20 / 360) * screenWidth,
                          left: (210 / 360) * screenWidth),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner =
                                true; // Show the spinner before the async operation.
                          });
                          if (email.isNotEmpty) {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);

                              Fluttertoast.showToast(
                                  msg:
                                      'A password reset email has been sent to your email address.');
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Failed to send password reset email. Please try again.');
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'Please enter your registered email address.');
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        child: Text(
                          "Forgot Password ?",
                          style: GoogleFonts.dmSans(
                              decoration: TextDecoration.underline,
                              fontSize: (12 / 784) * screenHeight,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth,
                      top: (36 / 784) * screenHeight),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      // ignore: deprecated_member_use
                      backgroundColor: const Color(0xff6200EE),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("email", email);

                        _checkAuthentication();
                        _passwordcontroller.clear();
                        _controller.clear();

                        Fluttertoast.showToast(msg: 'Successfully Logged In!');
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        // print(e);
                        String error = '';
                        error = e.toString();
                        switch (error) {
                          case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
                            errorMessage = 'Invalid Password Entered.';
                            break;
                          case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
                            errorMessage = 'No such user exists.';
                            break;
                          case '[firebase_auth/invalid-email] The email address is badly formatted.':
                            errorMessage = 'Invalid email address.';
                            break;
                          case '[firebase_auth/unknown] Given String is empty or null':
                            errorMessage =
                                'Empty fields! Enter some input to continue';
                            break;
                          case '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
                            errorMessage = 'Too many attempts, try again later';
                            break;
                          case '[firebase_auth/user-disabled] The user account has been disabled by an administrator.':
                            errorMessage = 'Account blocked by Administrator';
                            break;
                          default:
                            errorMessage = 'An undefined error occurred.';
                            break;
                        }
                      }
                      Fluttertoast.showToast(msg: errorMessage!);
                      setState(() {
                        showSpinner = false;
                      });
                      errorMessage = '';
                      email = '';
                      password = '';
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
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
                  margin: EdgeInsets.only(top: (40 / 784) * screenHeight),
                  child: Image.asset(
                    "assets/images/divider.png",
                    width: context.screenWidth,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: (24 / 360) * screenWidth,
                      right: (24 / 360) * screenWidth,
                      top: (40 / 784) * screenHeight),
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
                          "Log in with Google",
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
                          "Log in with Apple",
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
                  margin: EdgeInsets.fromLTRB((70 / 360) * screenWidth,
                      (45 / 784) * screenHeight, (50 / 360) * screenWidth, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                      // _passwordcontroller.clear();
                      // _controller.clear();
                    },
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: 'Don\'t have an account?',
                          style: GoogleFonts.dmSans(
                            fontSize: (14 / 784) * screenHeight,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          )),
                      TextSpan(
                          text: ' Register',
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
}
