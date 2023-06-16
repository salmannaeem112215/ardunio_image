import 'package:ardunio_image/headers.dart';

class NoMessage extends StatelessWidget {
  const NoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(IconPath.noMessage),
            const SizedBox(width: 20),
            const Text(
              'Type Message and Send To Ardunio',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
