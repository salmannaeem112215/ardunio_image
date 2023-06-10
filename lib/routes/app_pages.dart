import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/qr/binding/qr_binding.dart';

class AppPages {
  static const String home = '/';
  static const String scan = '/scan';
  static const String chat = '/chat';
  static const String selectDevice = '/selectDevice';
  static const String initial = home;

  static List<GetPage> routes() => [
        GetPage(
          name: home,
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: scan,
          page: () => const QrScreen(),
          binding: QrBindings(),
        ),
        GetPage(
          name: selectDevice,
          page: () => const SelectDeviceScreen(),
          binding: SelectDeviceBinding(),
        ),
        GetPage(
          name: chat,
          page: () => const ChatScreen(),
        ),
      ];
}
