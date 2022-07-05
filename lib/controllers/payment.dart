import 'package:flutter/material.dart';
import 'package:notary/models/payment.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/models/transactions.dart';
import 'package:notary/services/dio_service.dart';

class PaymentController extends ChangeNotifier {
  Payment _payment;
  int _extraNotarization = 1;
  List<Transactions> _transactions = [];

  Payment get payment => _payment;

  int get extraNotarization => _extraNotarization;

  List<Transactions> get transactions => _transactions;

  getTransactions() async {
    try {
      _transactions = [];
      dio.Response resDio = await makeRequest('transaction', 'GET', null);
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach((json) {
        _transactions.add(new Transactions.fromJson(json));
      });
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  getPayment() async {
    try {
      dio.Response resDio = await makeRequest('payment', 'GET', null);
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void plusExtra() {
    _extraNotarization = _extraNotarization + 1;
    notifyListeners();
  }

  void minusExtra() {
    if (_extraNotarization <= 1) return;
    _extraNotarization = _extraNotarization - 1;
    notifyListeners();
  }

  // Future<bool> verifyPayment(String transaction) async {
  //   try {
  //     dio.Response resDio = await makeRequest(
  //         'payment/ios', 'POST', {"transaction": transaction});
  //     var extracted = resDio.data;
  //     if (!extracted['success']) {
  //       throw extracted['message'];
  //     }
  //
  //     return extracted['data'];
  //   } catch (err) {
  //     throw err;
  //   }
  // }

  Future<bool> verifyPayment(String appUserId, String productId) async {
    print("verifyPayment($appUserId) => Executed!");
    print("verifyPayment($productId) => Executed!");
    try {
      dio.Response resDio = await makeRequest('payment', 'POST', {
        "appUserId": appUserId,
        "productId": productId,
      });
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      return extracted['data'];
    } catch (err) {
      throw err;
    }
  }

  Future<bool> extraPayment(int extra) async {
    try {
      dio.Response resDio = await makeRequest('payment/extra', 'POST', {
        "extra": extra,
      });
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      return extracted['data'];
    } catch (err) {
      throw err;
    }
  }
//
// Future<void> resetIosPayment(String purchaseToken, String productId) async {
//   try {
//     dio.Response resDio = await makeRequest(
//         'payment/reset', 'POST', {
//       "purchaseToken": purchaseToken,
//       "productId": productId,
//     });
//     var extracted = resDio.data;
//     if (!extracted['success']) {
//       throw extracted['message'];
//     }
//     _payment = new Payment.fromJson(extracted['data']);
//     notifyListeners();
//   } catch (err) {
//     throw err;
//   }
// }
//
// Future<void> resetPlayPayment(String purchaseToken, String productId) async {
//   try {
//     dio.Response resDio = await makeRequest('payment/google/reset', 'POST', {
//       "purchaseToken": purchaseToken,
//       "productId": productId,
//     });
//     var extracted = resDio.data;
//     if (!extracted['success']) {
//       throw extracted['message'];
//     }
//     _payment = new Payment.fromJson(extracted['data']);
//     notifyListeners();
//   } catch (err) {
//     throw err;
//   }
// }
}
