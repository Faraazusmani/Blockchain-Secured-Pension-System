import 'package:get/get.dart';

class LoadingOverlayController extends GetxController {
  Rx<bool> isLoading = false.obs;

  void toggleLoading() => isLoading.value = !isLoading.value;
}
