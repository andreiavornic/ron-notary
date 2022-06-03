import 'package:notary/models/plan.dart';

class Transactions {
  Plan plan;
  String status;
  String platform;
  int startPeriod;
  int endPeriod;

  Transactions.fromJson(Map<String, dynamic> json)
      : plan = Plan.fromJson(json['plan']),
        status = json['status'],
        platform = json['platform'],
        startPeriod = json['startPeriod'],
        endPeriod = json['endPeriod'];

  @override
  String toString() {
    return 'Transactions{plan: $plan, status: $status, platform: $platform, startPeriod: $startPeriod, endPeriod: $endPeriod}';
  }
}
