import 'package:flutter/material.dart';
import 'package:notary/methods/resize_formatting.dart';

import 'back_arrow_button.dart';

class TitlePage extends StatelessWidget {
  final bool needNav;
  final bool needHelp;
  final String title;
  final String description;
  final Function callback;

  TitlePage({
    @required this.title,
    @required this.description,
    this.needNav,
    this.needHelp,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height < 670
                        ? reSize(50)
                        : reSize(70)),
                Padding(
                  padding: needNav != null && needNav
                      ? EdgeInsets.symmetric(horizontal: 0)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      needNav != null && needNav
                          ? BackArrowButton()
                          : Container(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            SizedBox(height: reSize(2)),
                            Text(
                              description,
                              style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: reSize(1)),
                            ),
                            SizedBox(height: reSize(20)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          needHelp != null && needHelp
              ? Container(
           // child: Stages(),
          )
              : Container()
        ],
      ),
    );
  }
}
