import 'package:flutter/material.dart';

class PushNotificationMessage {
  final String title;
  final String body;

  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });

  @override
  String toString() {
    return 'PushNotificationMessage{title: $title, body: $body}';
  }
}
