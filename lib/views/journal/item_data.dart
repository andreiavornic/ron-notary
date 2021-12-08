import 'package:flutter/material.dart';

class ItemData extends StatelessWidget {
  final String txt;
  final String description;
  final bool bold;

  ItemData(this.txt, this.description, this.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                txt != null ? txt : '',
                style: TextStyle(
                  color: Color(0xFFADAEAF),
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                description != null ? description : '',
                style: TextStyle(
                  color: Color(0xFF161617),
                  fontSize: 12,
                  fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 15)
      ],
    );
  }
}