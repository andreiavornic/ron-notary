import 'package:flutter/material.dart';

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

class RecipientController extends ChangeNotifier {
  List<Recipient> _recipients = [];
  List<Recipient> _recipientsForTag = [];

  List<Recipient> get recipients => _recipients;

  List<Recipient> get recipientsForTag => _recipientsForTag;

  Future<void> getRecipients() async {
    try {
      _recipients = [];
      _recipientsForTag = [];
      dio.Response resDio = await makeRequest('recipient', "GET", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      var data = extracted['data'];
      data.forEach((json) {
        _recipients.add(new Recipient.fromJson(json));
      });
      notifyListeners();
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
    notifyListeners();
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
      notifyListeners();
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
      _recipients.forEach((element) {
        int index = _recipients.indexOf(element);
        element.color = colors[index];
      });
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  fetchRecipients() {
    _recipientsForTag = [];
    _recipients.forEach((element) {
      _recipientsForTag.add(element);
    });

    notifyListeners();
  }

  activateRecipient(Recipient recipient) {
    _recipientsForTag.forEach((element) {
      element.isActive = false;
    });
    int index =
        _recipientsForTag.indexWhere((element) => element.id == recipient.id);
    _recipientsForTag[index].isActive = !_recipientsForTag[index].isActive;
    notifyListeners();
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
