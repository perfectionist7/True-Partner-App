import 'package:deevot_new_project/api_services.dart';
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
                            return Align(
                                alignment: data["id"] == "0"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  data["text"]!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ));
                          },
                        ))),
          Expanded(
              child: ListView.builder(
                  itemCount: controller.questionSet[controller.index].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 30, 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ],
                          border: Border.all(color: const Color(0xff0A1621)),
                          color: Colors.grey[400],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(
                          controller.questionSet[controller.index][index],
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          setState(() {
                            Map<String, String> sender = {};
                            sender.addAll({
                              "id": "0",
                              "text": controller.questionSet[controller.index]
                                  [index],
                            });
                            controller.chats.add(sender);

                            if (controller.index <
                                controller.questions.length - 1) {
                              controller.index += 1;
                              Map<String, String> reciever = {};
                              reciever.addAll({
                                "id": "1",
                                "text": controller.questions[controller.index]
                              });
                              controller.chats.add(reciever);
                            }
                          });
                        },
                      ),
                    );
                  })),
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
              .margin(const EdgeInsets.only(bottom: 8))
              .padding(const EdgeInsets.all(8.0))
              .make(),
        ],
      ),
    );
  }
}
