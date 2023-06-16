import 'package:ardunio_image/headers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(),
      permanent: true,
    );
    Get.put<QrController>(
      QrController(),
      permanent: true,
    );
    Get.put<ChatController>(
      ChatController(),
      permanent: true,
    );
  }
}
