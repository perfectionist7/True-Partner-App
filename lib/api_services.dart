import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controllers/chat_controller.dart';

var base =
    "https://je42hct7adwr6stopdxzfxc6v40cndnr.lambda-url.eu-north-1.on.aws";

var optionsbase =
    "https://pqw5apzsmxgufbk5ig3ltkryey0foakg.lambda-url.eu-north-1.on.aws";

var controller = Get.find<ChatsController>();

var latestdata = "";

var errorquestionset = [
  "Sorry, request timed out",
  "Sorry, request timed out",
  "Sorry, request timed out",
  "Sorry, request timed out"
];
getOptions(content) async {
  Uri url = Uri.parse("$optionsbase/tp_options");

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };
  var data = jsonEncode({"name": content});
  print(content);
  var post = await http.post(url, headers: headers, body: data);

  try {
    if (post.statusCode == 200) {
      var jsonData = jsonDecode(post.body);
      List<String> questionSet = [];

      jsonData.forEach((key, value) {
        // Split the response by newline character
        var sentences = value.split('\n');
        sentences.forEach((sentence) {
          // Remove numbers, dots, and question marks using regex
          var trimmedSentence =
              sentence.replaceAll(RegExp(r'^\d+\.\s|\?|"|-'), '').trim();

          // Add the trimmed sentence to the questionSet
          questionSet.add(trimmedSentence);
        });
      });
      print(questionSet);
      controller.questionSet = questionSet;

      print("Ans Fetched Successfully");
    } else {
      print("error");
      controller.questionSet = errorquestionset;
    }
  } catch (e) {
    print(e.toString());
  }
}

postData(content) async {
  Uri url = Uri.parse("$base/product_description");

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };
  var data = jsonEncode({"name": content});
  print(content);
  var post = await http.post(url, headers: headers, body: data);
  try {
    if (post.statusCode == 200) {
      var jsonData = jsonDecode(post.body);
      Map<String, String> reciever = {};
      reciever.addAll({"id": "1", "text": jsonData["product_description"]});
      latestdata = jsonData["product_description"];
      controller.chats.add(reciever);
      print("Ans Fetched Successfully");
      await getOptions(latestdata);
    } else {
      print("Error During Posting Data");
    }
  } catch (e) {
    print(e.toString());
  }
}
