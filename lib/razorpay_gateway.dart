import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RazorPayGateway extends StatefulWidget {
  const RazorPayGateway({super.key, required this.amount});

  @override
  State<RazorPayGateway> createState() => _RazorPayGatewayState();
  final String amount;
}

class _RazorPayGatewayState extends State<RazorPayGateway> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  late String amount;

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
    amount = widget.amount;
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Container(
              child: Image(
                image: AssetImage("assets/images/aboutus_devotai.png"),
                height: 100,
                width: 300,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "Welcome to the Razorpay Payment Gateway",
                style: TextStyle(
                    color: Color(0xff001F3E),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
              child: TextField(
                readOnly: true,
                controller: amtController,
                decoration: InputDecoration(
                  hintText: "Amount to be paid: $amount",
                  hintStyle: GoogleFonts.dmSans(
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
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (amount.isNotEmpty) {
                  setState(() {
                    int finalamount = int.parse(amount);
                    print(finalamount);
                    openCheckout(finalamount);
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Make Payment',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff001F3E),
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(
                  (40 / 411.42857142857144) * screenWidth, 200, 0, 0),
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
      ),
    );
  }
}
