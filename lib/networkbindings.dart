import 'package:get/get.dart';
import 'package:gshala/getxnetworkmanager.dart';

class NetWorkBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetXNetworkManager>(() => GetXNetworkManager());
  }
}
