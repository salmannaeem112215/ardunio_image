import 'package:ardunio_image/constants/icons_path.dart';
import 'package:flutter/material.dart';

class NoImage extends StatelessWidget {
  const NoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(IconPath.noImage),
        const SizedBox(height: 10),
        const Text(
          'Please Select Image',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
