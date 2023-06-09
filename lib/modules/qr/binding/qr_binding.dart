import 'package:ardunio_image/headers.dart';

class QrBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrController>(
      () => QrController(),
    );
  }
}
