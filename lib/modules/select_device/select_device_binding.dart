import 'package:ardunio_image/headers.dart';

class SelectDeviceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectDeviceController>(
      () => SelectDeviceController(),
    );
  }
}
