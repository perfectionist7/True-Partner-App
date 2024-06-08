import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // initaliseQues();
    initialiseQuesSet();
    // initalisechats();
  }

  int index = 0;

  List<String> questionSet = [];
  var set1 = [
    "I'm feeling overwhelmed. Can you help me understand why?",
    "I want to feel happier. Do you have any tips or activities that might help?",
    "I've been feeling sad lately. Can you suggest some ways to cope with these feelings?",
    "I'm experiencing a lot of anger. How can I manage my anger better?"
  ];

  List<Map<String, String>> chats = [];
  // var map1 = {"id": "0", "text": "Hello"};
  // var map2 = {"id": "1", "text": "Hey"};

  // initalisechats() async {
  //   chats.add(map1);
  //   chats.add(map2);
  //   Map<String, String> reciever = {};
  //   reciever.addAll({"id": "1", "text": questions[0]});
  //   chats.add(reciever);
  // }

  // initaliseQues() async {
  //   questions.add(ques1);
  //   questions.add(ques2);
  // }

  initialiseQuesSet() async {
    questionSet = set1;
    // questionSet.add(set1);
    // questionSet.add(set2);
  }

  var msgController = TextEditingController();
  var isloading = false.obs;
}
