import 'package:get/get.dart';
import 'package:pension_blockchain/models/applied_schemes_model.dart';

class AppliedSchemesController extends GetxController {
  List<SchemeAppliedDetails> applied = <SchemeAppliedDetails>[];

  void addApplied(List<SchemeAppliedDetails> details) {
    applied.clear();
    applied.addAll(details);
  }
}
