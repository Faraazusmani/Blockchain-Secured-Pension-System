import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<String> privateKey = "".obs;

  void updatePrivateKey(String value) => privateKey.value = value;
}
