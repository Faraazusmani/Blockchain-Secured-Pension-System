import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pension_blockchain/utilities.dart';

class Apply extends StatelessWidget {
  const Apply({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Secure Pension", backButton: true),
      body: SizedBox(
        height: size.height - 20,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            BoxInBox(
                height: 500,
                width: min(700, size.width - 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Select region",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 30),
                    createButton(
                      text: "District",
                      onPressed: () {},
                    ),
                    createButton(
                      text: "State",
                      onPressed: () {},
                    ),
                    createButton(
                      text: "National",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 50),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
