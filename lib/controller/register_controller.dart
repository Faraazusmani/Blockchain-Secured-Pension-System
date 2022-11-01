import 'package:get/get.dart';

class RegisterController extends GetxController {
  Rx<String> dob = "".obs;

  void updateDob(String value) => dob.value = value;
}
