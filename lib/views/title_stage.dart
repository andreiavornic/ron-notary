import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';

class TitleStage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Stages',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/images/83.svg'),
              onPressed: () => Get.back(),
            ),
            SizedBox(width: reSize(10)),
          ],
        )
      ],
    );
  }
}
