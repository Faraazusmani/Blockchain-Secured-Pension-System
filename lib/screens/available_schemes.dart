import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/contract_linking/contract_linking.dart';
import 'package:pension_blockchain/controller/all_schemes_controller.dart';
import 'package:pension_blockchain/controller/loading_overlay_controller.dart';
import 'package:pension_blockchain/controller/user_details_controller.dart';
import 'package:pension_blockchain/models/all_schemes_model.dart';
import 'package:pension_blockchain/screens/home_screen.dart';
import 'package:pension_blockchain/utilities.dart';

class AvailableSchemes extends StatelessWidget {
  AvailableSchemes({Key? key, required this.classification}) : super(key: key);
  final String classification;
  final AllSchemesController allSchemesController = AllSchemesController();
  final ContractLinking contractLinking = Get.find();
  final LoadingOverlayController loadingOverlayController =
      LoadingOverlayController();
  final UserDetailsController userDetailsController = Get.find();

  Future<List<Schemes>> getAllSchemes() async {
    return await contractLinking.getAllSchemes(classification);
  }

  Future openScheme(Schemes detail, BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(detail.schemeId),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${detail.schemeName}"),
                  Text("Type: ${detail.classification}"),
                  Text("Amount: ${detail.amount}"),
                  Text("Eligible Age: ${detail.eligibleAge}"),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) {
                        Date dob = userDetailsController.userDetails.dob;
                        int age = DateTime.now()
                                .difference(
                                    DateTime(dob.year, dob.month, dob.day))
                                .inDays ~/
                            365;
                        if (age >= detail.eligibleAge) {
                          return AlertDialog(
                            title: const Text("Apply"),
                            content: Text(
                                "Click confirm to apply in ${detail.schemeId} scheme"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    loadingOverlayController.toggleLoading();
                                    await contractLinking
                                        .applyPension(schemeId: detail.schemeId)
                                        .then((status) {
                                      loadingOverlayController.toggleLoading();
                                      if (status) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: const Icon(Icons.done),
                                                  content: Text(
                                                      "Successfully Applied to ${detail.schemeId}"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      HomeScreen()),
                                                              (route) => false);
                                                        },
                                                        child: const Text("OK"))
                                                  ],
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                  title: const Icon(
                                                      Icons.error_outline),
                                                  content: const Text(
                                                      """Some error occurred
                                                  \nPlease check if have already applied to this scheme
                                                  \nor try again later"""),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      HomeScreen()),
                                                              (route) => false);
                                                        },
                                                        child: const Text("OK"))
                                                  ],
                                                ));
                                      }
                                    });
                                  },
                                  child: const Text("Confirm"))
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: const Icon(Icons.not_interested),
                            content: const Text(
                                "Your age does not meet the criteria to apply"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"))
                            ],
                          );
                        }
                      },
                    );
                  },
                  child: const Text("Apply Now"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print("All - $allSchemes");
    return Scaffold(
      appBar: myAppBar(
          title: "Available $classification Schemes", backButton: true),
      body: Stack(
        children: [
          SizedBox(
            height: size.height - 20,
            child: ListView(
              children: [
                const SizedBox(height: 50),
                BoxInBox(
                    height: 700,
                    width: min(700, size.width - 50),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          "Select a scheme to view details",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 50),
                        FutureBuilder(
                          future: getAllSchemes(),
                          initialData: const [],
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Some error occurred"),
                                );
                              } else if (snapshot.hasData) {
                                final allSchemes = snapshot.data;
                                return SizedBox(
                                  height: 480,
                                  child: ListView.builder(
                                    itemCount: allSchemes!.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      // print("list - $allSchemes");
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: MaterialButton(
                                            onPressed: () {
                                              openScheme(
                                                  allSchemes[i], context);
                                            },
                                            child: Text(
                                              allSchemes[i].schemeName,
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  letterSpacing: 1),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text("No schemes available"),
                                );
                              }
                            }
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                              child: const Center(
                                  child: SizedBox(
                                height: 150,
                                width: 150,
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    color: kPrimaryColor),
                              )),
                            );
                          },
                        ),
                      ],
                    )),
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
