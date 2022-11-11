import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/contract_linking/contract_linking.dart';
import 'package:pension_blockchain/controller/applied_schemes_controller.dart';
import 'package:pension_blockchain/controller/loading_overlay_controller.dart';
import 'package:pension_blockchain/controller/user_details_controller.dart';
import 'package:pension_blockchain/screens/applied_schemes.dart';
import 'package:pension_blockchain/screens/apply.dart';
import 'package:pension_blockchain/screens/login_screen.dart';
import 'package:pension_blockchain/screens/renewal.dart';
import 'package:pension_blockchain/utilities.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<String> dropDownValues = [
    "Select pension type",
    "Fresh",
    "Renewal"
  ];
  final ContractLinking contractLinking = Get.find();
  final AppliedSchemesController appliedSchemesController =
      Get.put(AppliedSchemesController());
  final LoadingOverlayController loadingOverlayController =
      LoadingOverlayController();

  final UserDetailsController userDetailsController =
      Get.put(UserDetailsController());

  Future<void> getUserDetails() async {
    await contractLinking
        .getUserDetails()
        .then((value) => userDetailsController.detailsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int age = 0;
    if (!userDetailsController.detailsLoaded) {
      getUserDetails().then((value) {
        age = (DateTime.now()
                .difference(DateTime(
                    userDetailsController.userDetails.dob.year,
                    userDetailsController.userDetails.dob.month,
                    userDetailsController.userDetails.dob.day))
                .inDays) ~/
            365;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        actions: [
          Tooltip(
            message: "Profile details",
            child: MaterialButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Icon(Icons.person_outline),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Name: ${userDetailsController.userDetails.name}"),
                              Text(
                                  "DOB: ${(userDetailsController.userDetails.dob.day).toString().padLeft(2, '0')}/${(userDetailsController.userDetails.dob.month).toString().padLeft(2, '0')}/${userDetailsController.userDetails.dob.year}"),
                              Text("Age: $age"),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("OK"))
                          ],
                        ));
              },
              child: const Icon(Icons.person_sharp),
            ),
          ),
          Tooltip(
            message: "Log out",
            enableFeedback: true,
            child: MaterialButton(
              elevation: 10,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Log out"),
                          content: const Text(
                              "Do you want to log out of current account"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      (route) => false);
                                },
                                child: const Text("OK"))
                          ],
                        ));
              },
              child: const Icon(Icons.login_outlined),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
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
                      createButton(
                        onPressed: () async {
                          loadingOverlayController.toggleLoading();
                          await contractLinking
                              .getAllAppliedSchemes()
                              .then((details) {
                            loadingOverlayController.toggleLoading();
                            appliedSchemesController.addApplied(details);
                            // print("applied - $details");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppliedSchemes()));
                          });
                        },
                        text: "Applied",
                      ),
                      const SizedBox(height: 50),
                      createButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Apply()));
                          },
                          text: "Apply New"),
                      const SizedBox(height: 30),
                      createButton(
                          onPressed: () async {
                            loadingOverlayController.toggleLoading();
                            await contractLinking
                                .getAllAppliedSchemes()
                                .then((details) {
                              // print("applied  - --- $details");
                              loadingOverlayController.toggleLoading();
                              appliedSchemesController.addApplied(details);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Renewal()));
                            });
                          },
                          text: "Renew"),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() =>
              loadingOverlay(loading: loadingOverlayController.isLoading.value))
        ],
      ),
    );
  }
}
