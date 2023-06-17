import 'dart:io';

import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/image/view/no_image.dart';

import '../view/gallary_button.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageController ic = Get.put(ImageController());
    final heightR = 16;
    final widthR = 16;
    final ratio = heightR / widthR;
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
                          final state = ic.state.value;
                          if (state == ImageState.select ||
                              ic.selectedImagePath.value.isEmpty) {
                            print('No Image');
                            return const NoImage();
                          }
                          if (state == ImageState.selected) {
                            print('SHowing Selected Image');
                            return Image.file(File(ic.selectedImagePath.value));
                          }
                          // if (state == ImageState.croped) {
                          //   print('Image After Croped');
                          //   print("hi   ${ic.selectedImagePath}");
                          //   return Container(
                          //     decoration: BoxDecoration(
                          //         color: Colors.black12,
                          //         border: Border.all(
                          //           color: Colors.black54,
                          //           width: 3,
                          //         )),
                          //     // height: (context.width - 32) * ratio,
                          //     child: Image.file(
                          //       File(ic.selectedImagePath.value),
                          //       // File(ic.cropImagePath.value),
                          //       fit: BoxFit.contain,
                          //     ),
                          //   );
                          // }
                          return const NoImage();
                          // if (ic.selectedImagePath.value.isEmpty) {
                          // return const NoImage();
                          // } else {
                          // return Image.file(File(ic.selectedImagePath.value));
                          // }
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
          onTap: () async {
            ic.state.value = ImageState.select;
            final list = await ic.getImage(ImageSource.gallery);
            if (list.isEmpty) {
              ic.state.value = ImageState.select;
            } else {
              ic.state.value = ImageState.selected;
              // print('both are same  ${list[0] == list[1]}');
              print(' Total Images:  ${list.length}');
              String val = '[{\n';
              list.forEach((element) {
                val += ic.uint8ToString(element);
                val += '}\n';
                // print(element.length);
                // print(element.toString());
              });
              val += ']';

              FlutterClipboard.copy(val)
                  .then((value) => Get.snackbar('Value Copeid', ''));
            }
          },
        ));
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
