import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'upload_payment.dart';
import 'api_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_content.dart';

class RazorPayGateway extends StatefulWidget {
  const RazorPayGateway({super.key, required this.index});

  @override
  State<RazorPayGateway> createState() => _RazorPayGatewayState();
  final int index;
}

class _RazorPayGatewayState extends State<RazorPayGateway> {
  late Razorpay _razorpay;
  String? email;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController amtController = TextEditingController();
  late int index;
  String amount = '';
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
      email = user.email; // <-- Their email
    } else {
      email = "guest";
    }
  }

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_IGocLNTGIiB2Zv',
      'amount': amount,
      'name': 'PulseBeat',
      'prefill': {'contact': '8879123205', 'email': 'contact@devot.ai'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: e");
    }
  }

  void HandlePaymentSuccess(PaymentSuccessResponse response) async {
    var userData = await fetchUserData(email!);
    if (userData == null) {
      print("No user data found.");
      return;
    }
    String fullName = userData['fullname'] ?? 'Unknown';
    String paymentID = response.paymentId!;
    String finalamount = amount;
    String subscriptionplan = index == 0
        ? "Annual Plan"
        : index == 1
            ? "Semi-Annual Plan"
            : index == 2
                ? "Monthly Plan"
                : "Invalid";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
    String status = "Success";
    await PaymentUpload.insertValueIntoSpreadsheet(email!, fullName, paymentID,
        finalamount, subscriptionplan, formattedDate, status);
    Fluttertoast.showToast(msg: "Payment Succesful!");
  }

  void HandlePaymentError(PaymentFailureResponse response) async {
    var userData = await fetchUserData(email!);
    if (userData == null) {
      print("No user data found.");
      return;
    }
    String fullName = userData['fullname'] ?? 'Unknown';
    String paymentID = "NA";
    String finalamount = amount;
    String subscriptionplan = index == 0
        ? "Annual Plan"
        : index == 1
            ? "Semi-Annual Plan"
            : index == 2
                ? "Monthly Plan"
                : "Invalid";
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
    String status = "Failed with error ${response.message}";
    await PaymentUpload.insertValueIntoSpreadsheet(email!, fullName, paymentID,
        finalamount, subscriptionplan, formattedDate, status);
    Fluttertoast.showToast(msg: "Payment Failed " + response.message!);
  }

  void HandleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet " + response.walletName!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    index = widget.index;
    if (index == 0) {
      amount = "949";
    } else if (index == 1) {
      amount = "499";
    } else if (index == 2) {
      amount = "99";
    } else {
      amount = "Invalid Amount";
    }
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, HandlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, HandlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, HandleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff001F3F),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff352980),
                Color(0xff604AE6),
                Color(0xff352980),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        actions: [
          Container(
            // padding: EdgeInsets.only(
            //   left: (10 / 411.42857142857144) * screenWidth,
            // ), // Add some margin here
            margin: EdgeInsets.only(right: (237 / 360) * screenWidth),
            child: IconButton(
              icon: Icon(
                Icons.menu_sharp,
                size: (30 / 784) * screenHeight,
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
            margin: EdgeInsets.only(right: (25 / 360) * screenWidth),
            child: Image.asset(
              "assets/images/app_bar_end_icon.png",
            ),
          ),
        ],
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     IconButton(
        //         color: Colors.white,
        //         // onPressed: () async {
        //         //   await FirebaseAuth.instance.signOut();
        //         //   clearChatData();
        //         //   Get.back();
        //         // },
        //         icon: const Icon(
        //           Icons.menu_rounded,
        //           size: 30,
        //         )),
        //     // Text(
        //     //   "Back",
        //     //   style: GoogleFonts.raleway(
        //     //       fontSize: (16 / 784) * screenHeight,
        //     //       color: Colors.white,
        //     //       fontWeight: FontWeight.w600),
        //     // ),
        //   ],
        // ),
      ),
      backgroundColor: Colors.white,
      drawer: Container(
        width: (240 / 360) * screenWidth,
        child: Drawer(
          child: DrawerContent(),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Column(
            children: [
              SizedBox(height: (20 / 784) * screenHeight),
              Container(
                child: Image(
                    image: AssetImage('assets/images/subscription_logo.png')),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (50 / 360) * screenWidth,
                    right: (50 / 360) * screenWidth,
                    top: (20 / 784) * screenHeight),
                child: Text(
                  'Get Premium',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.saira(
                    fontSize: (24 / 784) * screenHeight,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4600A9),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (20 / 360) * screenWidth,
                    right: (20 / 360) * screenWidth,
                    top: (30 / 784) * screenHeight),
                child: Text(
                  "Unlock exclusive benefits with our premium subscription. Before we proceed to the payment gateway, please review your subscription details:",
                  style: GoogleFonts.dmSans(
                      color: Color(0xff1B1B1B),
                      fontWeight: FontWeight.w400,
                      fontSize: (16 / 784) * screenHeight),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (20 / 360) * screenWidth,
                    right: (20 / 360) * screenWidth,
                    top: (30 / 784) * screenHeight),
                child: Text(
                  index == 0
                      ? 'Annual Plan'
                      : index == 1
                          ? 'Semi-Annual Plan'
                          : index == 2
                              ? 'Monthly Plan'
                              : 'No Plan Selected',
                  style: GoogleFonts.saira(
                      color: Color(0xff344054),
                      fontWeight: FontWeight.w500,
                      fontSize: (16 / 784) * screenHeight),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB((25 / 360) * screenWidth,
                    (20 / 784) * screenHeight, (25 / 360) * screenWidth, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  readOnly: true,
                  controller: amtController,
                  decoration: InputDecoration(
                    hintText: "Amount: $amount",
                    hintStyle: GoogleFonts.saira(
                      fontSize: (16 / 784) * screenHeight,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff708090),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                        (16 / 360) * screenWidth,
                        (18 / 784) * screenHeight,
                        (19 / 360) * screenWidth,
                        (15 / 784) * screenHeight),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff6200EE),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(
                            0xff6200EE), // Change color to the desired border color
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (15 / 784) * screenHeight,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                margin: EdgeInsets.only(
                    top: (15 / 784) * screenHeight,
                    left: (60 / 384) * screenWidth,
                    right: (60 / 384) * screenWidth),
                child: SizedBox(
                  height: (60 / 784) * screenHeight,
                  width: (211 / 384) * screenWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff4600A9),
                          Color(0xff001F7D),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (amount.isNotEmpty) {
                          setState(() {
                            int finalamount = int.parse(amount);
                            print(finalamount);
                            openCheckout(finalamount);
                          });
                        }
                      },
                      child: Text(
                        'Make Payment',
                        style: GoogleFonts.dmSans(
                            fontSize: (18 / 784) * screenHeight,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffF9FFFF)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                    (35 / 411.42857142857144) * screenWidth,
                    (40 / 784) * screenHeight,
                    0,
                    0),
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
        ],
      ),
    );
  }
}
