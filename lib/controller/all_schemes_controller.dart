import 'package:pension_blockchain/models/all_schemes_model.dart';

class AllSchemesController {
  List<Schemes> schemes = <Schemes>[];

  void addSchemes(List<Schemes> details) => schemes.addAll(details);
}
