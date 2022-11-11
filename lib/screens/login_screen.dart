import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pension_blockchain/contract_linking/contract_linking.dart';
import 'package:pension_blockchain/controller/loading_overlay_controller.dart';
import 'package:pension_blockchain/controller/login_controller.dart';
import 'package:pension_blockchain/screens/home_screen.dart';
import 'package:pension_blockchain/screens/register.dart';
import 'package:pension_blockchain/utilities.dart';

LoginController loginController = LoginController();

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _privateKey = TextEditingController();

  final LoadingOverlayController _loadingOverlayController =
      LoadingOverlayController();
  final ContractLinking contractLinking = Get.put(ContractLinking());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            SizedBox(
              height: size.height - 20,
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                            image: AssetImage("images/blockchain_pension.jpg"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Center(
                    child: textInput(
                      text: "Private Key",
                      width: 350,
                      controller: _privateKey,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: createButton(
                        text: "Authenticate",
                        onPressed: () async {
                          // await _contractLinking.setCurrentUser();
                          // await _contractLinking.setUser();
                          _loadingOverlayController.toggleLoading();
                          loginController.updatePrivateKey(_privateKey.text);
                          // PrivateKeyController(privateKey: _privateKey.text);

                          await contractLinking
                              .initialSetup()
                              .then((value) async {
                            await contractLinking
                                .setCurrentUser()
                                .then((value) async {
                              if (value) {
                                await contractLinking
                                    .getUserRegistrationStatus()
                                    .then((registrationStatus) {
                                  _loadingOverlayController.toggleLoading();
                                  if (registrationStatus) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  } else {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()));
                                  }
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text(
                                        "Failed to fetch blockchain data\nPlease try again later"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            });
                          });
                        }),
                  ),
                ],
              ),
            ),
            Obx(() => loadingOverlay(
                loading: _loadingOverlayController.isLoading.value))
          ],
        ),
      ),
    );
  }
}
