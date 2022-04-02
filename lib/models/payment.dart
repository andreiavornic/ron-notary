import 'package:notary/models/card.dart';
import 'package:notary/models/plan.dart';

class Payment {
  String id;
  String user;
  Plan plan;
  List<Card> cards;
  String created;
  String customer;
  String status;
  String subscription;
  int ronAmount;
  bool paid;
  int startPeriod;
  int endPeriod;

  Payment({
    this.id,
    this.user,
    this.plan,
    this.cards,
    this.created,
    this.customer,
    this.status,
    this.subscription,
    this.ronAmount,
    this.paid,
    this.startPeriod,
    this.endPeriod,
  });

  Payment.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.user = json['user'],
        this.ronAmount = json['ronAmount'],
        this.startPeriod = json['startPeriod'],
        this.endPeriod = json['endPeriod'],
        this.status = json['status'],
        this.paid = json['paid'],
        this.plan = json['plan'] != null ?  Plan.fromJson(json['plan']) : null;

  @override
  String toString() {
    return 'Payment{id: $id, user: $user, plan: $plan, cards: $cards, created: $created, customer: $customer, subscription: $subscription, ronAmount: $ronAmount, paid: $paid, startPeriod: $startPeriod, endPeriod: $endPeriod}';
  }
}
