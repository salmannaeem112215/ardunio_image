import 'dart:io';

import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/image/screen/image_viewer.dart';

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
                        ic.state.value;
                        ic.count.value;
                        ic.selectedImages.length;
                        print('DEBUG:    ${ic.selectedImages.length}');
                        if (ic.state.value == ImageState.select) {
                          return const NoImage();
                        }
                        return ImageViewer(
                          key: Key(ic.count.toString()),
                          postMedia: ic.selectedImages,
                          height: ic.height,
                          width: ic.width,
                        );
                      }),
                      // child: Obx(() {
                      //   final state = ic.state.value;
                      //   if (state == ImageState.uploading) {
                      //     return const Uploading();
                      //   }
                      //   if (state == ImageState.select ||
                      //       ic.selectedImagePath.value.isEmpty) {
                      //     return const NoImage();
                      //   }
                      //   if (state == ImageState.selected) {
                      //     return Container(
                      //       decoration: BoxDecoration(
                      //           color: Colors.black12,
                      //           border: Border.all(
                      //             color: Colors.black54,
                      //             width: 3,
                      //           )),
                      //       height: (context.width - 32) * ic.height / ic.width,
                      //       child: Image.file(
                      //         File(ic.selectedImagePath.value),
                      //         fit: BoxFit.contain,
                      //         // To make it pixel Look
                      //         filterQuality: FilterQuality.none,
                      //       ),
                      //     );
                      //   }
                      //   return const NoImage();
                      // }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.copy)),
          const FloatingActionButtons(),
        ],
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

copyDataToClipboard(List<Uint8List> list,
    {String model = 'WS2812', String rgb = 'GRB'}) {
  final ic = Get.find<ImageController>();
  String val = '';
  val += "#include <avr/pgmspace.h> \n";
  val += '#include "FastLED.h" \n\n';
  val += "#define NUM_LEDS ${ic.width * ic.height}\n";
  val += "#define DATA_PIN 5 \n";
  val += "CRGB leds[NUM_LEDS];\n\n";
  val += 'const int IMAGES_LENGTH = ${list.length};  \n\n';

  val += 'const long Pic[][NUM_LEDS] PROGMEM = { \n';
  for (int i = 0; i < list.length; i++) {
    val += '{\n';
    val += ic.uint8ToString(list[i]);
    if (i != (list.length - 1)) {
      val += '},\n';
    } else {
      val += '}\n';
    }
  }
  val += '};\n';

  val += 'void setup() {\n';
  val += '  FastLED.addLeds<$model, DATA_PIN,$rgb>(leds, NUM_LEDS); \n';
  val += '  FastLED.setBrightness(5);\n';
  val += '}\n';
  val += 'void loop() {\n';
  val += '  for (int j = 0; j < IMAGES_LENGTH; j++) {\n';
  val += '    FastLED.clear();\n';
  val += '    for (int i = 0; i < NUM_LEDS; i++) {\n';
  val +=
      '      leds[i] = pgm_read_dword(&(Pic[j][i]));  // Read array from Flash\n';
  val += '    }\n';
  val += '    FastLED.show();\n';
  val += '    delay(500);\n';
  val += '  }\n';
  val += '}\n';
  val += '\n\n\n\n\n\n\n\n\n';

  FlutterClipboard.copy(val).then((value) => Get.snackbar('Value Copeid', ''));
}
