import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pension_blockchain/screens/failure.dart';
import 'package:pension_blockchain/utilities.dart';

class Renewal extends StatelessWidget {
  Renewal({Key? key}) : super(key: key);
  final TextEditingController _salaryId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Renewal", backButton: true),
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
                  const Text(
                    "Pension Renewal",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  textInput(
                      text: "Salary Id", width: 500, controller: _salaryId),
                  createButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Failure()));
                      },
                      text: "Confirm"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
