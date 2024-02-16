import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customTextField({String? title, String? hint, controller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      title!.text
          .color(Colors.white)
          .fontFamily("sans_semibold")
          .size(16)
          .make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontFamily: "sans_semibold",
              color: Color(0xff708090),
            ),
            hintText: hint,
            isDense: true,
            fillColor: Colors.grey[300],
            filled: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff6200EE)))),
      ),
      5.heightBox,
    ],
  );
}
