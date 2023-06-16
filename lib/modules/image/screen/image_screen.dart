import 'dart:io';

import 'package:ardunio_image/headers.dart';

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
                children: [
                  SizedBox(
                    height: 500,
                    child: Obx(() {
                      if (ic.selectedImagePath.value.isEmpty) {
                        return const Text('Please Select Image');
                      } else {
                        return Image.file(File(ic.selectedImagePath.value));
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 500,
                    child: Obx(() {
                      print('value chagned ${ic.compressImagePath.value}');
                      if (ic.compressImagePath.value.isEmpty) {
                        return const Text('Please Select Image');
                      } else {
                        return Image.file(File(ic.compressImagePath.value));
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  Divider(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () => ic.getImage(ImageSource.gallery),
                      child: const Text(
                        'Select Image',
                        style: TextStyle(fontSize: 18),
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
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
