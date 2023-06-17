import 'dart:io';

import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/image/view/no_image.dart';

import '../view/gallary_button.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageController ic = Get.put(ImageController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Center(
                      child: Obx(() {
                        if (ic.selectedImagePath.value.isEmpty) {
                          return const NoImage();
                        } else {
                          return Image.file(File(ic.selectedImagePath.value));
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GallaryButton(
        onTap: () {},
      ),
    );
  }
}

kInputDecoration(String lable) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelText: lable,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(fontSize: 18),
    );
