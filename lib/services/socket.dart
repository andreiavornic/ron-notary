import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketService extends GetxController {
  IO.Socket socket = IO.io(
      dotenv.env['SOCKET_URL'],
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  void connect() {
    print("Connect Socket");
    if (socket.connected) return;
    socket.connect();
    socket.onConnect((_) {
      socket.emit('joinRoom', 'test');
    });

    socket.on('roomConnected', (data) {
      print(data);
    });

    socket.onDisconnect(
      (data) => print("Socket disconnected"),
    );
  }

  void disconnect() {
    socket.disconnect();
  }

  void sendData(event, data) {
    socket.emit(event, data);
  }
}
