import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/widgets/button_primary_outline.dart';

class MsgPurchased extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: StateM(context).height() / 4 * 3,
      width: StateM(context).width(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: reSize(context, 80),
                    height: reSize(context, 80),
                    decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/107.svg',
                        width: reSize(context, 24),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  Text(
                    'Attention!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: reSize(context, 20)),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xFF161617),
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                            text: 'You are already subscribed to this plan! '),
                        TextSpan(text: 'Unsubscribe, only on Setting!'),
                      ],
                    ),
                  ),
                  SizedBox(height: reSize(context, 30)),
                  ButtonPrimaryOutline(
                    width: reSize(context, 230),
                    text: 'Ok',
                    callback: () => Navigator.pop(context),
                    color: Colors.red,
                  )
                ],
              ),
            ),
            SizedBox(height: reSize(context, 14)),
          ],
        ),
      ),
    );
  }
}
