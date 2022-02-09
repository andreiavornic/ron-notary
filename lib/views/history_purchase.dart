import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/purchase.dart';

class HistoryPurchase extends StatefulWidget {


  const HistoryPurchase({Key key}) : super(key: key);

  @override
  State<HistoryPurchase> createState() => _HistoryPurchaseState();
}

class _HistoryPurchaseState extends State<HistoryPurchase> {
  PurchaseController _purchaseController = Get.put(PurchaseController());

  @override
  initState() {
    _purchaseController.getPastPurchase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ..._purchaseController.purchaseHistory
                  .asMap()
                  .entries
                  .map((item) {
                return Column(
                  children: [
                    Text("${item.value.transactionStateIOS}"),
                    Text("${item.value.productId}"),
                    SizedBox(height: 10),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
