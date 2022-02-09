import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/methods/hex_color.dart';
import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

List<Color> colors = [
  Color(0xFF3E65C9),
  Color(0xFFFC563D),
  Color(0xFF419E60),
  Color(0xFF67D3FC),
  Color(0xFF734BC8),
];

class RecipientController extends GetxController {
  var _recipients = <Recipient>[].obs;
  var _recipientsForTag = <Recipient>[].obs;

  RxList<Recipient> get recipients => _recipients;

  RxList<Recipient> get recipientsForTag => _recipientsForTag;

  @override
  void onInit() {
    // getRecipients();
    // fetchRecipients();
    super.onInit();
  }

  Future<void> getRecipients() async {
    try {
      dio.Response resDio = await makeRequest('recipient', "GET", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      var data = extracted['data'];
      var recipientResult = RxList<Recipient>([]);
      data.forEach((json) {
        recipientResult.add(new Recipient.fromJson(json));
      });
      _recipients = recipientResult;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addRecipient(Map<String, dynamic> dataRecipient) async {
    dataRecipient['color'] = colors[_recipients.length].toHex();
    dio.Response resDio = await makeRequest('recipient', 'POST', dataRecipient);
    var extracted = resDio.data;
    if (extracted == null) {
      return;
    }
    if (!extracted['success']) {
      throw extracted['message'];
    }

    Recipient newRecipient = new Recipient(
      id: extracted['data']['id'],
      user: extracted['data']['user'],
      session: extracted['data']['session.dart'],
      firstName: dataRecipient['firstName'],
      lastName: dataRecipient['lastName'],
      phone: dataRecipient['phone'],
      email: dataRecipient['email'],
      type: dataRecipient['type'],
      color: colors[_recipients.length],
      states: List<String>.from(extracted['data']['states'])
          .map((state) => state)
          .toList(),
    );
    _recipients.add(newRecipient);
    update();
  }

  Future<void> updateRecipient(Recipient recipient) async {
    try {
      dio.Response resDio = await makeRequest(
        'recipient/${recipient.id}',
        'PUT',
        recipient.toJson(),
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      int index =
          _recipients.indexWhere((element) => element.id == recipient.id);
      _recipients[index] = recipient;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deleteRecipient(String id) async {
    try {
      dio.Response resDio = await makeRequest('recipient/$id', "DELETE", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      Recipient recipe = _recipients.firstWhere((element) => element.id == id);
      _recipients.remove(recipe);
      update();
    } catch (err) {
      throw err;
    }
  }

  fetchRecipients() {
    _recipientsForTag = <Recipient>[].obs;
    _recipients.forEach((element) {
      _recipientsForTag.add(element);
    });

    update();
  }

  activateRecipient(Recipient recipient) {
    _recipientsForTag.forEach((element) {
      element.isActive = false;
    });
    int index =
        _recipientsForTag.indexWhere((element) => element.id == recipient.id);
    _recipientsForTag[index].isActive = !_recipientsForTag[index].isActive;
    update();
  }

  addUserRecipient(Recipient recipient) {
    _recipientsForTag.forEach((element) {
      element.isActive = false;
    });
    if (_recipientsForTag.any((element) => element.id == recipient.id)) {
      return;
    }
    _recipientsForTag.insert(0, recipient);
  }
}
