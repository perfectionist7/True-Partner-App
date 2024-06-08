import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawer_content.dart';

class RazorPayGateway extends StatefulWidget {
  const RazorPayGateway({super.key, required this.index});

  @override
  State<RazorPayGateway> createState() => _RazorPayGatewayState();
  final int index;
}

class _RazorPayGatewayState extends State<RazorPayGateway> {
  late Razorpay _razorpay;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController amtController = TextEditingController();
  late int index;
  String amount = '';

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

  void HandlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Succesful! with payment ID: " + response.paymentId!);
  }

  void HandlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed! " + response.message!);
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
            margin: EdgeInsets.only(right: 237),
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
            margin: EdgeInsets.only(right: 25),
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
        width: 240,
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
              SizedBox(height: 20),
              Container(
                child: Image(
                    image: AssetImage('assets/images/subscription_logo.png')),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 20),
                child: Text(
                  'Get Premium',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.saira(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4600A9),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Text(
                  "Unlock exclusive benefits with our premium subscription. Before we proceed to the payment gateway, please review your subscription details:",
                  style: GoogleFonts.dmSans(
                      color: Color(0xff1B1B1B),
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
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
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  readOnly: true,
                  controller: amtController,
                  decoration: InputDecoration(
                    hintText: "Amount: $amount",
                    hintStyle: GoogleFonts.saira(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff708090),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 18, 19, 15),
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
                height: 15,
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
                    (35 / 411.42857142857144) * screenWidth, 40, 0, 0),
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
