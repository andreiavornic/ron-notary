import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/widgets/button_primary_outline.dart';

class ConfirmDelete extends StatelessWidget {
  final Function callback;
  final int icon;
  final Widget description;
  final String btnTxt;

  ConfirmDelete({this.callback, this.icon, this.description, this.btnTxt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 4 * 3,
      width: Get.width,
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
                    width: reSize(80),
                    height: reSize(80),
                    decoration: BoxDecoration(
                        color: Color(0xFFFC563D),
                        borderRadius: BorderRadius.circular(80)),
                    child: Center(
                      child: SvgPicture.asset(
                        icon != null
                            ? 'assets/images/$icon.svg'
                            : 'assets/images/106.svg',
                        width: reSize(24),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: reSize(20)),
                  description != null
                      ? description
                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Color(0xFF161617),
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                  text:
                                      'If you Delete the document you will be required\nto start over with a '),
                              TextSpan(
                                text: 'New Session',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: reSize(30)),
                  ButtonPrimaryOutline(
                    width: reSize(230),
                    text: btnTxt != null ? btnTxt : 'Remove',
                    callback: callback,
                    color: Colors.red,
                  )
                ],
              ),
            ),
            SizedBox(height: reSize(14)),
          ],
        ),
      ),
    );
  }
}
