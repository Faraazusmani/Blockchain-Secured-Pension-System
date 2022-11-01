import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/controller/home_screen_controller.dart';
import 'package:pension_blockchain/screens/apply.dart';
import 'package:pension_blockchain/utilities.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeScreenController _controller = HomeScreenController();
  final List<String> dropDownValues = [
    "Select pension type",
    "Fresh",
    "Renewal"
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Secure Pension", backButton: false),
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
                    "Select Pension type",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: kPrimaryColor,
                        )),
                    child: Obx(
                      () => DropdownButton<String>(
                        value: _controller.dropDownValue.toString(),
                        underline: const SizedBox(height: 0, width: 0),
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                        items: dropDownValues.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text(value),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _controller.toggleDropDown(value!);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  createButton(
                    text: "Proceed",
                    onPressed: () {
                      String selectedValue =
                          _controller.dropDownValue.value.toString();
                      if (selectedValue == dropDownValues[0]) {
                        myAlertBox(
                          title: "Pension type",
                          desc: "Please select pension type",
                          context: context,
                        );
                      } else if (selectedValue == dropDownValues[1]) {
                        _controller.dropDownValue.value = dropDownValues[0];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Apply()));
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
