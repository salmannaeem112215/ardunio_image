import 'dart:io';

import 'package:ardunio_image/headers.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageController ic = Get.put(ImageController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Upload'),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
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
                          if (state == ImageState.uploading) {
                            return const Uploading();
                          }
                          if (state == ImageState.select ||
                              ic.selectedImagePath.value.isEmpty) {
                            return const NoImage();
                          }
                          if (state == ImageState.selected) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: Colors.black54,
                                    width: 3,
                                  )),
                              height:
                                  (context.width - 32) * ic.height / ic.width,
                              child: Image.file(
                                File(ic.selectedImagePath.value),
                                fit: BoxFit.contain,
                                // To make it pixel Look
                                filterQuality: FilterQuality.none,
                              ),
                            );
                          }
                          return const NoImage();
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
        floatingActionButton: const FloatingActionButtons());
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

copyDataToClipboard(List<Uint8List> list) {
  final ic = Get.find<ImageController>();
  String val = '[';
  for (var element in list) {
    val += '{\n';
    val += ic.uint8ToString(element);
    val += '}\n';
  }
  val += ']\n';

  FlutterClipboard.copy(val).then((value) => Get.snackbar('Value Copeid', ''));
}
