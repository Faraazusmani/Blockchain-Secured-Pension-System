import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xff7227fe);

class Schemes {
  String schemeId;
  String schemeName;
  int amount;
  int eligibleAge;

  Schemes(
      {required this.schemeId,
      required this.schemeName,
      required this.amount,
      required this.eligibleAge});
}
