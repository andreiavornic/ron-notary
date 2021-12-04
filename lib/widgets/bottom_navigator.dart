import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notary/methods/resize_formatting.dart';

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


  //_session != null &&
  //                         _session.state != "CANCELLED" &&
  //                         _session.state != "FINISHED" &&
  //                         _session.state != "FAILED"
  //                     ? Column(
  //                         children: [
  //                           SizedBox(height: reSize(40)),
  //                           ButtonPrimaryOutline(
  //                             text: 'Discard Session',
  //                             callback: _deleteSession,
  //                           ),
  //                           SizedBox(
  //                             height: reSize(10),
  //                           ),
  //                           ButtonPrimary(
  //                             text: 'Resume',
  //                             callback: () => Get.to(
  //                               () => DocumentSetting(),
  //                               transition: Transition.noTransition,
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: reSize(35),
  //                           ),
  //                         ],
  //                       )
  //                     : Container()

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
                  onPressed: () => null,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFF000000).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/46.svg",
                        width: reSize(24),
                      ),
                      SizedBox(width: reSize(10)),
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
                  onPressed: () => null,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Color(0xFF000000).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/47.svg",
                          width: reSize(24)),
                      SizedBox(width: reSize(10)),
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
                height: MediaQuery.of(context).size.height < 670
                    ? 20
                    : reSize(40)),
          ],
        ),
      ),
    );
  }
}
