import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pension_blockchain/constants.dart';

PreferredSizeWidget myAppBar({String? title, bool? backButton}) {
  return AppBar(
    title: Text(title!),
    elevation: 10.0,
    backgroundColor: kPrimaryColor,
    automaticallyImplyLeading: backButton!,
  );
}

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
              borderSide: BorderSide(color: kPrimaryColor),
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
    Color color = kPrimaryColor,
    double height = 40,
    double width = 150}) {
  return SizedBox(
    height: height,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: color == kPrimaryColor ? Colors.black : kPrimaryColor,
          width: 0.6,
        ),
      ),
      child: SizedBox(
        width: width,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(
                color: color == kPrimaryColor ? Colors.white : kPrimaryColor,
                fontSize: 20),
          ),
        ),
      ),
    ),
  );
}

Future myAlertBox(
    {required String title,
    required String desc,
    required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    ),
  );
}

class BoxInBox extends StatelessWidget {
  const BoxInBox(
      {Key? key,
      required this.height,
      required this.width,
      required this.child})
      : super(key: key);
  final double height;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Container(
              height: (6 / 7) * height,
              width: width - 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

Widget loadingOverlay({required bool loading}) {
  return loading
      ? BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
          child: const Center(
              child: SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(
                backgroundColor: Colors.grey, color: kPrimaryColor),
          )),
        )
      : const SizedBox(height: 0, width: 0);
}
