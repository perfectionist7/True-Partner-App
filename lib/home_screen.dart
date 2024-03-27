import 'api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/scheduler.dart';
import 'check_question.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  bool isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var controller = Get.put(ChatsController());
  ScrollController _scrollController = ScrollController();
  List<String> options = [];

  @override
  void initState() {
    super.initState();
  }

  void clearChatData() {
    controller.chats.clear();
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
        actions: [
          Container(
            // padding: EdgeInsets.only(
            //   left: (10 / 411.42857142857144) * screenWidth,
            // ), // Add some margin here
            margin: EdgeInsets.only(right: 230),
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
            margin: EdgeInsets.only(right: 20),
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
      body: Column(
        children: [
          Obx(() => controller.isloading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.purple),
                  ),
                )
              : Expanded(
                  child: controller.chats.isEmpty
                      ? Center(
                          child: "Send a message..."
                              .text
                              .color(Colors.black)
                              .make(),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: controller.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, String> data = controller.chats[index];
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
                                        top: (15 / 784) * screenHeight,
                                        left: data["id"] == "0"
                                            ? (100 / 360) * screenWidth
                                            : (5 / 360) * screenHeight,
                                        right: data["id"] == "0"
                                            ? (10 / 360) * screenWidth
                                            : (40 / 360) * screenHeight,
                                      );
                            return Padding(
                              padding: padding,
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
                                        fontSize: (14 / 784) * screenHeight,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))),
          SizedBox(
            height: (95 / 784) * screenHeight, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection:
                  Axis.horizontal, // Set the scroll direction to horizontal
              itemCount: controller.questionSet.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: (MediaQuery.of(context).size.width -
                          (60 / 360) * screenWidth) /
                      1.25, // Divide width equally between items with padding
                  margin: const EdgeInsets.fromLTRB(15, 5, 5, 10),
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
                    padding: const EdgeInsets.fromLTRB(
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
                          options = CheckQuestion.getOptionsFromKey(text);

                          controller.questionSet = options;
                          setState(() {});
                          options.clear();
                        } else {
                          await postData(text);
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
                height: 52,
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
                          String text = controller.msgController.text;
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
                            await postData(text);
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
                          height: 36,
                          width: 36,
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
