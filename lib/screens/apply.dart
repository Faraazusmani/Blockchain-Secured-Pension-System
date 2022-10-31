import 'package:flutter/material.dart';
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/utilities.dart';

class Apply extends StatelessWidget {
  const Apply({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(title: "Secure Pension", backButton: true),
      body: SizedBox(
        height: size.height - 20,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  height: 700,
                  width: size.width - 100,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Container(
                      height: 550,
                      width: size.width - 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(height: 50),
                          const Text(
                            "Select region",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1),
                          ),
                          const SizedBox(height: 30),
                          createButton(
                            text: "District",
                            onPressed: () {},
                          ),
                          createButton(
                            text: "State",
                            onPressed: () {},
                          ),
                          createButton(
                            text: "National",
                            onPressed: () {},
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
