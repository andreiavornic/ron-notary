import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notary/methods/resize_formatting.dart';

import 'contact_page.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(()=> ContactPage()),
      child: Container(
        child: Row(
          children: [
            Container(
              width: reSize(44),
              height: reSize(44),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(22)),
              child: Center(
                child: SvgPicture.asset('assets/images/84.svg'),
              ),
            ),
            SizedBox(width: reSize(12),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Have any questions? Let’s Chat',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFADAEAF),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
