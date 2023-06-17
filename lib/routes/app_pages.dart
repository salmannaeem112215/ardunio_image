import 'package:ardunio_image/headers.dart';

class AppPages {
  static const String home = '/';
  static const String scan = '/scan';
  static const String chat = '/chat';
  static const String image = '/image';
  static const String selectDevice = '/selectDevice';
  static const String initial = image;

  static List<GetPage> routes() => [
        GetPage(
          name: home,
          page: () => const HomeScreen(),
          // binding: HomeBinding(),
        ),
        GetPage(
          name: chat,
          page: () => const ChatScreen(),
          // binding: ChatBinding(),
        ),
        GetPage(
          name: image,
          page: () => const ImageScreen(),
          binding: ImageBinding(),
        ),
      ];
}
