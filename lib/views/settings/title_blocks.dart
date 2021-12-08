import 'package:flutter/material.dart';

class TitleBlocks extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final Function callback;


  TitleBlocks(
      {this.title,
        this.actionText,
        this.description,
        this.callback,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Color(0xFFADAEAF),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          callback != null
              ? Container(
            width: 77,
            height: 31,
            child: TextButton(
              onPressed: callback,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
                overlayColor: MaterialStateProperty.all(
                  Theme.of(context).accentColor.withOpacity(0.02),
                ),
              ),
              child: Container(
                width: 77,
                height: 31,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                    width: 1,
                  ),
                ),
                child: Center(
                    child: Text(
                      actionText,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
