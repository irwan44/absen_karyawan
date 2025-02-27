import 'package:get/get.dart';

import '../controllers/cuti_controller.dart';

class CutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CutiController>(
      () => CutiController(),
    );
  }
}
