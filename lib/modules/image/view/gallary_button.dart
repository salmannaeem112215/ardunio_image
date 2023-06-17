import 'package:ardunio_image/headers.dart';

class GallaryButton extends StatelessWidget {
  const GallaryButton({
    super.key,
    required this.onTap,
    required this.img,
    this.color = Colors.black54,
  });
  final Function() onTap;
  final Color color;
  final String img;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 5,
      child: Card(
        color: color,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            img,
            height: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
