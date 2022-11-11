import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/contract_linking/contract_linking.dart';
import 'package:pension_blockchain/controller/applied_schemes_controller.dart';
import 'package:pension_blockchain/controller/loading_overlay_controller.dart';
import 'package:pension_blockchain/models/applied_schemes_model.dart';
import 'package:pension_blockchain/utilities.dart';

class Renewal extends StatelessWidget {
  Renewal({Key? key}) : super(key: key);
  final AppliedSchemesController appliedSchemesController = Get.find();
  final LoadingOverlayController loadingOverlayController =
      LoadingOverlayController();
  final ContractLinking contractLinking = Get.find();

  Future openScheme(
      SchemeAppliedDetails detail, int daysLeft, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(daysLeft >= 0 ? detail.scheme.schemeId : "Expired"),
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
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    loadingOverlayController.toggleLoading();
                    await contractLinking
                        .renewPension(
                            schemeId: detail.scheme.schemeId,
                            renewDate: detail.nextRenewalDate,
                            daysLeft: daysLeft)
                        .then((status) {
                      loadingOverlayController.toggleLoading();
                      if (status) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Icon(Icons.done),
                                  content: const Text(
                                      "Your pension has been renewed successfully"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Icon(Icons.error_outline),
                                  content: const Text(
                                      "Some error occurred while processing your request\nPlease try again later"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                ));
                      }
                    });
                  },
                  child: const Text("Renew"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<SchemeAppliedDetails> allSchemes = appliedSchemesController.applied;
    int count = 0;
    return Scaffold(
      appBar: myAppBar(title: "Renewal", backButton: true),
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
                            Date renewalDate = allSchemes[i].nextRenewalDate;
                            int daysLeft = DateTime(renewalDate.year,
                                    renewalDate.month, renewalDate.day)
                                .difference(DateTime.now())
                                .inDays;
                            if (daysLeft <= 10) {
                              ++count;
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
                                      openScheme(
                                          allSchemes[i], daysLeft, context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(allSchemes[i].scheme.schemeId),
                                        Text(allSchemes[i].scheme.schemeName,
                                            overflow: TextOverflow.fade),
                                        Text(allSchemes[i]
                                            .scheme
                                            .amount
                                            .toString())
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox(height: 0, width: 0);
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
          Obx(
            () => loadingOverlay(
              loading: loadingOverlayController.isLoading.value,
            ),
          )
        ],
      ),
    );
  }
}
