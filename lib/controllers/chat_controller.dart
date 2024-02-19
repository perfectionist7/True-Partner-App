import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initaliseQues();
    initialiseQuesSet();
    initalisechats();
  }

  int index = 0;

  List<String> questions = [];
  var ques1 = "How is your mood ?";
  var ques2 = "What is your favourite colour?";

  List<List<String>> questionSet = [];
  var set1 = [
    "I am feeling happy today lets go and do something ",
    "I am feeling sad today",
    "I am feeling angry today",
    "I am feeling lucky today"
  ];
  var set2 = ["Black", "Red", "Blue"];

  List<Map<String, String>> chats = [];
  var map1 = {"id": "0", "text": "Hello"};
  var map2 = {"id": "1", "text": "Hey"};

  initalisechats() async {
    chats.add(map1);
    chats.add(map2);
    Map<String, String> reciever = {};
    reciever.addAll({"id": "1", "text": questions[0]});
    chats.add(reciever);
  }

  initaliseQues() async {
    questions.add(ques1);
    questions.add(ques2);
  }

  initialiseQuesSet() async {
    questionSet.add(set1);
    questionSet.add(set2);
  }

  var msgController = TextEditingController();
  var isloading = false.obs;
}
