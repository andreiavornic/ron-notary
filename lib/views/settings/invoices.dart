import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notary/controllers/plan.dart';
import 'package:notary/methods/date_format.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/plan.dart';

class Invoices extends StatefulWidget {
  final PurchasedItem item;

  Invoices(this.item);

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  PlanController _planController = Get.put(PlanController());
  Plan _plan;

  initState() {
    getPlanById();
    super.initState();
  }

  getPlanById() {
    _plan = _planController.getPlanById(widget.item.productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: Get.width - 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _plan.title,
                            style: TextStyle(
                                color: Color(0xFF161617),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${DateFormat('dd MMM, yyyy kk:mm').format(widget.item.transactionDate)}",
                            // formatDateHourSimple(
                            //     snapshot.data[i].created),
                            style: TextStyle(
                                color: Color(0xFF494949), fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$${_plan.price}",
                            // "\$${snapshot.data[i].amountPaid}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Confirmed",
                            style: TextStyle(
                              color: Color(0xFF494949),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: reSize(1),
              color: (Color(0xFF000000).withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }
}
