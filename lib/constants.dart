import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar({String? title, bool? backButton}) {
  return AppBar(
    title: Text(title!),
    elevation: 10.0,
    backgroundColor: kPrimaryColor,
    automaticallyImplyLeading: backButton!,
  );
}

bool isPc = defaultTargetPlatform == TargetPlatform.windows;
bool isPhone = defaultTargetPlatform == TargetPlatform.android;
bool isWeb = kIsWeb;
Color kPrimaryColor = const Color(0xff7227fe);

Widget textInput(
    {String? text, double? width, TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.6),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff7227fe)),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          labelText: text,
          labelStyle: const TextStyle(color: Colors.grey),
          hintText: 'Enter Your ${text!}',
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    ),
  );
}

Widget createButton(
    {String? text,
    required Function() onPressed,
    double height = 40,
    double width = 150}) {
  return SizedBox(
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.black,
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(
          color: Colors.black,
          width: 0.6,
        ),
      ),
      child: SizedBox(
        width: width,
        child: Center(
          child: Text(
            text!,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
