// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pension_blockchain/constants.dart';
import 'package:pension_blockchain/controller/login_controller.dart';
import 'package:web3dart/web3dart.dart';

class ContractLinking {
  final String _rpcUrl = "http://127.0.0.1:8545";
  final String _wsUrl = "ws://127.0.0.1:8545/";
  final LoginController loginController = Get.put(LoginController());
  late String _privateKey;

  late Web3Client _client;
  late String _abiCode;

  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;

  // contract functions
  late ContractFunction _addUser;
  late ContractFunction _applyPension;
  late ContractFunction _getSchemes;
  late ContractFunction _renewUser;
  late ContractFunction _transactionStatus;

  ContractLinking() {
    _privateKey = loginController.privateKey.value;
    initialSetup();
  }

  initialSetup() async {
    _client = Web3Client(_rpcUrl, http.Client());

    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/PensionSystem.json");

    var jsonAbi = jsonDecode(abiStringFile);

    _abiCode = jsonEncode(jsonAbi["abi"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    _contractAddress =
        EthereumAddress.fromHex("0x867A846B77E76094c57B800008E5c57Eb8724b1D");
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "PensionSystem"), _contractAddress);

    _addUser = _contract.function("addUser");
    _applyPension = _contract.function("applyPension");
    _getSchemes = _contract.function("getSchemes");
    _renewUser = _contract.function("renewUser");
    _transactionStatus = _contract.function("getTransactionStatus");
  }

  Future<bool> addUser(
      {required String name,
      required String dob,
      required String salId,
      required String publicId}) async {
    String transactionHash = "";
    int day = int.parse(dob.substring(0, 2));
    int month = int.parse(dob.substring(3, 5));
    int year = int.parse(dob.substring(6));

    try {
      transactionHash = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addUser,
            parameters: [
              name,
              BigInt.from(day),
              BigInt.from(month),
              BigInt.from(year),
              salId,
              publicId
            ]),
        chainId: 1337,
      );
    } catch (e) {
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _transactionStatus, params: []);

    return res[0];
  }

  Future<List<Schemes>> getSchemes(String classification) async {
    List<Schemes> availableSchemes = [];
    List<dynamic> tmp;

    try {
      tmp = await _client.call(
          contract: _contract, function: _getSchemes, params: [classification]);

      for (int i = 0; i < tmp.length; ++i) {
        Schemes? schemes;
        schemes!.schemeId = tmp[i][0];
        schemes.schemeName = tmp[i][1];
        schemes.amount = tmp[i][2].toInt();
        schemes.eligibleAge = tmp[i][3].toInt();
        availableSchemes.add(schemes);
      }
    } catch (e) {}
    return availableSchemes;
  }

  Future<bool> applyPension(
      {required String classification,
      required String schemeId,
      required String dob}) async {
    late String transactionHash;

    int day = int.parse(dob.substring(0, 2));
    int month = int.parse(dob.substring(3, 5));
    int year = int.parse(dob.substring(6));
    try {
      transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract,
              function: _applyPension,
              parameters: [
                classification,
                schemeId,
                BigInt.from(day),
                BigInt.from(month),
                BigInt.from(year)
              ]));
    } catch (e) {
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _transactionStatus, params: []);

    return res[0];
  }

  Future<bool> renewUser({required String salId}) async {
    late String transactionHash;

    try {
      transactionHash = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
              contract: _contract, function: _renewUser, parameters: [salId]),
          chainId: 1337);
    } catch (e) {
      return false;
    }
    List<dynamic> res;
    res = await _client
        .call(contract: _contract, function: _transactionStatus, params: []);

    return res[0];
  }
}
