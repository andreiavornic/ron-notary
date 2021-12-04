import 'font_family.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  bool termsAccept;
  bool skipInfo;
  Font fontFamily;
  int stamp;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phone = json['phone'],
        termsAccept = json['termsAccept'],
        fontFamily = Font.fromJson(json['fontFamily']),
        skipInfo = json['skipInfo'],
        stamp = json['stamp'];
}
