import 'package:get/get.dart';
import 'package:notary/models/plan.dart';
import 'package:dio/dio.dart' as dio;
import 'package:notary/services/dio_service.dart';

class PlanController extends GetxController {
  RxList<Plan> _plans = RxList<Plan>([]);

  RxList<Plan> get plans => _plans;

  @override
  void onInit() {
    super.onInit();
  }

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
      _plans.clear();
      extracted['data'].forEach(
        (json) => _plans.add(new Plan.fromJson(json)),
      );
      update();
    } catch (err) {
      throw err;
    }
  }

  Plan getPlanById(String id) {
    return _plans.firstWhere((element) => element.planIdAppStore == id);
  }
}
