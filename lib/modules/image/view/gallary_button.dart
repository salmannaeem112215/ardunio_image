import 'package:ardunio_image/headers.dart';

class GallaryButton extends StatelessWidget {
  const GallaryButton({super.key, required this.onTap});
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 5,
      child: Card(
        color: Colors.black54,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            IconPath.openGallary,
            height: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
