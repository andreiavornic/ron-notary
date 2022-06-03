import 'package:flutter/material.dart';
import 'package:notary/controllers/payment.dart';
import 'package:notary/methods/date_format.dart';
import 'package:notary/models/payment.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatefulWidget {
  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  String _errMsg;

  @override
  void initState() {
    _getTransactions();
    super.initState();
  }

  _getTransactions() async {
    try {
      await Provider.of<PaymentController>(context, listen: false)
          .getTransactions();
    } catch (err) {
      _errMsg = err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentController>(builder: (context, _controller, _) {
      return Column(
        children: [
          ..._controller.transactions.map(
            (transaction) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Container(
                      color: Color(0xFFEDEDED),
                      height: 1,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.plan.title,
                              style: TextStyle(
                                  color: Color(0xFF161617),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatDate(transaction.startPeriod),
                              style: TextStyle(
                                color: Color(0xFF494949),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${transaction.plan.price}",
                              style: TextStyle(
                                  color: Color(0xFF161617),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              transaction.status == "succeeded"
                                  ? "Confirmed"
                                  : "Failed",
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
          ),
        ],
      );
    });
  }
}
