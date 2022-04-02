import 'package:flutter/material.dart';
import 'package:notary/utils/navigate.dart';


class HistoryPurchase extends StatefulWidget {


  const HistoryPurchase({Key key}) : super(key: key);

  @override
  State<HistoryPurchase> createState() => _HistoryPurchaseState();
}

class _HistoryPurchaseState extends State<HistoryPurchase> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: StateM(context).height(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ..._purchaseController.purchaseHistory
              //     .asMap()
              //     .entries
              //     .map((item) {
              //   return Column(
              //     children: [
              //       Text("${item.value.transactionStateIOS}"),
              //       Text("${item.value.productId}"),
              //       SizedBox(height: 10),
              //     ],
              //   );
              // })
            ],
          ),
        ),
      ),
    );
  }
}
