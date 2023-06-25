import 'package:ardunio_image/headers.dart';

class Uploading extends StatelessWidget {
  const Uploading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(IconPath.uploading),
        const SizedBox(height: 10),
        const Text(
          'Uploading To Ardunio!',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Obx(
          () => Text(
            'Time Left - ${Get.find<ChatController>().timeToW8.value} secs',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
