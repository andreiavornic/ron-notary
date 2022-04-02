import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

class SupportController extends ChangeNotifier {

  addMessage(Map<String, dynamic> data) async {
    try {
      dio.Response resDio = await makeRequest('message', 'POST', data);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
    } catch (err) {
      throw err;
    }
  }
}
