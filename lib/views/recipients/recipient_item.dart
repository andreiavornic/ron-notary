import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/models/recipient.dart';

class RecipeItem extends StatelessWidget {
  final Recipient recipient;

  RecipeItem(this.recipient);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      width: reSize(context, 24),
                      height: reSize(context, 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: recipient.color,
                      ),
                      child: Center(
                        child: Text(
                          "${recipient.firstName[0]} ${recipient.lastName[0]}",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: reSize(context, 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${recipient.firstName} ${recipient.lastName}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          recipient.type,
                          style: TextStyle(
                            color: Color(0xFFADAEAF),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
