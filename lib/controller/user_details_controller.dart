import 'package:get/get.dart';
import 'package:pension_blockchain/models/user_details_model.dart';

class UserDetailsController extends GetxController {
  late UserDetails userDetails;
  bool detailsLoaded = false;

  void updateUserDetails(UserDetails user) {
    userDetails = user;
    detailsLoaded = true;
  }
}
