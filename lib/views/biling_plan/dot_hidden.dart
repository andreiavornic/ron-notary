import 'package:flutter/material.dart';

class DotHidden extends StatelessWidget {
  final Color color;
  final double radius;

  DotHidden({this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: radius != null ? radius : 4,
          height: radius != null ? radius : 4,
          decoration: BoxDecoration(
              color: color != null ? color : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(4)),
        ),
        SizedBox(width: radius != null ? radius : 3),
      ],
    );
  }
}
