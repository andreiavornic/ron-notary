import 'package:get/get.dart';
import 'package:notary/services/socket.dart';

class SocketController extends GetxController {
  SocketService _socketService = new SocketService();

  @override
  void onInit() {
    connect();
    super.onInit();
  }

  connect() {
    _socketService.connect();
  }

}