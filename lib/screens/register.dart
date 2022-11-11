import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/contract_linking/contract_linking.dart';
import 'package:pension_blockchain/controller/loading_overlay_controller.dart';
import 'package:pension_blockchain/controller/register_controller.dart';
// import 'package:pension_blockchain/screens/failure.dart';
import 'package:pension_blockchain/screens/home_screen.dart';
import 'package:pension_blockchain/screens/login_screen.dart';
import 'package:pension_blockchain/utilities.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _empId = TextEditingController();
  final TextEditingController _salId = TextEditingController();
  final RegisterController _registerController = RegisterController();
  final ContractLinking _contractLinking = ContractLinking();
  final LoadingOverlayController _loadingOverlayController =
      LoadingOverlayController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _contractLinking.initialSetup();
    return Scaffold(
      appBar: myAppBar(title: "Register", backButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            SizedBox(
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
                            text: "Employee Id",
                            width: 500,
                            controller: _empId),
                        textInput(
                            text: "Salary Id", width: 500, controller: _salId),
                        Obx(
                          () => createButton(
                              onPressed: () async {
                                DateTime? dob = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime(DateTime.now().year - 25),
                                    firstDate:
                                        DateTime(DateTime.now().year - 100),
                                    lastDate:
                                        DateTime(DateTime.now().year - 25));
                                if (dob != null) {
                                  String formattedDob =
                                      "${dob.day.toString().padLeft(2, '0')}/${dob.month.toString().padLeft(2, '0')}/${dob.year}";
                                  _registerController.updateDob(formattedDob);
                                }
                              },
                              text: _registerController.dob.value.isEmpty
                                  ? "Date of Birth"
                                  : _registerController.dob.value,
                              width: 200,
                              color: Colors.white),
                        ),
                        createButton(
                            onPressed: () {
                              if (_name.text.isEmpty ||
                                  _empId.text.isEmpty ||
                                  _salId.text.isEmpty ||
                                  _registerController.dob.isEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          icon: const Icon(
                                              Icons.incomplete_circle),
                                          title: const Text("Empty fields"),
                                          content: const Text(
                                              "Please fill out all fields to continue"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("OK"))
                                          ],
                                        ));
                              } else {
                                _loadingOverlayController.toggleLoading();
                                _contractLinking
                                    .registerUser(
                                        name: _name.text,
                                        empId: _empId.text,
                                        salId: _salId.text,
                                        dob: _registerController.dob.value)
                                    .then((status) {
                                  _loadingOverlayController.toggleLoading();
                                  if (status == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Icon(
                                            Icons.error_outline_rounded),
                                        content: const Text(
                                            """Some error occurred while processing your request
                                      \nPlease try again later"""),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          LoginScreen()),
                                                  (route) => false);
                                            },
                                            child: const Text("OK"),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            text: "Register")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => loadingOverlay(
                loading: _loadingOverlayController.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
