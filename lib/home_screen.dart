import 'api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'check_question.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import 'controllers/chat_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = Get.put(ChatsController());

  @override
  void initState() {
    print(CheckQuestion.getAnswerFromKey("Hello"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff001F3F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                    )),
                Text(
                  "Back",
                  style: GoogleFonts.raleway(
                      fontSize: (16 / 784) * screenHeight,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            Image.asset(
              "assets/images/app_bar_end_icon.png",
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
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
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: controller.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, String> data = controller.chats[index];
                            return Container(
                                margin: EdgeInsets.only(
                                    top: (10 / 784) * screenHeight,
                                    left: (10 / 360) * screenWidth,
                                    right: (10 / 360) * screenWidth),
                                child: Align(
                                    alignment: data["id"] ==
                                            "0" //id=0 is for the user, 1 for chatbot
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      data["text"]!,
                                      style: GoogleFonts.dmSans(
                                          fontSize: (14 / 784) * screenHeight,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )));
                          },
                        ))),
          SizedBox(
            height: (80 / 784) * screenHeight, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection:
                  Axis.horizontal, // Set the scroll direction to horizontal
              itemCount: controller.questionSet[controller.index].length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: (MediaQuery.of(context).size.width -
                          (60 / 360) * screenWidth) /
                      1.25, // Divide width equally between items with padding
                  margin: const EdgeInsets.fromLTRB(15, 0, 5, 20),
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
                        controller.questionSet[controller.index][index],
                        style: GoogleFonts.dmSans(
                          fontSize: (13 / 784) * screenHeight,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          Map<String, String> sender = {
                            "id": "0",
                            "text": controller.questionSet[controller.index]
                                [index],
                          };
                          controller.chats.add(sender);

                          if (controller.index <
                              controller.questions.length - 1) {
                            controller.index += 1;
                            Map<String, String> receiver = {
                              "id": "1",
                              "text": controller.questions[controller.index],
                            };
                            controller.chats.add(receiver);
                          }
                        });
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
                          String recog = CheckQuestion.getAnswerFromKey(
                              controller.msgController.text);
                          if (recog != "No option") {
                            Map<String, String> sender = {};
                            sender.addAll({
                              "id": "0",
                              "text": controller.msgController.text
                            });
                            controller.chats.add(sender);
                            Map<String, String> reciever = {};
                            reciever.addAll({"id": "1", "text": recog});
                            controller.chats.add(reciever);
                            setState(() {});
                          } else {
                            await postData(controller.msgController.text);
                            setState(() {});
                          }
                          controller.msgController.clear();
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
