import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notary/models/payment.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/models/transactions.dart';
import 'package:notary/services/dio_service.dart';

class PaymentController extends ChangeNotifier {
  List<Payment> _payment = [];
  int _extraNotarization = 1;
  List<Transactions> _transactions = [];

  List<Payment> get payment => _payment;

  int get extraNotarization => _extraNotarization;

  List<Transactions> get transactions => _transactions;

  getHistory() async {
    try {
      _transactions = [];
      dio.Response resDio = await makeRequest('payment', 'POST', {});
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

      print(jsonEncode(extracted));

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
}
