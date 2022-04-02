import 'package:flutter/material.dart';

import 'package:notary/controllers/payment.dart';
import 'package:notary/controllers/plan.dart';
import 'package:notary/methods/date_format.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/loading.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  PaymentController _paymentController;
  PlanController _planController;

  String _msg;
  bool _loading;

  @override
  void initState() {
    _paymentController = Provider.of<PaymentController>(context, listen: false);
    _planController = Provider.of<PlanController>(context, listen: false);
    asyncInitState();
    super.initState();
  }

  void asyncInitState() async {
    _loading = true;
    setState(() {});
    try {
      await _planController.getPlan();
      await _paymentController.getHistory();
      _loading = false;
      setState(() {});
    } catch (err) {
      _msg = err.toString();
      _loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentController>(builder: (context, _controller, _) {
      return _loading
          ? Loading()
          : _msg != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(child: Text(_msg)),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      ..._controller.transactions.toList().map((item) {
                        int index = _controller.transactions.indexOf(item);
                        return Container(
                          width: StateM(context).width() - 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index != 0)
                                SizedBox(height: 15)
                              else
                                SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item.title}",
                                    style: TextStyle(
                                      color: Color(0xFF161617),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "\$${item.price}",
                                    style: TextStyle(
                                      color: Color(0xFF161617),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${formatDate(item.purchaseDate)}",
                                    style: TextStyle(
                                      color: Color(0xFF494949),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${item.status}",
                                    style: TextStyle(
                                      color: Color(0xFF494949),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              if (index != _controller.transactions.length - 1)
                                Container(
                                  width: StateM(context).width() - 40,
                                  height: 1,
                                  color: Color(0xFFEDEDED),
                                )
                            ],
                          ),
                        );
                      }),
                    ]),
                  ),
                );
    });
  }
}
