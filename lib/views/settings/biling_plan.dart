import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/views/settings/payment_method.dart';
import 'package:notary/views/settings/plan_card.dart';
import 'package:notary/views/settings/title_blocks.dart';
import 'package:notary/widgets/title_page.dart';

import 'invoices.dart';

class BillingPlan extends StatefulWidget {
  @override
  _BillingPlanState createState() => _BillingPlanState();
}

class _BillingPlanState extends State<BillingPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
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
            SizedBox(height: reSize(30)),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Column(children: [
                        TitleBlocks(
                          title: "Card",
                          description: "Saved payment methods",
                          actionText: "Add New",
                          callback: () => null,
                        ),
                        SizedBox(height: reSize(15)),
                        Container(
                          child: PaymentMethod(),
                        ),
                      ]),
                      SizedBox(height: reSize(20)),
                      TitleBlocks(
                        title: "Transactions",
                        description: "Recent payments",
                      ),
                      SizedBox(height: reSize(15)),
                      Container(child: Invoices()),
                      SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
