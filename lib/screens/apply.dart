import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pension_blockchain/screens/available_schemes.dart';
import 'package:pension_blockchain/utilities.dart';

class Apply extends StatelessWidget {
  const Apply({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Fresh", backButton: true),
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
                      "Select option",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 30),
                    createButton(
                      text: "District",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AvailableSchemes(
                                      classification: "District",
                                    )));
                      },
                    ),
                    createButton(
                      text: "State",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AvailableSchemes(
                                      classification: "State",
                                    )));
                      },
                    ),
                    createButton(
                      text: "National",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AvailableSchemes(
                                      classification: "National",
                                    )));
                      },
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
