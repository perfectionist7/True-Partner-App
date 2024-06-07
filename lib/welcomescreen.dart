import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'information.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class RightRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.arcToPoint(
      Offset(size.width, 20),
      radius: Radius.circular(20),
      clockwise: true,
    );
    path.lineTo(size.width, size.height - 20);
    path.arcToPoint(
      Offset(size.width - 20, size.height),
      radius: Radius.circular(20),
      clockwise: true,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  double _buttonPosition = 0.0;

  // Function to handle button tap and initiate animation
  void _onButtonTap(double endPosition) {
    setState(() {
      _buttonPosition = endPosition;
    });

    // Navigate to the next page after the animation completes
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const InformationPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/welcomebackground.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 180, left: 40),
                  child: Text(
                    "True partner!",
                    style: GoogleFonts.saira(
                      fontSize: (42 / 890.2857142857143) * screenHeight,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 42, right: 40, top: 30),
                  child: Text(
                    "We’re excited to have you here.\nBefore we begin, we’d like to learn a bit more about you.",
                    style: GoogleFonts.dmSans(
                      fontSize: (20 / 890.2857142857143) * screenHeight,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80, left: 0, right: 157),
                  height: 60,
                  child: GestureDetector(
                    // Handle drag and tap gestures
                    onHorizontalDragStart: (details) {
                      setState(() {
                        _buttonPosition = details.globalPosition.dx;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _buttonPosition += details.primaryDelta!;
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_buttonPosition >
                          MediaQuery.of(context).size.width * 0.75) {
                        Navigator.of(context).pushReplacement(_createRoute());
                      } else {
                        setState(() {
                          _buttonPosition = 0.0;
                        });
                      }
                    },
                    onTap: () {
                      _onButtonTap(MediaQuery.of(context).size.width * 0.75);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width:
                          MediaQuery.of(context).size.width - _buttonPosition,
                      transform: Matrix4.translationValues(
                        _buttonPosition,
                        0,
                        0,
                      ),
                      child: ClipPath(
                        clipper: RightRoundedClipper(),
                        child: ElevatedButton(
                          onPressed: () => _onButtonTap(
                              MediaQuery.of(context).size.width * 0.75),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFDE59),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's get started!",
                                style: GoogleFonts.saira(
                                  fontSize:
                                      (18 / 890.2857142857143) * screenHeight,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Image.asset(
                                'assets/images/nextbutton.png',
                                height: 24,
                                width: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 690, left: 20),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                iconSize: MediaQuery.of(context).size.width * 0.08,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
