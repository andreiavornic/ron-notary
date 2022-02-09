import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketService extends GetxController {
  IO.Socket _socket = IO.io(
      dotenv.env['SOCKET_URL'],
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNewConnection()
          .build());

  IO.Socket get socket => _socket;

  void connect() async {
    print("Connect Socket from binding");
    if (_socket.connected) return;
    _socket.connect();

    final prefs = GetStorage();
    String room = prefs.read("SOCKET_ROOM");
    if (room == null) return;
    _socket.onConnect((_) {
      _socket.emit('joinRoom', room);
    });

    _socket.onDisconnect(
      (data) => print("Socket disconnected"),
    );
  }

  void disconnect() {
    _socket.disconnect();
  }

  void sendData(event, data) {
    _socket.emit(event, data);
  }

  void joinToRoom() {
    final prefs = GetStorage();
    String room = prefs.read("SOCKET_ROOM");
    if (room == null) return;
    _socket.onConnect((_) {
      _socket.emit('joinRoom', room);
    });
  }

}
