import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/app_purchase.dart';
import 'package:notary/controllers/plan.dart';
import 'package:notary/controllers/purchase.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/biling_plan/plan_card.dart';
import 'package:notary/views/settings/title_blocks.dart';
import 'package:notary/widgets/loading.dart';
import 'package:notary/widgets/title_page.dart';

import 'invoices.dart';

class BillingPlan extends StatefulWidget {
  @override
  _BillingPlanState createState() => _BillingPlanState();
}

class _BillingPlanState extends State<BillingPlan> {
  PurchaseController _purchase = Get.put(PurchaseController());
  PlanController _planController = Get.put(PlanController());

  @override
  initState() {
    getHistory();
    super.initState();
  }

  getHistory() async {
    try {
      _planController.getPlan();
      await _purchase.getHistory();
    } catch (err) {
      showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseController>(builder: (_controller) {
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
                        // Column(children: [
                        //   TitleBlocks(
                        //     title: "Card",
                        //     description: "Saved payment methods",
                        //     actionText: "Add New",
                        //     callback: () => Get.to(() => PaymentInfo()),
                        //   ),
                        //   SizedBox(height: reSize(15)),
                        //   Container(
                        //     child: PaymentMethod(),
                        //   ),
                        // ]),
                        // SizedBox(height: reSize(20)),
                        TitleBlocks(
                          title: "Transactions",
                          description: "Recent payments",
                        ),
                        SizedBox(height: reSize(15)),
                        Column(
                          children: [
                            ..._controller.purchaseHistory
                                .asMap()
                                .entries
                                .map((item) {
                              return Invoices(item.value);
                            })
                          ],
                        ),
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
    });
  }
}
