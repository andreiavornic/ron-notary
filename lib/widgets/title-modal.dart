import 'package:flutter/material.dart';

class TitleModal extends StatelessWidget {
  final String title;
  final String description;


  TitleModal(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: Color(0xFF20303C),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
