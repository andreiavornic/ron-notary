import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notary/models/card.dart' as CardModel;
import 'package:notary/models/font_family.dart';
import 'package:notary/models/notary.dart';
import 'package:notary/models/payment.dart';
import 'package:notary/models/signature.dart';
import 'package:notary/models/stamp.dart';
import 'package:notary/models/user.dart';
import 'package:notary/services/dio_service.dart';

import 'package:path/path.dart';

class UserController extends GetxController {
  final _isAuth = false.obs;
  Rx<Payment> _payment = Rx<Payment>(null);
  Rx<User> _user = Rx<User>(null);
  Rx<Notary> _notary = Rx<Notary>(null);
  Rx<String> _stamp = Rx<String>(null);
  final _certificate = Rx<String>(null);
  final _passwordCertificate = Rx<bool>(false);
  final _stamps = RxList<Stamp>([]);
  final _signatures = RxList<Signature>([]);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  get certificate => _certificate;

  get passwordCertificate => _passwordCertificate;

  Rx<User> get user => _user;

  Rx<Notary> get notary => _notary;

  RxList<Stamp> get stamps => _stamps;

  get isAuth => _isAuth;

  Rx<Payment> get payment => _payment;

  get stamp => _stamp;

  RxList<Signature> get signatures => _signatures;

  Future<void> getUser() async {
    try {
      dio.Response resDio = await makeRequest('user', "GET", null);
      var extracted = resDio.data;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _user.value = new User.fromJson(extracted['data']);
      _notary.value = extracted['data']['notary'] != null
          ? new Notary.fromJson(extracted['data']['notary'])
          : null;
      _payment.value = extracted['data']['payment'] != null
          ? new Payment.fromJson(extracted['data']['payment'])
          : null;
      _certificate.value = extracted['data']['certificate'];
      _passwordCertificate.value = extracted['data']['passwordCertificate'];
      final prefs = GetStorage();
      prefs.write("SOCKET_ROOM_SESSION", extracted['data']['roomSession']);

      update();
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
      _user.value.firstName = data['firstName'];
      _user.value.lastName = data['lastName'];
      _user.value.phone = data['phone'];
      update();
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
      _notary.value = new Notary.fromJson(data);
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> getStamp() async {
    try {
      dio.Response resDio = await makeRequest('stamp', 'GET', null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _stamp.value = extracted['data'];
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/38.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.value.stamp == 1,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/39.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.value.stamp == 2,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/40.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.value.stamp == 3,
        ),
      );
      _stamps.add(
        new Stamp(
          image: Image.asset(
            'assets/images/41.png',
            fit: BoxFit.contain,
          ),
          isChecked: _user.value.stamp == 4,
        ),
      );
      update();
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

      _signatures.clear();
      extracted['data'].forEach(
        (json) => _signatures.add(
          new Signature(
            json['id'],
            json['fontFamily'],
            false,
          ),
        ),
      );
      update();
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
      var resDio = await makeRequest('certificate', 'PSOT', data);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _certificate.value = extracted['data']['name'];
      _passwordCertificate.value = savePassword;

      update();
    } catch (err) {
      print(err);
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

      _certificate.value = null;
      _passwordCertificate.value = false;
      update();
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
      _passwordCertificate.value = true;
      update();
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
      _passwordCertificate.value = false;
      update();
    } catch (err) {
      throw err;
    }
  }

  selectSignature(int index) {
    _signatures.forEach((element) {
      element.isChecked = false;
    });
    _signatures[index].isChecked = true;
    update();
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

      _user.value.fontFamily = new Font.fromJson(json);
      update();
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
      update();
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
    _payment.value = data != null ? new Payment.fromJson(data) : null;
    update();
  }

  updatePayment(int extra) {
    if (extra != 0) {
      _payment.value.ronAmount = _payment.value.ronAmount + extra;
    } else {
      _payment.value.ronAmount = _payment.value.ronAmount - 1;
    }

    update();
  }

  updateNewPlanPayment(Map<String, dynamic> data) {
    _payment.value = data != null ? new Payment.fromJson(data) : null;
    update();
  }

  deletePayment() {
    _payment.update((val) {
      val.paid = false;
      val.ronAmount = 0;
      val.subscription = null;
      val.endPeriod = null;
      val.startPeriod = null;
    });
  }

  addCard(Map<String, dynamic> json) {
    CardModel.Card card = new CardModel.Card.fromJson(json);
    _payment.value.cards.add(card);
    update();
  }

  updateCard(String id) {
    _payment.value.cards.forEach((element) => element.defaultCard = false);
    _payment.value.cards.firstWhere((element) => element.id == id).defaultCard =
        true;
    update();
  }

  deleteCard(String id) {
    List<CardModel.Card> cards = _payment.value.cards;
    cards = cards.where((element) => element.id != id).toList();
    _payment.value.cards = cards;
    update();
  }

  addExtra(int extra) {
    _payment.value.ronAmount += extra;
    update();
  }

  Font getTypeFont() {
    return _user.value.fontFamily;
  }
}
