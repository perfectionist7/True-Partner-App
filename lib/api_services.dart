import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controllers/chat_controller.dart';

var base =
    "https://z6oadbxpe63y2guepx7oi4q5xq0cpkir.lambda-url.eu-north-1.on.aws";

var controller = Get.find<ChatsController>();

postData(content) async {
  Uri url = Uri.parse("$base/product_description");

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };
  var data = jsonEncode({"name": content, "notes": ""});
  var post = await http.post(url, headers: headers, body: data);

  try {
    if (post.statusCode == 200) {
      var jsonData = jsonDecode(post.body);
      Map<String, String> sender = {};
      sender.addAll({"id": "0", "text": content});
      Map<String, String> reciever = {};
      reciever.addAll({"id": "1", "text": jsonData["product_description"]});
      controller.chats.add(sender);
      controller.chats.add(reciever);
      print(jsonData);
      print("Ans Fetched Successfully");
    } else {
      print("Error During Posting Data");
    }
  } catch (e) {
    print(e.toString());
  }
}
