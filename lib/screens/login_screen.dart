import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pension_blockchain/screens/home_screen.dart';
import 'package:pension_blockchain/utilities.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _contractAddress = TextEditingController();
  final TextEditingController _privateKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
