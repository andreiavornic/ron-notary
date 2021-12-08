import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/models/notary.dart';
import 'package:notary/models/signature.dart';
import 'package:notary/models/stamp.dart';
import 'package:notary/models/user.dart';
import 'package:notary/services/notary.dart';
import 'package:notary/services/socket.dart';
import 'package:notary/services/user.dart';

import 'authentication.dart';

class UserController extends GetxController {
  final _isAuth = false.obs;
  final _user = Rx<User>();
  final _notary = Rx<Notary>();
  final _stamp = Rx<String>(null);
  final _certificate = Rx<String>(null);
  final _passwordCertificate = Rx<bool>(false);
  final _stamps = RxList<Stamp>([]);
  final _signatures = RxList<Signature>([]);
  UserService _userService = new UserService();
  SocketService _socketService = new SocketService();
  NotaryService _notaryService = new NotaryService();
  AuthenticationController _authController = new AuthenticationController();

  @override
  void onInit() {
    super.onInit();
    getUser();
    getStamp();
    getSignatures();
  }

  get certificate => _certificate;

  get passwordCertificate => _passwordCertificate;

  @override
  void onClose() {
    _socketService.socket.disconnect();
    super.onClose();
  }

  Rx<User> get user => _user;

  Rx<Notary> get notary => _notary;

  RxList<Stamp> get stamps => _stamps;

  get isAuth => _isAuth;

  get stamp => _stamp;

  get signatures => _signatures;

  Future<void> getUser() async {
    try {
      Response response = await _userService.getUser();
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _user.value = new User.fromJson(extracted['data']);
      _notary.value = extracted['data']['notary'] != null
          ? new Notary.fromJson(extracted['data']['notary'])
          : null;
      _certificate.value = extracted['data']['certificate'];
      _passwordCertificate.value =
          extracted['data']['passwordCertificate'] != null;
      update();
    } catch (err) {
      if (err == 'JWT EXPIRED') {
        _authController.logOut();
        return;
      }
      showError(err);
    }
  }

  Future<void> updateData(Map<String, dynamic> data) async {
    try {
      Response response = await _userService.updateData(data);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _user.update((val) {
        val.firstName = data['firstName'];
        val.lastName = data['lastName'];
        val.phone = data['phone'];
      });
    } catch (err) {
      throw err;
    }
  }

  Future<void> editNotary(Map<String, dynamic> data) async {
    try {
      Response response = await _notaryService.addNotary(data);
      var extracted = response.body;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _notary.update((val) {
        val.title = data['title'];
        val.company = data['company'];
        val.ronLicense = data['ronLicense'];
        val.ronExpire = DateTime.parse(data['ronExpire']).toLocal();
        val.address = data['address'];
        val.addressSecond = data['addressSecond'];
        val.city = data['city'];
        val.zip = data['zip'];
        val.companyPhone = data['companyPhone'];
        val.companyEmail = data['companyEmail'];
      });
    } catch (err) {
      throw err;
    }
  }

  Future<void> getStamp() async {
    try {
      Response response = await _userService.getStamp();
      var extracted = response.body;

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
      showError(err);
    }
  }

  getSignatures() async {
    try {
      Response response = await _userService.getFonts();
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      extracted['data'].forEach(
        (json) => _signatures.add(
          new Signature(
            json['id'],
            json['fontFamily'],
            false,
          ),
        ),
      );
    } catch (err) {
      throw err;
    }
  }

  Future<void> addCertificate(
      File certificate, String password, bool savePassword) async {
    try {
      Response response = await _userService.addCertificate(
          certificate, password, savePassword);
      var extracted = response.body;
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _certificate.value = extracted['data']['name'];
      _passwordCertificate.value = savePassword;

      _certificate.refresh();
      _passwordCertificate.refresh();
    } catch (err) {
      throw err;
    }
  }

  Future<void> removeCertificate() async {
    try {
      Response response = await _userService.deleteCertificate();
      var extracted = response.body;
      print(extracted);
      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }
}
