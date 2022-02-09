import 'package:flutter_inapp_purchase/modules.dart';
import 'package:get/get.dart';
import 'package:notary/models/payment.dart';
import 'package:notary/models/plan.dart';

import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

class PaymentController extends GetxController {
  RxList<Payment> _payment = RxList<Payment>([]);
  RxInt _extraNotarization = RxInt(1);

  RxList<Payment> get payment => _payment;

  RxInt get extraNotarization => _extraNotarization;

  @override
  void onInit() {
    super.onInit();
  }

  addPayment(String id) async {
    try {
      dio.Response resDio =
          await makeRequest('payment', 'POST', {"planId": id});
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      return extracted['data'];
    } catch (err) {
      throw err;
    }
  }

  addNewPlanPayment(String planId) async {
    try {
      dio.Response resDio = await makeRequest('payment/$planId', 'POST', {});
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      return extracted['data'];
    } catch (err) {
      throw err;
    }
  }

  Future<void> addExtra() async {
    try {
      dio.Response resDio = await makeRequest(
        'payment',
        'PUT',
        {"extra": _extraNotarization},
      );
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      _extraNotarization.value = 1;
      update();
    } catch (err) {
      throw err;
    }
  }

  Future<void> deletePayment() async {
    try {
      dio.Response resDio = await makeRequest('payment', "DELETE", null);
      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      update();
    } catch (err) {
      throw err;
    }
  }

  void plusExtra() {
    _extraNotarization = _extraNotarization + 1;
    update();
  }

  void minusExtra() {
    if (_extraNotarization <= 1) return;
    _extraNotarization = _extraNotarization - 1;
    update();
  }

  selectPlan(Plan plan) async {
    try {
      dio.Response resDio =
          await makeRequest('payment/plan/${plan.id}', 'POST', {});

      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      update();
    } catch (err) {
      throw err;
    }
  }

  selectExtraNotarization() async {
    try {
      dio.Response resDio = await makeRequest(
        'payment/extra/${_extraNotarization.value}',
        "POST",
        {},
      );

      var extracted = resDio.data;

      if (!extracted['success']) {
        throw extracted['message'];
      }
      update();
    } catch (err) {
      throw err;
    }
  }

  purchase(PurchasedItem productItem) async {
    print("purchase() => Executed!");
    print(productItem);
    try {
      dio.Response resDio = await makeRequest('payment/purchase', 'POST', {
        'transactionReceipt': productItem.transactionReceipt,
        'productItem': productItem.toString()
      });

      var extracted = resDio.data;

      print(extracted);

      if (!extracted['success']) {
        throw extracted['message'];
      }
      update();
    } catch (err) {
      throw err;
    }
  }
}
