import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:notary/methods/resize_formatting.dart';
import 'package:notary/utils/navigate.dart';
import 'package:notary/views/journal.dart';
import 'package:notary/views/settings_menu.dart';

class BottomNavigator extends StatefulWidget {
  final Widget widget;

  BottomNavigator({this.widget});

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Column(
          children: [
            widget.widget != null ? widget.widget : Container(),
            Divider(
              color: Color(0xFFEDEDED),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () =>  StateM(context).navTo(Journal()),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFF000000).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/46.svg",
                        width: reSize(context, 24),
                      ),
                      SizedBox(width: reSize(context, 10)),
                      Text(
                        'eJournal',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>  StateM(context).navTo(SettingsMenu()),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFF000000).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/47.svg",
                          width: reSize(context, 24)),
                      SizedBox(width: reSize(context, 10)),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
                height:
                    StateM(context).height() < 670 ? 20 : reSize(context, 40)),
          ],
        ),
      ),
    );
  }
}
