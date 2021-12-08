import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:notary/models/journal.dart';

class InfoJournal extends StatelessWidget {
  final Journal eJournal;
  final bool icon;

  InfoJournal({
    this.eJournal,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: SvgPicture.asset(
              "assets/images/72.svg",
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eJournal.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy h:mm a').format(eJournal.created),
                  style: TextStyle(
                    color: Color(0xFFADAEAF),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 12),
          _getStatus(eJournal.session.state, context),
          icon ? SizedBox(width: 12) : Container(),
          icon
              ? Container(
            child: SvgPicture.asset("assets/images/75.svg"),
          )
              : Container()
        ],
      ),
    );
  }

  Widget _getStatus(String state, context) {
    String formattedString =
        state[0].toUpperCase() + state.substring(1).toLowerCase();

    switch (state) {
      case ("FINISHED"):
        return Container(
          height: 20,
          width: 59,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Text(
              formattedString,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        );
      case ("CANCELLED"):
        return Container(
          height: 20,
          width: 59,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2), color: Color(0xFFE1E1E1)),
          child: Center(
            child: Text(
              formattedString,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFFADAEAF),
              ),
            ),
          ),
        );
      default:
        return Container(
          height: 20,
          width: 59,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).accentColor,
          ),
          child: Center(
            child: Text(
              formattedString,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        );
    }
  }
}
