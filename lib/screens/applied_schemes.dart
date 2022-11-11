import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/controller/applied_schemes_controller.dart';
import 'package:pension_blockchain/models/applied_schemes_model.dart';
import 'package:pension_blockchain/utilities.dart';

class AppliedSchemes extends StatelessWidget {
  AppliedSchemes({Key? key}) : super(key: key);
  final AppliedSchemesController appliedSchemesController = Get.find();

  Future openScheme(SchemeAppliedDetails detail, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(detail.scheme.schemeId),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Name: ${detail.scheme.schemeName}"),
                  Text("Type: ${detail.scheme.classification}"),
                  Text(
                      "Applied date: ${detail.appliedDate.day}/${detail.appliedDate.month}/${detail.appliedDate.year}"),
                  Text(
                      "Last Renewed: ${detail.lastRenewed.day}/${detail.lastRenewed.month}/${detail.lastRenewed.year}"),
                  Text(
                      "Next Renewal Date: ${detail.nextRenewalDate.day}/${detail.nextRenewalDate.month}/${detail.nextRenewalDate.year}"),
                  Text("Amount: ${detail.scheme.amount}"),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<SchemeAppliedDetails> allSchemes = appliedSchemesController.applied;
    return Scaffold(
      appBar: myAppBar(title: "Applied", backButton: true),
      body: SizedBox(
        height: size.height - 20,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            BoxInBox(
              height: 700,
              width: min(700, size.width - 50),
              child: allSchemes.isEmpty
                  ? const Center(
                      child: Text(
                        "No data",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allSchemes.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                openScheme(allSchemes[i], context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(allSchemes[i].scheme.schemeId),
                                  Text(allSchemes[i].scheme.schemeName,
                                      overflow: TextOverflow.fade),
                                  Text(allSchemes[i].scheme.amount.toString())
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
