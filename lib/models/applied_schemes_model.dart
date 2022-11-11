import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/models/all_schemes_model.dart';

class SchemeAppliedDetails {
  Schemes scheme;
  Date lastRenewed;
  Date appliedDate;
  Date nextRenewalDate;

  SchemeAppliedDetails(
      {required this.scheme,
      required this.lastRenewed,
      required this.appliedDate,
      required this.nextRenewalDate});
}
