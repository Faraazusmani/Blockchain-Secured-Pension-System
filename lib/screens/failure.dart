import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pension_blockchain/screens/home_screen.dart';
import 'package:pension_blockchain/utilities.dart';

class Failure extends StatelessWidget {
  const Failure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height - 20,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            BoxInBox(
              height: 600,
              width: min(700, size.width - 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Failure",
                      style: TextStyle(
                          fontSize: 30, letterSpacing: 1, color: Colors.green)),
                  const Text(
                    "Some error occurred while processing your request\nPlease try again later",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  createButton(
                    text: "Return to Homepage",
                    width: 200,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
