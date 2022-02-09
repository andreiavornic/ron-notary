import 'package:notary/models/payment.dart';

import 'font_family.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String longState;
  bool termsAccept;
  bool skipInfo;
  Font fontFamily;
  int stamp;
  Payment payment;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phone = json['phone'],
        longState = json['longState'],
        termsAccept = json['termsAccept'],
        fontFamily = json['fontFamily'] != null ?  Font.fromJson(json['fontFamily']) : null,
        skipInfo = json['skipInfo'],
        stamp = json['stamp'];

  User.fromJsonRecipient(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phone = json['phone'],
        longState = json['longState'],
        termsAccept = json['termsAccept'],
        skipInfo = json['skipInfo'],
        stamp = json['stamp'];

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, longState: $longState, termsAccept: $termsAccept, skipInfo: $skipInfo, fontFamily: $fontFamily, stamp: $stamp, payment: $payment}';
  }
}
