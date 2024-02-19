import 'api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Widget build(BuildContext context) {
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
                      size: 14,
                    )),
                Text(
                  "Back",
                  style: GoogleFonts.raleway(
                      fontSize: 16,
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
                                    top: 10, left: 10, right: 10),
                                child: Align(
                                    alignment: data["id"] ==
                                            "0" //id=0 is for the user, 1 for chatbot
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      data["text"]!,
                                      style: GoogleFonts.dmSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )));
                          },
                        ))),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount:
                  (controller.questionSet[controller.index].length / 2).ceil(),
              itemBuilder: (BuildContext context, int rowIndex) {
                int firstIndex = rowIndex * 2;
                int secondIndex = firstIndex + 1;

                // Check if second index exceeds the length of the list
                bool isSecondIndexValid = secondIndex <
                    controller.questionSet[controller.index].length;

                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Color(0xffD3D3D3)),
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: ListTile(
                          title: Text(
                            controller.questionSet[controller.index]
                                [firstIndex],
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              Map<String, String> sender = {
                                "id": "0",
                                "text": controller.questionSet[controller.index]
                                    [firstIndex],
                              };
                              controller.chats.add(sender);

                              if (controller.index <
                                  controller.questions.length - 1) {
                                controller.index += 1;
                                Map<String, String> receiver = {
                                  "id": "1",
                                  "text":
                                      controller.questions[controller.index],
                                };
                                controller.chats.add(receiver);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    if (isSecondIndexValid)
                      Expanded(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.fromLTRB(5, 0, 20, 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Color(0xffD3D3D3)),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            title: Text(
                              controller.questionSet[controller.index]
                                  [secondIndex],
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                Map<String, String> sender = {
                                  "id": "0",
                                  "text":
                                      controller.questionSet[controller.index]
                                          [secondIndex],
                                };
                                controller.chats.add(sender);

                                if (controller.index <
                                    controller.questions.length - 1) {
                                  controller.index += 1;
                                  Map<String, String> receiver = {
                                    "id": "1",
                                    "text":
                                        controller.questions[controller.index],
                                  };
                                  controller.chats.add(receiver);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.msgController,
                decoration: const InputDecoration(
                  hintText: "Write a message...",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.grey,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.grey,
                  )),
                ),
              )),
              IconButton(
                  onPressed: () async {
                    await postData(controller.msgController.text);
                    setState(() {});
                    controller.msgController.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.red,
                  ))
            ],
          )
              .box
              .height(80)
              .margin(const EdgeInsets.only(bottom: 0))
              .padding(const EdgeInsets.all(8.0))
              .make(),
        ],
      ),
    );
  }
}
