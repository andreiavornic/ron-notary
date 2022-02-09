import 'package:get/get.dart';
import 'package:notary/services/socket_service.dart';
import 'network_manager.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<GetXNetworkManager>(GetXNetworkManager());
    Get.put<SocketService>(SocketService());
  }
}
