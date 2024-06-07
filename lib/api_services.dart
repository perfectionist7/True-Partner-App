import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'controllers/chat_controller.dart';
import 'package:intl/intl.dart';

var base =
    "https://xryywrwlmvurbl3llbvw4h6lc40mfrzi.lambda-url.eu-north-1.on.aws";

var optionsbase =
    "https://xryywrwlmvurbl3llbvw4h6lc40mfrzi.lambda-url.eu-north-1.on.aws";

var controller = Get.find<ChatsController>();
String? email;
Future<Map<String, dynamic>?> fetchUserData(String email) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("newUsers")
        .doc(email)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      print("No such document!");
      return null;
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
  }
}

Future<List<Map<String, dynamic>>?> fetchLastFiveConversations(
    String email) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("newUsers")
        .doc(email)
        .collection("conversations")
        .orderBy("date&time", descending: true)
        .limit(5)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } else {
      print("No documents found!");
      return null;
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return null;
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

postConvo(content) async {
  Uri url = Uri.parse("$optionsbase/conversation");

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };
  var data = jsonEncode({"name": "Conversation history: \n$content"});
  print(content);
  var post = await http.post(url, headers: headers, body: data);

  try {
    if (post.statusCode == 200) {
      var jsonData = jsonDecode(post.body);
      latestdata = jsonData["convo_result"];
      print(latestdata);
      getCurrentUser();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
      List<String> lines = latestdata.trim().split('\n');

      // Assign each line to the respective variable
      String diagnosis = lines.length > 0 ? lines[0].trim() : '';
      String goal = lines.length > 1 ? lines[1].trim() : '';
      String solution = lines.length > 2 ? lines[2].trim() : '';
      FirebaseFirestore.instance
          .collection("newUsers")
          .doc(email)
          .collection("conversations")
          .doc(formattedDate)
          .set({
        'diagnosis': "$diagnosis",
        'date&time': "$formattedDate",
        'goal': "$goal",
        'solution': "$solution"
      });

      print(latestdata);
    } else {
      print("Error During Posting Data");
    }
  } catch (e) {
    print(e.toString());
  }
}

postData(content) async {
  String previousdiagnosis = "";
  Uri url = Uri.parse("$base/product_description");
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("No user is currently signed in.");
    return;
  }
  String email = user.email!;
  // Fetch user data from Firebase
  var userData = await fetchUserData(email);
  if (userData == null) {
    print("No user data found.");
    return;
  }

  List<Map<String, dynamic>>? conversations =
      await fetchLastFiveConversations(email);
  if (conversations != null) {
    for (var conversation in conversations) {
      previousdiagnosis += "$conversation" + "\n";
    }
  }

  previousdiagnosis = "Previous conversation analysis: \n" + previousdiagnosis;
  String fullName = userData['fullname'] ?? 'Unknown';
  String feeling = userData['how_are_you_feeling_today'] ?? 'Unknown';
  String anxiety =
      userData['have_you_been_experiencing_any_anxiety_or_stress_recently'] ??
          'Unknown';
  String sleep = userData['do_you_have_trouble_sleeping_at_night'] ?? 'Unknown';
  String mood = userData[
          'how_would_you_rate_your_overall_mood_on_a_scale_from_1_to_10'] ??
      'Unknown';
  String help = userData[
          'are_you_currently_receiving_any_professional_help_for_your_mental_health'] ??
      'Unknown';

  // Create a string with the user's information
  var userInfo = """
userinfo: User's Full Name: $fullName,Feeling Today: $feeling, Experiencing Anxiety or Stress: $anxiety, Trouble Sleeping at Night: $sleep, Overall Mood (1-10): $mood, Receiving Professional Help: $help""";

  var headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };
  // Prepend the user's information to the content
  var data = jsonEncode({"name": "$previousdiagnosis\n$userInfo\n$content"});
  print(content);
  var post = await http.post(url, headers: headers, body: data);
  data = jsonEncode({"name": "$content"});
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
      Map<String, String> reciever = {};
      reciever.addAll({
        "id": "1",
        "text":
            "It seems like I am unable to process your request, please calm down and try again in a few seconds."
      });
      controller.chats.add(reciever);
      print("Error During Posting Data");
    }
  } catch (e) {
    print(e.toString());
  }
}
