import 'dart:ui';

import 'package:notary/methods/hex_color.dart';

class Recipient {
  String id;
  String user;
  String session;
  String firstName;
  String lastName;
  bool smsSend;
  bool emailSend;
  String phone;
  String email;
  Color color;
  String type;
  List<String> states;
  bool isActive = false;

  Recipient({
    this.id,
    this.user,
    this.session,
    this.firstName,
    this.lastName,
    this.smsSend,
    this.emailSend,
    this.phone,
    this.email,
    this.color,
    this.type,
    this.states,
    this.isActive,
  });

  Recipient.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        session = json['session.dart'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        smsSend = json['smsSend'],
        emailSend = json['emailSend'],
        phone = json['phone'],
        email = json['email'],
        color = HexColor.fromHex(json['color']),
        type = json['type'],
        states =
            List<String>.from(json['states']).map((state) => state).toList();

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'color': color.toHex(),
        'type': type,
      };

  @override
  String toString() {
    return 'Recipient{id: $id, user: $user, session: $session, firstName: $firstName, lastName: $lastName, smsSend: $smsSend, emailSend: $emailSend, phone: $phone, email: $email, color: $color, type: $type, states: $states, isActive: $isActive}';
  }
}
