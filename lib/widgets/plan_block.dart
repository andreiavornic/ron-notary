// import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:animated/animated.dart';
import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:notary/models/plan.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

class PlanBlock extends StatelessWidget {
  final int indexPage;
  final int indexBlock;
  final Package package;
  final Plan plan;

  PlanBlock({
    @required this.indexPage,
    @required this.indexBlock,
    @required this.package,
    @required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xFFFFD12F), Color(0xFFFFC149)],
    ).createShader(Rect.fromLTRB(0.0, 0.0, 200.0, 70.0));

    return Animated(
      value: indexPage == indexBlock ? 1 : 0.9,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
      builder: (context, child, animation) => Transform.scale(
        scale: animation.value,
        child: child,
      ),
      child: AnimatedOpacity(
        opacity: indexPage == indexBlock ? 1 : 0.2,
        duration: Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.16),
                spreadRadius: 0,
                blurRadius: 40,
                offset: Offset(0, 4), // changes position of shadow
              ),
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.10),
                spreadRadius: 0,
                blurRadius: 12.74,
                offset: Offset(0, 1), // changes position of shadow
              ),
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.07),
                spreadRadius: 0,
                blurRadius: 3.26,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF343A39),
                Color(0xFF272D2C),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${plan?.title}",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              package.product.description,
                              style: TextStyle(
                                color: Color(0xFF999999),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${package.product.price.toStringAsFixed(2)}',
                              //  '\$${product.price}',
                              // '\$${product.price}',
                              style: TextStyle(
                                foreground: Paint()..shader = linearGradient,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "per month",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF999999)),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFF494F4E),
                            width: 1,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${plan?.ronAmount}',
                    //  '${product.rawPrice}',
                    //'${product.price}',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        height: 0.8),
                  ),
                  Text(
                    'RON Credits',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Per Session: ',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                    ),
                  ),
                  if (plan != null)
                    Text(
                      '\$${(package.product.price.toDouble() / plan.ronAmount).toStringAsFixed(2)}',
                      // "${product.price}",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4D5151),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'eJournal and File Hosting',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFF4343),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF6F6FF),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
