import 'package:deevot_new_project/help.dart';
import 'package:deevot_new_project/subscription.dart';
import 'package:http/http.dart';

import 'api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'upload_feedback.dart';
import 'package:flutter/scheduler.dart';
import 'check_question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

import 'drawer_content.dart';

import 'controllers/chat_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String concatenatedValues = "";
  bool isDrawerOpen = false;
  String? email;
  String currentconvo = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var controller = Get.put(ChatsController());
  ScrollController _scrollController = ScrollController();
  List<String> options = [];

  @override
  void initState() {
    currentconvo = "";
    getCurrentUser();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await postConvo(currentconvo);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // Call your method here
      await postConvo(currentconvo);
    }
  }

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (user != null) {
      email = user.email; // <-- Their email
    } else {
      email = "guest";
    }
  }

  void clearChatData() {
    controller.chats.clear();
    controller.questionSet = controller.set1;
    setState(() {});
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
      ),
      backgroundColor: Colors.white,
      drawer: Container(
        width: (240 / 360) * screenWidth,
        child: Drawer(
          child: DrawerContent(),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB((10 / 411.42857142857144) * screenWidth,
                (5 / 784) * screenHeight, 0, 0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff352980), // Button colorcolor
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Color(0xffFFDE59), width: 2),
                ),
              ),
              onPressed: () async {
                await postConvo(currentconvo);
                clearChatData();
                Fluttertoast.showToast(
                    msg: "Thanks for talking, here is a new chat!");
              },
              child: Text(
                'New Chat',
                style: TextStyle(
                    fontSize: (14 / 784) * screenHeight,
                    color: Colors.white), // Text size
              ),
            ),
          ),
          Obx(
            () => controller.isloading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                    ),
                  )
                : Expanded(
                    child: controller.chats.isEmpty
                        ? Container(
                            margin:
                                EdgeInsets.only(top: (80 / 784) * screenHeight),
                            child: SizedBox(
                              height: (95 / 784) * screenHeight,
                              child: ListView.builder(
                                scrollDirection: Axis
                                    .vertical, // Set the scroll direction to horizontal
                                itemCount: controller.questionSet.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: (MediaQuery.of(context).size.width -
                                            (60 / 360) * screenWidth) /
                                        1.25, // Divide width equally between items with padding
                                    margin: EdgeInsets.fromLTRB(
                                        (50 / 360) * screenWidth,
                                        (5 / 784) * screenHeight,
                                        (50 / 360) * screenWidth,
                                        (20 / 784) * screenHeight),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      color: Color(0xffececec),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 5,
                                          0, 10), // Increased bottom padding
                                      child: ListTile(
                                        title: Text(
                                          controller.questionSet[index],
                                          style: GoogleFonts.dmSans(
                                            fontSize: (13 / 784) * screenHeight,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onTap: () async {
                                          String text =
                                              controller.questionSet[index];
                                          Map<String, String> sender = {};
                                          sender.addAll(
                                              {"id": "0", "text": text});
                                          sender.addAll({
                                            "id": "0",
                                            "text": text,
                                          });
                                          controller.chats.add(sender);
                                          SchedulerBinding.instance!
                                              .addPostFrameCallback((_) {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                          controller.msgController.clear();
                                          setState(() {});

                                          String recog =
                                              CheckQuestion.getAnswerFromKey(
                                                  text);
                                          if (recog != "No option") {
                                            Map<String, String> reciever = {};
                                            reciever.addAll(
                                                {"id": "1", "text": recog});
                                            controller.chats.add(reciever);
                                            options =
                                                CheckQuestion.getOptionsFromKey(
                                                    text);

                                            controller.questionSet = options;
                                            setState(() {});
                                            options.clear();
                                          } else {
                                            await postData(text, currentconvo);
                                          }
                                          SchedulerBinding.instance!
                                              .addPostFrameCallback((_) {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeOut,
                                            );
                                          });

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: controller.chats.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, String> data =
                                  controller.chats[index];
                              if (data["id"] == "0") {
                                if (!currentconvo!.contains(data["text"]!)) {
                                  currentconvo = currentconvo! +
                                      "\n"
                                          "user: " +
                                      data["text"]! +
                                      "\n";
                                }
                              } else if (data["id"] == "1") {
                                if (!currentconvo!.contains(data["text"]!)) {
                                  currentconvo = currentconvo! +
                                      "\n"
                                          "assistant: " +
                                      data["text"]! +
                                      "\n";
                                }
                              }
                              final EdgeInsets padding =
                                  index == controller.chats.length - 1
                                      ? EdgeInsets.only(
                                          top: (10 / 784) * screenHeight,
                                          left: data["id"] == "0"
                                              ? (100 / 360) * screenWidth
                                              : (5 / 360) * screenHeight,
                                          right: data["id"] == "0"
                                              ? (10 / 360) * screenWidth
                                              : (40 / 360) * screenHeight,
                                          bottom: (15 / 784) * screenHeight,
                                        ) // Apply padding to the last item
                                      : EdgeInsets.only(
                                          top: (10 / 784) * screenHeight,
                                          left: data["id"] == "0"
                                              ? (100 / 360) * screenWidth
                                              : (5 / 360) * screenHeight,
                                          right: data["id"] == "0"
                                              ? (10 / 360) * screenWidth
                                              : (40 / 360) * screenHeight,
                                        );
                              return Padding(
                                padding: padding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: data["id"] == "0"
                                              ? Color(0xff7F4BE8)
                                              : Color(0xff001F3F),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Align(
                                            alignment: data["id"] == "0"
                                                ? Alignment.centerLeft
                                                : Alignment.centerLeft,
                                            child: Text(
                                              data["text"]!,
                                              style: GoogleFonts.dmSans(
                                                fontSize:
                                                    (14 / 784) * screenHeight,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (data["id"] == "1")
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0), // Reduce top padding
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            icon: Icon(Icons.thumb_down,
                                                color: Colors.blueGrey,
                                                size:
                                                    (20 / 784) * screenHeight),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  double rating = 0.0;
                                                  TextEditingController
                                                      feedbackController =
                                                      TextEditingController();
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Feedback',
                                                      style: GoogleFonts.saira(
                                                        fontSize: (20 / 784) *
                                                            screenHeight,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff001F3E),
                                                      ),
                                                    ),
                                                    content: Stack(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              left: (10 / 360) *
                                                                  screenWidth),
                                                          child: Text(
                                                            'Was this chat helpful?',
                                                            style: GoogleFonts
                                                                .saira(
                                                              fontSize: (17 /
                                                                      784) *
                                                                  screenHeight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff344054),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xff6200EE), // border color
                                                                    width:
                                                                        1.0, // border width
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8))),
                                                          margin: EdgeInsets.only(
                                                              top: (40 / 784) *
                                                                  screenHeight),
                                                          child: TextFormField(
                                                            controller:
                                                                feedbackController,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              hintText:
                                                                  'Describe your experience...',
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .saira(
                                                                fontSize: (14 /
                                                                        784) *
                                                                    screenHeight,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xff667085),
                                                              ),
                                                            ),
                                                            maxLines: 5,
                                                            style: GoogleFonts
                                                                .saira(
                                                              fontSize: (14 /
                                                                      784) *
                                                                  screenHeight,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black, // input text color
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              left: (10 / 360) *
                                                                  screenWidth,
                                                              top: (180 / 784) *
                                                                  screenHeight),
                                                          child:
                                                              RatingBar.builder(
                                                            unratedColor:
                                                                Colors.white,
                                                            glowColor: Color(
                                                                0xffFFC107),
                                                            initialRating: 0,
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            onRatingUpdate:
                                                                (ratingValue) {
                                                              rating =
                                                                  ratingValue;
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(
                                                                  (0 / 360) *
                                                                      screenWidth,
                                                                  (240 / 784) *
                                                                      screenHeight,
                                                                  (10 / 360) *
                                                                      screenWidth,
                                                                  (10 / 784) *
                                                                      screenHeight),
                                                              height: (50 /
                                                                      784) *
                                                                  screenHeight,
                                                              width: (105 /
                                                                      360) *
                                                                  screenWidth,
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Cancel',
                                                                          style: GoogleFonts.dmSans(
                                                                              fontSize: (16 / 784) *
                                                                                  screenHeight,
                                                                              fontWeight: FontWeight
                                                                                  .w700,
                                                                              color: Color(
                                                                                  0xff6750A4))),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Color(0xffF3EDF7),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          side: BorderSide(
                                                                              color: Color(0xffD3D3D3),
                                                                              width: 1),
                                                                        ),
                                                                      )),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.fromLTRB(
                                                                  (10 / 360) *
                                                                      screenWidth,
                                                                  (240 / 784) *
                                                                      screenHeight,
                                                                  (0 / 360) *
                                                                      screenWidth,
                                                                  (10 / 784) *
                                                                      screenHeight),
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xff4600A9),
                                                                    Color(
                                                                        0xff001F7D),
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                              ),
                                                              height: (50 /
                                                                      784) *
                                                                  screenHeight,
                                                              width: (105 /
                                                                      360) *
                                                                  screenWidth,
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (feedbackController
                                                                            .text
                                                                            .isEmpty) {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Please enter your feedback");
                                                                          return;
                                                                        }
                                                                        User? user = FirebaseAuth
                                                                            .instance
                                                                            .currentUser;
                                                                        if (user ==
                                                                            null) {
                                                                          print(
                                                                              "No user is currently signed in.");
                                                                          return;
                                                                        }
                                                                        String
                                                                            email =
                                                                            user.email!;
                                                                        var userData =
                                                                            await fetchUserData(email);
                                                                        if (userData ==
                                                                            null) {
                                                                          print(
                                                                              "No user data found.");
                                                                          return;
                                                                        }
                                                                        String
                                                                            fullName =
                                                                            userData['fullname'] ??
                                                                                'Unknown';
                                                                        String
                                                                            feedback =
                                                                            feedbackController.text;
                                                                        await ConversationUpload.insertValueIntoSpreadsheet(
                                                                            fullName,
                                                                            email,
                                                                            feedback,
                                                                            currentconvo!,
                                                                            (index + 1).toString(),
                                                                            rating.toString());
                                                                        print(
                                                                            'Feedback: $feedback');
                                                                        print(
                                                                            'Rating: $rating');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "We have recieved your feedback, we will make sure this does not happen again!");
                                                                      },
                                                                      child: Text(
                                                                          'Submit',
                                                                          style: GoogleFonts.dmSans(
                                                                              fontSize: (16 / 784) *
                                                                                  screenHeight,
                                                                              fontWeight: FontWeight
                                                                                  .w700,
                                                                              color: Colors
                                                                                  .white)),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12)),
                                                                      )),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
          ),
          controller.chats.isEmpty
              ? Container()
              : SizedBox(
                  height:
                      (95 / 784) * screenHeight, // Adjust the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis
                        .horizontal, // Set the scroll direction to horizontal
                    itemCount: controller.questionSet.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: (MediaQuery.of(context).size.width -
                                (60 / 360) * screenWidth) /
                            1.25, // Divide width equally between items with padding
                        margin: EdgeInsets.fromLTRB(
                            (15 / 360) * screenWidth,
                            (5 / 784) * screenHeight,
                            (5 / 360) * screenWidth,
                            (10 / 784) * screenHeight),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          color: Color(0xffececec),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              5, 5, 0, 10), // Increased bottom padding
                          child: ListTile(
                            title: Text(
                              controller.questionSet[index],
                              style: GoogleFonts.dmSans(
                                fontSize: (13 / 784) * screenHeight,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () async {
                              String text = controller.questionSet[index];
                              Map<String, String> sender = {};
                              sender.addAll({"id": "0", "text": text});
                              sender.addAll({
                                "id": "0",
                                "text": text,
                              });
                              controller.chats.add(sender);
                              SchedulerBinding.instance!
                                  .addPostFrameCallback((_) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              });
                              controller.msgController.clear();
                              setState(() {});

                              String recog =
                                  CheckQuestion.getAnswerFromKey(text);
                              if (recog != "No option") {
                                Map<String, String> reciever = {};
                                reciever.addAll({"id": "1", "text": recog});
                                controller.chats.add(reciever);
                                options = CheckQuestion.getOptionsFromKey(text);

                                controller.questionSet = options;
                                setState(() {});
                                options.clear();
                              } else {
                                await postData(text, currentconvo);
                              }
                              SchedulerBinding.instance!
                                  .addPostFrameCallback((_) {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              });

                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: (52 / 784) * screenHeight,
                margin: EdgeInsets.only(
                    left: (24 / 360) * screenWidth,
                    top: (0 / 784) * screenHeight,
                    right: (24 / 360) * screenWidth,
                    bottom: (12 / 784) * screenHeight),
                child: TextFormField(
                  controller: controller.msgController,
                  decoration: InputDecoration(
                    hintText: "Write a message...",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffFFDE59))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffFFDE59))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffFFDE59))),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          String text = concatenatedValues +
                              controller.msgController.text;

                          Map<String, String> sender = {};
                          sender.addAll({"id": "0", "text": text});
                          sender.addAll({
                            "id": "0",
                            "text": text,
                          });
                          controller.chats.add(sender);
                          FocusScope.of(context).unfocus();
                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                          controller.msgController.clear();
                          setState(() {});

                          String recog = CheckQuestion.getAnswerFromKey(text);
                          if (recog != "No option") {
                            Map<String, String> reciever = {};
                            reciever.addAll({"id": "1", "text": recog});
                            controller.chats.add(reciever);
                            FocusScope.of(context).unfocus();
                            // Scroll to the bottom of the ListView
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                            print(text);
                            print(CheckQuestion.getOptionsFromKey(text));
                            options = CheckQuestion.getOptionsFromKey(text);
                            // print("options are $options");
                            print(options);
                            controller.questionSet = options;
                            setState(() {});
                            options.clear();
                          } else {
                            await postData(text, currentconvo);
                          }

                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                          setState(() {});
                        },
                        icon: Image(
                          image:
                              new AssetImage("assets/images/send_button.png"),
                          height: (36 / 784) * screenHeight,
                          width: (36 / 360) * screenWidth,
                          color: null,
                          alignment: Alignment.center,
                        )),
                  ),
                ),
              )),

              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: IconButton(
              //       onPressed: () async {
              //         await postData(controller.msgController.text);
              //         setState(() {});
              //         controller.msgController.clear();
              //       },
              //       icon: Image(
              //         image: new AssetImage("assets/images/send_button.png"),
              //         height: 36,
              //         width: 36,
              //         color: null,
              //         alignment: Alignment.center,
              //       )),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
