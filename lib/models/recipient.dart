import 'dart:ui';

import 'package:notary/methods/hex_color.dart';

import 'font_family.dart';

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
  String address;
  Color color;
  String type;
  List<String> states;
  bool isActive = false;
  bool idenfy;
  bool kba;
  Font fontFamily;

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
    this.address,
    this.color,
    this.type,
    this.states,
    this.isActive,
    this.idenfy,
    this.kba,
    this.fontFamily,
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
        address = json['address'],
        color = HexColor.fromHex(json['color']),
        type = json['type'],
        idenfy = json['idenfy'],
        kba = json['kba'],
        states =
            List<String>.from(json['states']).map((state) => state).toList(),
        fontFamily = json['fontFamily'] == null ||
                json['fontFamily'].runtimeType == String
            ? new Font("605b3fff5280c69b901d6c89", "Montserrat")
            : Font.fromJson(json['fontFamily']);

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
    return 'Recipient{id: $id, user: $user, session: $session, firstName: $firstName, lastName: $lastName, smsSend: $smsSend, emailSend: $emailSend, phone: $phone, email: $email, address: $address, color: $color, type: $type, states: $states, isActive: $isActive, idenfy: $idenfy, kba: $kba, fontFamily: $fontFamily}';
  }
}
