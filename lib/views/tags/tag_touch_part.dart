import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:notary/controllers/session.dart';
import 'package:notary/controllers/user.dart';
import 'package:notary/models/point.dart';
import 'package:provider/provider.dart';

import 'get_stamp.dart';

class TouchTagPart extends StatefulWidget {
  final String text;
  final Point point;
  final double imgWidth;

  TouchTagPart({
    this.point,
    this.text,
    this.imgWidth,
  });

  @override
  _TouchTagPartState createState() => _TouchTagPartState();
}

class _TouchTagPartState extends State<TouchTagPart> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserController, SessionController>(
        builder: (context, _userController, _sessionController, _) {
      return Container(
        key: key,
        child: Center(
          child: widget.point.type == "STAMP"
              ? GetStamp(widget.point)
              : _getText(
                  widget.point,
                  _userController,
                  _sessionController,
                ),
        ),
      );
    });
  }

  // Future<void> _signPoint(Point point) async {
  //   try {
  //     var notarySigns = Provider.of<SessionController>(context, listen: false)
  //         .points
  //         .where((element) =>
  //             element.ownerId ==
  //                 Provider.of<UserController>(context, listen: false).user.id &&
  //             element.type != "STAMP");

  //     if (!notarySigns.contains(point)) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Please sign only your points'),
  //       ));
  //       return;
  //     }

  //     Provider.of<SessionController>(context, listen: false)
  //         .signPoint(point.id);
  //   } catch (err) {
  //     showError(err, context);
  //   }
  // }

  Widget _getText(
    Point point,
    _userController,
    _sessionController,
  ) {
    int icon = 60;
    if (point.type == "INITIAL") {
      icon = 64;
    } else if (point.type == "DATE") {
      icon = 62;
    } else if (point.type == "STAMP") {
      icon = 61;
    } else if (point.type == "TEXTBOX") {
      icon = 63;
    }
    bool _isSigned = widget.point.isSigned;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        //shape: BoxShape.rectangle,
        border: Border.all(
          color: _isSigned ? Colors.transparent : widget.point.color,
          width: 1,
        ),
        color: _isSigned
            ? Colors.transparent
            : widget.point.isChecked
                ? widget.point.color.withOpacity(0.6)
                : widget.point.color.withOpacity(0.15),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Text(
                widget.text != null ? widget.text : widget.point.value,
                style: TextStyle(
                  fontSize: 6,
                  color: Color(0xFF161617).withOpacity(0.56),
                  fontFamily: widget.point.ownerType == "NOTARY"
                      ? _userController.getTypeFont().fontFamily
                      : _sessionController.getTypeFont(widget.point.ownerId) !=
                              null
                          ? _sessionController.getTypeFont(widget.point.ownerId)
                          : _userController.getTypeFont().fontFamily,
                ),
              ),
            ),
          ),
          // InkWell(
          //   // onTap:
          //   //     _isSigned ? () => print("Is signed") : () => _signPoint(point),
          //   child:
          // ),
          if (!_isSigned)
            Positioned(
              left: -8.5,
              top: -8.5,
              child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: widget.point.color,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/$icon.svg',
                    color: Color(0xFFFFFFFF),
                    width: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

// Widget _getSignedText(Point point, _userController, _sessionController) {
//   return Stack(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 1,
//             color: Colors.transparent,
//           ),
//         ),
//         height: 24,
//         child: Text(
//           widget.text != null ? widget.text : widget.point.value,
//           style: TextStyle(
//             fontSize: 10,
//             color: Colors.transparent,
//           ),
//         ),
//       ),
//       Positioned.fill(
//         right: 0,
//         left: 0,
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 0),
//             child: Text(
//               widget.text != null ? widget.text : widget.point.value,
//               style: TextStyle(
//                 fontSize: 6,
//                 color: Color(0xFF161617).withOpacity(0.86),
//                 fontFamily: widget.point.ownerType == "NOTARY"
//                     ? _userController.getTypeFont().fontFamily
//                     : _sessionController
//                         .getTypeFont(widget.point.ownerId)
//                         .fontFamily,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
