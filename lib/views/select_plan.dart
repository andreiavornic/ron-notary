import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notary/controllers/app_purchase.dart';
import 'package:notary/controllers/purchase.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/methods/show_error.dart';
import 'package:notary/views/history_purchase.dart';
import 'package:notary/widgets/button_primary.dart';
import 'package:notary/widgets/button_primary_outline.dart';
import 'package:notary/widgets/loading_page.dart';
import 'package:notary/widgets/plan_block.dart';
import 'package:notary/widgets/title_page.dart';

class SelectPlan extends StatefulWidget {
  @override
  _SelectPlanState createState() => _SelectPlanState();
}

class _SelectPlanState extends State<SelectPlan> {
  PageController pageController;
  int _indexPage;
  double _heightMedia;
  UserController _userController = Get.put(UserController());
  PurchaseController _purchaseController = Get.put(PurchaseController());

  initState() {
    _indexPage = 1;
    pageController =
        PageController(viewportFraction: 0.8, initialPage: _indexPage);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_userController.payment.value);
    _heightMedia = Get.height;
    return GetBuilder<PurchaseController>(builder: (_controller) {
      return LoadingPage(
          _controller.products.length == 0 || _controller.pending.value,
          Container(
            height: Get.height,
            child: Column(
              children: [
                TitlePage(
                  title: "Subscription Plan",
                  description: "Select plan for your business needs",
                  needNav: true,
                ),
                SizedBox(height: _heightMedia > 700 ? 30 : 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color: Color(0xFF000000).withOpacity(0.14),
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Row(
                          children: [
                            ..._controller.products.asMap().entries.map((item) {
                              int index = item.key;
                              return Expanded(
                                child: InkWell(
                                  onTap: () {
                                    pageController.animateToPage(
                                      index,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: reSize(30),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: _indexPage == index
                                            ? Color(0xFFFFC600)
                                            : Colors.transparent),
                                    child: Center(
                                      child: Text(
                                        item.value.title,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        )),
                  ),
                ),
                SizedBox(height: _heightMedia > 700 ? 70 : 30),
                Expanded(
                  child: Container(
                    height: reSize(366),
                    child: PageView(
                      controller: pageController,
                      clipBehavior: Clip.none,
                      onPageChanged: (int page) {
                        _indexPage = page;
                        setState(() {});
                      },
                      children: <Widget>[
                        ..._controller.products.asMap().entries.map((item) {
                          int index = item.key;
                          return PlanBlock(
                            indexPage: _indexPage,
                            indexBlock: index,
                            product: _controller.products[index],
                          );
                        })
                      ],
                    ),
                  ),
                ),
                SizedBox(height: _heightMedia > 700 ? 70 : 30),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: '*\$25 for each additional notarization'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ButtonPrimary(
                    text: 'Subscribe',
                    callback: _buyProduct,
                  ),
                ),
                SizedBox(height: 10),
                ButtonPrimaryOutline(
                  text: "History",
                  callback: () => Get.to(() => HistoryPurchase()),
                ),
                SizedBox(height: Get.height < 670 ? 20 : reSize(40)),
              ],
            ),
          ));
    });
  }

  _buyProduct() async {
    try {
      // await _purchaseController.buyProduct(
      //   _purchaseController.products[_indexPage],
      //   _userController.user.value.id,
      // );
      await _purchaseController.buyProduct(_indexPage);
    } catch (err) {
      showError(err);
    }
  }
}
