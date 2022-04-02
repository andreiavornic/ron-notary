import 'package:flutter/material.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/biling_plan/plan_card.dart';
import 'package:notary/views/settings/title_blocks.dart';
import 'package:notary/widgets/title_page.dart';

import '../../widgets/network_connection.dart';
import '../transactions.dart';

class BillingPlan extends StatefulWidget {
  @override
  _BillingPlanState createState() => _BillingPlanState();
}

class _BillingPlanState extends State<BillingPlan> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NetworkConnection(
      Scaffold(
        body: Container(
          height: StateM(context).height(),
          child: Column(
            children: [
              TitlePage(
                title: "Billing & Plan",
                description: "Update your billing and subscription",
                needNav: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: PlanCard(),
                ),
              ),
              SizedBox(height: reSize(context, 30)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TitleBlocks(
                  title: "Transactions",
                  description: "Recent payments",
                ),
              ),
              SizedBox(height: reSize(context, 15)),
              Expanded(child: Transactions()),
              SizedBox(
                  height: StateM(context).height() < 670
                      ? 20
                      : reSize(context, 40)),
            ],
          ),
        ),
      ),
    );
  }
}
