import 'package:flutter/material.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/plan.dart';
import 'package:notary/utils/navigate.dart';

class Invoices extends StatefulWidget {


  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
 // PlanController Provider.of<PlanController>(context, listen: false) = Get.put(PlanController());
  Plan _plan;

  initState() {
    getPlanById();
    super.initState();
  }

  getPlanById() {
  //  _plan = Provider.of<PlanController>(context, listen: false).getPlanById(widget.item.productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: StateM(context).width() - 40,
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
                          // Text(
                          //   "${DateFormat('dd MMM, yyyy kk:mm').format(widget.item.transactionDate)}",
                          //   // formatDateHourSimple(
                          //   //     snapshot.data[i].created),
                          //   style: TextStyle(
                          //       color: Color(0xFF494949), fontSize: 12),
                          // ),
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
              height: reSize(context, 1),
              color: (Color(0xFF000000).withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }
}
