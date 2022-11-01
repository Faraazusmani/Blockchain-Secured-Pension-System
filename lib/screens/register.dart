import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/controller/register_controller.dart';
import 'package:pension_blockchain/utilities.dart';

class Register extends StatelessWidget {
  Register({Key? key, required this.classification}) : super(key: key);
  final String classification;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _empId = TextEditingController();
  final TextEditingController _salId = TextEditingController();
  final TextEditingController _publicKey = TextEditingController();
  final RegisterController _controller = RegisterController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Register", backButton: true),
      body: SizedBox(
        height: size.height - 20,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            BoxInBox(
              height: 800,
              width: min(700, size.width - 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Register new user",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  textInput(text: "Name", width: 500, controller: _name),
                  textInput(
                      text: "Employee Id", width: 500, controller: _empId),
                  textInput(text: "Salary Id", width: 500, controller: _salId),
                  textInput(
                      text: "Public Key", width: 500, controller: _publicKey),
                  Obx(
                    () => createButton(
                        onPressed: () async {
                          DateTime? dob = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2022),
                              firstDate: DateTime(1920),
                              lastDate: DateTime.now());
                          if (dob != null) {
                            String formattedDob =
                                "${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year}";
                            _controller.updateDob(formattedDob);
                          }
                        },
                        text: _controller.dob.value.isEmpty
                            ? "Date of Birth"
                            : _controller.dob.value,
                        width: 200,
                        color: Colors.white),
                  ),
                  createButton(onPressed: () {}, text: "Register")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
