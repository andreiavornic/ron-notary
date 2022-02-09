import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/get_icon_card.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/card.dart' as CardModel;
import 'package:notary/widgets/button_primary.dart';

import 'dot_hidden.dart';

class SelectCardPrimary extends StatelessWidget {
  final CardModel.Card card;
  final Function selectCard;

  SelectCardPrimary({this.card, this.selectCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 4 * 3,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: reSize(40)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width:  reSize(80),
                  height:  reSize(80),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(80)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/114.svg',
                      width: reSize(38),
                    ),
                  ),
                ),
                SizedBox(height:  reSize(20)),
                Text(
                  'Make this card primary?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height:  reSize(20)),
                Text(
                  'This card will used for plan renewal\nby default',
                  style: TextStyle(
                    color: Color(0xFF161617),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              height:  reSize(54),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xFFCFD5E7),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getIconCard(card.brand),
                          SizedBox(width:  reSize(10)),
                          Text(
                            card.name,
                            style: TextStyle(
                              color: Color(0xFF161617),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          for (int i = 0; i < 4; i++) DotHidden(),
                          SizedBox(width:  reSize(5)),
                          Text(
                            card.lastFour,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width:  reSize(15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                ButtonPrimary(
                  callback: selectCard,
                  text: "Confirm",
                ),
                SizedBox(
                    height: Get.height < 670
                        ? 20
                        : reSize(40)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
