import 'package:notary/models/point.dart';
import 'package:notary/models/recipient.dart';
import 'package:notary/models/session.dart';

class Journal {
  String id;
  String name;
  int fee;
  List<Recipient> recipients;
  List<Point> points;
  Session session;
  DateTime created;

  Journal.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        fee = json['fee'],
        created = DateTime.parse(json['createdAt']).toLocal(),
        recipients = List<Map<String, dynamic>>.from(json['recipients'])
            .map((recipient) => new Recipient.fromJson(recipient))
            .toList(),
        points = List<Map<String, dynamic>>.from(json['points'])
            .map((recipient) => new Point.fromJson(recipient))
            .toList(),
        session = Session.fromJson(json['session']);

  @override
  String toString() {
    return 'Journal{id: $id, name: $name, fee: $fee, recipients: $recipients, points: $points, session: $session}';
  }
}
