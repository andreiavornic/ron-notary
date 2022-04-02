import 'package:flutter/material.dart';
import 'package:notary/models/plan.dart';
import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

class PlanController  extends ChangeNotifier {
  List<Plan> _plans = [];

  List<Plan> get plans => _plans;
  

  getPlan() async {
    try {
      dio.Response resDio = await makeRequest('plan', "GET", null);
      var extracted = resDio.data;
      if (extracted == null) {
        return;
      }
      if (!extracted['success']) {
        throw extracted['message'];
      }
      _plans = [];
      extracted['data'].forEach(
        (json) => _plans.add(new Plan.fromJson(json)),
      );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Plan getPlanById(String id) {
    return _plans.firstWhere((element) => element.planIdAppStore == id);
  }
}
