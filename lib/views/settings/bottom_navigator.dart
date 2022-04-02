import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notary/methods/resize_formatting.dart';

class ButtonNavigator extends StatelessWidget {
  final String title;
  final String icon;
  final Function onPressed;

  ButtonNavigator({this.title, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        overlayColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.secondary.withOpacity(0.04)),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Color(0xFFF8F8F8),
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: reSize(context, 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/$icon.svg',
                        width: reSize(context, 24),
                        color: onPressed == null
                            ? Color(0xFF000000).withOpacity(0.3)
                            : Color(0xFF000000),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: onPressed == null
                                ? Color(0xFF161617).withOpacity(0.3)
                                : Color(0xFF161617),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  size: reSize(context, 11),
                  color: onPressed == null
                      ? Color(0xFFA4A4A4).withOpacity(0.3)
                      : Color(0xFFA4A4A4),
                )
              ],
            ),
            Container(
              height: reSize(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
