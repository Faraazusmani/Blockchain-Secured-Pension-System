// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/controller/user_details_controller.dart';
import 'package:pension_blockchain/models/all_schemes_model.dart';
import 'package:pension_blockchain/models/applied_schemes_model.dart';
import 'package:pension_blockchain/models/user_details_model.dart';
import 'package:pension_blockchain/screens/login_screen.dart';
import 'package:web3dart/web3dart.dart';

class ContractLinking extends GetxController {
  final String _rpcUrl = "http://127.0.0.1:8545";
  // final String _wsUrl = "ws://127.0.0.1:8545/";
  late String _privateKey;

  late Web3Client _client;
  late String _abiCode;
  late int chainId;

  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late EthereumAddress currentUser;

  // contract functions
  late ContractFunction _registerUser;
  late ContractFunction _applyPension;
  late ContractFunction _renewPension;
  late ContractFunction _getAllAppliedSchemes;
  late ContractFunction _getTransactionStatus;
  late ContractFunction _getAllSchemes;
  late ContractFunction _getUserRegistrationStatus;
  late ContractFunction _setCurrentUser;
  late ContractFunction _getUserDetails;

  ContractLinking() {
    // initialSetup();
  }

  initialSetup() async {
    _privateKey = loginController.privateKey.value;
    _client = Web3Client(_rpcUrl, http.Client());

    await getAbi();
    await getCredentials();
    await getDeployedContracts();
    // await setCurrentUser();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/PensionSystem.json");

    var jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi["abi"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _contractAddress = EthereumAddress.fromHex(kContractAddress);
    currentUser = await _credentials.extractAddress();
    chainId = (await _client.getChainId()).toInt();
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "PensionSystem"), _contractAddress);

    _registerUser = _contract.function("registerUser");
    _applyPension = _contract.function("applyPension");
    _renewPension = _contract.function("renewPension");
    _getAllAppliedSchemes = _contract.function("getAllAppliedSchemes");
    _getTransactionStatus = _contract.function("getTransactionStatus");
    _getAllSchemes = _contract.function("getAllSchemes");
    _getUserRegistrationStatus =
        _contract.function("getUserRegistrationStatus");
    _setCurrentUser = _contract.function("setCurrentUser");
    _getUserDetails = _contract.function("getUserDetails");

    // await setCurrentUser();
  }

  Future<bool> registerUser(
      {required String name,
      required String empId,
      required String salId,
      required String dob}) async {
    String transactionHash = "";
    int day = int.parse(dob.substring(0, 2));
    int month = int.parse(dob.substring(3, 5));
    int year = int.parse(dob.substring(6));

    try {
      transactionHash = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _registerUser,
            parameters: [
              name,
              empId,
              salId,
              BigInt.from(day),
              BigInt.from(month),
              BigInt.from(year),
            ]),
        chainId: chainId,
      );
    } catch (e) {
      // print("Error---- $e");
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _getTransactionStatus, params: []);

    return res[0];
  }

  Future<bool> applyPension({required String schemeId}) async {
    late String transactionHash;
    DateTime date = DateTime.now();
    int day = date.day;
    int month = date.month;
    int year = date.year;
    try {
      transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _applyPension,
              parameters: [
                schemeId,
                BigInt.from(day),
                BigInt.from(month),
                BigInt.from(year)
              ]),
          chainId: chainId);
    } catch (e) {
      // print("Error- $e");
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _getTransactionStatus, params: []);

    return res[0];
  }

  Future<bool> renewPension(
      {required String schemeId,
      required Date renewDate,
      required int daysLeft}) async {
    late String transactionHash;

    // if expired - renew_date is today else renew_date starts when expiring
    DateTime dob = daysLeft < 0
        ? DateTime.now()
        : DateTime(renewDate.year, renewDate.month, renewDate.day);
    int day = dob.day;
    int month = dob.month;
    int year = dob.year;
    print("$day, $month, $year");
    try {
      transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _renewPension,
              parameters: [
                schemeId,
                BigInt.from(day),
                BigInt.from(month),
                BigInt.from(year)
              ]),
          chainId: chainId);
    } catch (e) {
      print("Hereree - $e");
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _getTransactionStatus, params: []);

    return res[0];
  }

  Future<List<Schemes>> getAllSchemes(String classification) async {
    List<Schemes> availableSchemes = [];
    List<dynamic> tmp;

    try {
      tmp = await _client.call(
          contract: _contract,
          function: _getAllSchemes,
          params: [classification]);
      tmp = tmp[0];
      // print("tmp = $tmp, len = ${tmp.length}");
      for (int i = 0; i < tmp.length; ++i) {
        Schemes schemes = Schemes(
            schemeId: tmp[i][0],
            classification: tmp[i][1],
            schemeName: tmp[i][2],
            amount: tmp[i][3].toInt(),
            eligibleAge: tmp[i][4].toInt());
        availableSchemes.add(schemes);
      }
    } catch (e) {
      // print("Error $e");
    }
    return availableSchemes;
  }

  Future<List<SchemeAppliedDetails>> getAllAppliedSchemes() async {
    List<SchemeAppliedDetails> details = [];
    List<dynamic> tmp;

    try {
      tmp = await _client.call(
          contract: _contract, function: _getAllAppliedSchemes, params: []);
      tmp = tmp[0];
      // print("here is tmp = $tmp");
      for (int i = 0; i < tmp.length; ++i) {
        SchemeAppliedDetails eachScheme = SchemeAppliedDetails(
            scheme: Schemes(
                schemeId: tmp[i][0][0],
                classification: tmp[i][0][1],
                schemeName: tmp[i][0][2],
                amount: tmp[i][0][3].toInt(),
                eligibleAge: tmp[i][0][4].toInt()),
            lastRenewed: Date(
                day: tmp[i][1][0].toInt(),
                month: tmp[i][1][1].toInt(),
                year: tmp[i][1][2].toInt()),
            appliedDate: Date(
                day: tmp[i][2][0].toInt(),
                month: tmp[i][2][1].toInt(),
                year: tmp[i][2][2].toInt()),
            nextRenewalDate: Date(
                day: tmp[i][3][0].toInt(),
                month: tmp[i][3][1].toInt(),
                year: tmp[i][3][2].toInt()));

        details.add(eachScheme);
      }
    } catch (e) {
      // print("Error $e");
    }
    return details;
  }

  Future<bool> getUserRegistrationStatus() async {
    bool status = false;
    List<dynamic>? res;

    try {
      res = await _client.call(
          contract: _contract,
          function: _getUserRegistrationStatus,
          params: []);
      status = res[0];
    } catch (e) {
      // print("User reg $e");
    }
    // print("User - $status, $res");
    return status;
  }

  Future<bool> setCurrentUser() async {
    try {
      await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _setCurrentUser,
              parameters: [currentUser]),
          chainId: chainId);
    } catch (e) {
      // print("SetCurrentUser error - $e");
      return false;
    }
    return true;
  }

  Future<void> getUserDetails() async {
    try {
      List<dynamic> tmp = await _client
          .call(contract: _contract, function: _getUserDetails, params: []);
      // print("User details - $tmp");
      tmp = tmp[0];
      UserDetailsController userDetailsController = Get.find();
      userDetailsController.userDetails = UserDetails(
          name: tmp[0],
          empId: tmp[1],
          salId: tmp[2],
          dob: Date(
              day: tmp[3][0].toInt(),
              month: tmp[3][1].toInt(),
              year: tmp[3][2].toInt()));
    } catch (e) {
      // print("GetUserDetails Error - $e");
    }
  }
}
