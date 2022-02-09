import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

getIconCard(String brand) {
  switch (brand) {
    case ("amex"):
      return Icon(
        FontAwesomeIcons.ccAmex,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    case ("diners_club"):
      return Icon(
        FontAwesomeIcons.ccDinersClub,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    case ("discover"):
      return Icon(
        FontAwesomeIcons.ccDiscover,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    case ("jcb"):
      return Icon(
        FontAwesomeIcons.ccJcb,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    case ("visa"):
      return Icon(
        FontAwesomeIcons.ccVisa,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    case ("mastercard"):
      return Icon(
        FontAwesomeIcons.ccMastercard,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
    default:
      return Icon(
        FontAwesomeIcons.creditCard,
        color: Color(0xFF3C5AA6),
        size: 16,
      );
  }
}