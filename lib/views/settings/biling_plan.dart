import 'package:flutter/material.dart';
import 'package:notary/views/settings/title_blocks.dart';
import 'package:provider/provider.dart';

import '../../controllers/payment.dart';
import '../../methods/resize_formatting.dart';
import '../../utils/navigate.dart';
import '../../widgets/network_connection.dart';
import '../../widgets/title_page.dart';
import '../../widgets/transaction_list.dart';
import '../biling_plan/plan_card.dart';

class BillingPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentController>(builder: (context, _controller, _) {
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
                SizedBox(height: 10),
                Expanded(
                    child: SingleChildScrollView(child: TransactionList())),
                SizedBox(
                    height: StateM(context).height() < 670
                        ? 20
                        : reSize(context, 40)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
