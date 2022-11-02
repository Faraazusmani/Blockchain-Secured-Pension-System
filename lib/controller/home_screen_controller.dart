import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  Rx<String> dropDownValue = "Select pension type".obs;

  void toggleDropDown(String value) {
    dropDownValue.value = value;
  }
}
