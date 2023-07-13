import 'package:ardunio_image/headers.dart';

class Uploading extends StatelessWidget {
  const Uploading({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();
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
        Obx(() {
          int time = cc.timeToW8.value;
          String msg = time < 0 ? 'Calculating Time' : 'Time Left : $time secs';
          return Text(
            msg,
            style: textStyle(),
          );
        }),
      ],
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
