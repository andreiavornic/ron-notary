import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import 'package:notary/models/card.dart' as CardModel;
import 'package:notary/models/font_family.dart';
import 'package:notary/models/notary.dart';
import 'package:notary/models/payment.dart';
import 'package:notary/models/signature.dart';
import 'package:notary/models/stamp.dart';
import 'package:notary/models/user.dart';
import 'package:notary/services/dio_service.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  bool _isAuth = false;
  Payment _payment;
  User _user;
  Notary _notary;
  String _stamp;
  String _certificate;
  bool _passwordCertificate = false;
  List<Stamp> _stamps = [];
  List<Signature> _signatures = [];

  String get certificate => _certificate;

  bool get passwordCertificate => _passwordCertificate;

  User get user => _user;

  Notary get notary => _notary;

  List<Stamp> get stamps => _stamps;

  bool get isAuth => _isAuth;

  Payment get payment => _payment;

  String get stamp => _stamp;

  List<Signature> get signatures => _signatures;

  Future<void> getUser() async {
    try {
      dio.Response resDio = await makeRequest('user', "GET", null);
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }

      _user = new User.fromJson(extracted['data']);
      _notary = extracted['data']['notary'] != null
          ? new Notary.fromJson(extracted['data']['notary'])
          : null;
      _payment = extracted['data']['payment'] != null
          ? new Payment.fromJson(extracted['data']['payment'])
          : null;
      _certificate = extracted['data']['certificate'];
      _passwordCertificate = extracted['data']['passwordCertificate'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("SOCKET_ROOM_SESSION", extracted['data']['roomSession']);

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addTokenNotification(String token) async {
    String os = Platform.operatingSystem;
    try {
      dio.Response resDio = await makeRequest('user/token', "POST", {
        "token": token,
        "os": os,
      });
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    try {
      dio.Response resDio = await makeRequest(
        'user',
        "PUT",
        data,
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _user.firstName = data['firstName'];
      _user.lastName = data['lastName'];
      _user.phone = data['phone'];
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> editNotary(Map<String, dynamic> data) async {
    try {
      dio.Response resDio = await makeRequest('notary', 'POST', data);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _notary = new Notary.fromJson(data);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getStamp() async {
    try {
      _stamps = [];
      dio.Response resDio = await makeRequest('stamp', 'GET', null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _stamp = extracted['data'];
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/38.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.stamp == 1,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/39.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.stamp == 2,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/40.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.stamp == 3,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/41.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.stamp == 4,
        ),
      );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  getSignatures() async {
    try {
      dio.Response resDio = await makeRequest('font', 'GET', null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }

      _signatures = [];
      extracted['data'].forEach(
        (json) => _signatures.add(
          new Signature(
            json['id'],
            json['fontFamily'],
            false,
          ),
        ),
      );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addCertificate(
      File certificate, String password, bool savePassword) async {
    try {
      String originalname = basename(certificate.path);
      final data = {
        'certificate': certificate.readAsBytesSync(),
        'originalname': originalname,
        'password': password,
        'savePassword': savePassword,
      };
      var resDio = await makeRequest('certificate', 'POST', data);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _certificate = extracted['data']['name'];
      _passwordCertificate = savePassword;

      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> removeCertificate() async {
    try {
      dio.Response resDio = await makeRequest('certificate', "DELETE", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }

      _certificate = null;
      _passwordCertificate = false;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addCertificatePassword(String password) async {
    try {
      dio.Response resDio = await makeRequest(
        'certificate/password',
        'POST',
        {"password": password},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _passwordCertificate = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> removePassword() async {
    try {
      dio.Response resDio =
          await makeRequest('certificate/password', "DELETE", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _passwordCertificate = false;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  selectSignature(int index) {
    _signatures.forEach((element) {
      element.isChecked = false;
    });
    _signatures[index].isChecked = true;
    notifyListeners();
  }

  saveSignature() async {
    try {
      int index = _signatures.indexWhere((element) => element.isChecked);

      dio.Response resDio = await makeRequest(
        'signature',
        "POST",
        {"id": _signatures[index].id},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      dynamic json = extracted['data'];

      _user.fontFamily = new Font.fromJson(json);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  selectStamp(int index) async {
    try {
      dio.Response resDio =
          await makeRequest('stamp', 'POST', {"index": index + 1});
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _stamps.forEach((element) {
        element.isChecked = false;
      });
      _stamps[index].isChecked = true;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getVerify(String verifyToken) async {
    try {
      dio.Response resDio = await makeRequest(
        'user/activate',
        "POST",
        {"verifyToken": verifyToken},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      dio.Response resDio = await makeRequest(
        'user/reset-password',
        "POST",
        {"email": email},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> addNewPassword(String password, String token) async {
    try {
      dio.Response resDio = await makeRequest('user/add-password', 'POST', {
        "password": password,
        "token": token,
      });
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteAccount() async {
    try {
      dio.Response resDio = await makeRequest('user', "DELETE", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }

  renewPayment(Map<String, dynamic> data) {
    _payment = data != null ? new Payment.fromJson(data) : null;
    notifyListeners();
  }

  updatePayment(int extra) {
    if (extra != 0) {
      _payment.ronAmount = _payment.ronAmount + extra;
    } else {
      _payment.ronAmount = _payment.ronAmount - 1;
    }
    notifyListeners();
  }

  updateNewPlanPayment(Map<String, dynamic> data) {
    _payment = data != null ? new Payment.fromJson(data) : null;
    notifyListeners();
  }

  deletePayment() {
    _payment.paid = false;
    _payment.ronAmount = 0;
    _payment.subscription = null;
    _payment.endPeriod = null;
    _payment.startPeriod = null;
    notifyListeners();
  }

  addCard(Map<String, dynamic> json) {
    CardModel.Card card = new CardModel.Card.fromJson(json);
    _payment.cards.add(card);
    notifyListeners();
  }

  updateCard(String id) {
    _payment.cards.forEach((element) => element.defaultCard = false);
    _payment.cards.firstWhere((element) => element.id == id).defaultCard = true;
    notifyListeners();
  }

  deleteCard(String id) {
    List<CardModel.Card> cards = _payment.cards;
    cards = cards.where((element) => element.id != id).toList();
    _payment.cards = cards;
    notifyListeners();
  }

  addExtra(int extra) {
    _payment.ronAmount += extra;
    notifyListeners();
  }

  Font getTypeFont() {
    return _user.fontFamily;
  }
}
