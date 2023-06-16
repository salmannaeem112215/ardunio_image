import 'dart:io';
import 'package:image/image.dart' as imagi;
import 'package:ardunio_image/headers.dart';

class ImageController extends GetxController {
  final selectedImagePath = ''.obs;
  final selectedImageSize = ''.obs;
  final size = const Size(16, 16).obs;

  final cropImagePath = ''.obs;
  final cropImageSize = ''.obs;

  final compressImagePath = ''.obs;
  final compressImageSize = ''.obs;

  void getImage(ImageSource imageSource,
      {int height = 500, int width = 500}) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    // if (pickedFile != null) {
    selectedImagePath.value = '';
    compressImagePath.value = '';
    selectedImagePath.value = pickedFile!.path;
    selectedImageSize.value = _getFileSize(selectedImagePath.value);

    // Crop File
    final cropImageFile = await ImageCropper().cropImage(
      sourcePath: selectedImagePath.value,
      maxHeight: 16,
      maxWidth: 16,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      // compressQuality: 100,
    );

    cropImagePath.value = cropImageFile!.path;
    cropImageSize.value = _getFileSize(cropImagePath.value);

    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/temp.jpeg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      cropImagePath.value,
      targetPath,
      quality: 90,
    );

    compressImagePath.value = compressedFile!.path;
    compressImageSize.value = _getFileSize(compressImagePath.value);

    readImage(File(compressImagePath.value));

    // uploadImage(comressFiles);
    // } else {
    //   Get.snackbar('Error', 'No Image Selected',
    //       snackPosition: SnackPosition.BOTTOM);
    // }
  }

  List<String> imgArray = [];
  void readImage(File img) async {
    imgArray.clear();
    final bytes = await img.readAsBytes();
    final decoder = imagi.JpegDecoder();
    final decodedImg = decoder.decode(bytes);
    final decodedBytes = decodedImg!.getBytes(order: imagi.ChannelOrder.rgb);

    int loopLimit = decodedImg.width * decodedImg.height;
    // int loopLimit = 1000;
    for (int i = 0; i < decodedImg.height; i++) {
      for (int j = 0; j < decodedImg.width; j++) {
        int red = decodedBytes[(i * j) * 3];
        int green = decodedBytes[(i * j) * 3 + 1];
        int blue = decodedBytes[(i * j) * 3 + 2];
        imgArray.add(convertToHex([red, green, blue]));
      }
    }

    print('ImageArrayLength : ${imgArray.length}');
    print('content : ${imgArray.toString()}');

    String d = '';
    for (int i = 0; i < decodedImg.height; i++) {
      for (int j = 0; j < decodedImg.width; j++) {
        d += '${imgArray[i]}, ';
      }
      d += '\n';
    }
    for (int i = 0; i < 256; i++) {}
    FlutterClipboard.copy(d)
        .then((value) => Get.snackbar('Coppied', 'Valued Coppied '));
  }

  List<String> convertToHexString(List<List<int>> rgbList) {
    List<String> hexList = [];
    print('RGB LENGTH IS  ${rgbList.length / 16}');

    for (List<int> rgb in rgbList) {
      final String hex = rgb
          .map((int value) => value.toRadixString(16).padLeft(2, '0'))
          .join('');
      String hexValue = '0x$hex';
      hexList.add(hexValue);
    }

    return hexList;
  }

  void sendRgbArrayToArduino(List<List<int>> rgbArray) {
    print('HI');
    // Convert RGB array to a character array
    final charArray = <String>[];
    for (final row in rgbArray) {
      for (final pixel in row) {
        final char = String.fromCharCode(pixel);
        print('HIII $char');
        charArray.add(char);
      }
    }

    // Send the character array to Arduino
    final arduinoData = charArray.join();
    // TODO: Implement code to send data to Arduino
    print('Arduinio Data  $arduinoData');
    print(arduinoData);
    // FlutterClip
  }

  String _getFileSize(String path) {
    return '${(File(path).lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB';
  }
}

String convertToHex(List<int> rgbValues) {
  String hexValue = '';

  for (int value in rgbValues) {
    String hex = value.toRadixString(16).padLeft(2, '0');
    hexValue += hex;
  }

  return '0x$hexValue';
}

// Future<List<List<int>>> imageToRGBArray(Image image) async {
//   // Convert Flutter Image to Uint8List
//   // image.image.
//   // final ByteData byteData = await image.image.toByteData(format: ImageByteFormat.rawRgba);
//   // final Uint8List imageData = byteData.buffer.asUint8List();

//   // Compress image using flutter_image_compress
//   // final compressedData = await FlutterImageCompress.compressWithList(imageData,
//       // minHeight: 1, minWidth: 1, format: CompressFormat.png);

//   // Decode the compressed image into an RGB array using the image package
//   // final decodedImage = imagi.decodeImage(compressedData);

//   // Extract RGB values from the decoded image and return as a 2D array
//   final rgbArray = <List<int>>[];
//   // for (var y = 0; y < decodedImage.height; y++) {
//     // final row = <int>[];
//     // for (var x = 0; x < decodedImage.width; x++) {
//       // final pixel = decodedImage.getPixel(x, y);
//       // final r = img.getRed(pixel);
//       // final g = img.getGreen(pixel);
//       // final b = img.getBlue(pixel);
//       // row.add(r);
//       // row.add(g);
//       // row.add(b);
//     // }
//     // rgbArray.add(row);
//   }

//   // return rgbArray;
// }



    // for (int x = 0; x < 256; x++) {
    //   int red = decodedBytes[x * 3];
    //   int green = decodedBytes[x * 3 + 1];
    //   int blue = decodedBytes[x * 3 + 2];
    //   imgArray.add([red, green, blue]);
    // }



// 0xf6ffff,0xf7ffff,0xfafef0,0xfbfff1,0xfffbff,0xfffaff,0xfbfffa,0xfbfffa,0xfbfffa,0xfbfffa,0xfffaff,0xfffbff,0xfbfff1,0xfafef0,0xf7ffff,0xf6ffff,
// 0xf7ffff,0xf3fdff,0xfefff4,0xfbfff1,0xfffbff,0xfffbff,0xf6fdf5,0xf8fff7,0xf8fff7,0xf6fdf5,0xfffbff,0xfffbff,0xfbfff1,0xfefff4,0xf3fdff,0xf7ffff,
// 0xfffeff,0xfffdfe,0xf3f5f2,0xfbfdfa,0xfff4ff,0xfff5ff,0x5a0000,0x570000,0x570000,0x5a0000,0xfff5ff,0xfff4ff,0xfbfdfa,0xf3f5f2,0xfffdfe,0xfffeff,
// 0xfffeff,0xfffbfc,0xfbfdfa,0xfdfffc,0x080007,0x080007,0xa24641,0xa14540,0xa14540,0xa24641,0x080007,0x080007,0xfdfffc,0xfbfdfa,0xfffbfc,0xfffeff,
// 0xfffefb,0xfffcf9,0xfbffff,0x01060c,0xe61727,0xed1e2e,0xf42e2b,0xe6201d,0xe6201d,0xf42e2b,0xed1e2e,0xe61727,0x01060c,0xfbffff,0xfffcf9,0xfffefb,
// 0xfcf8f5,0xfffefb,0xf9feff,0x00040a,0xf22333,0xe41525,0xf02a27,0xe7211e,0xe7211e,0xf02a27,0xe41525,0xf22333,0x00040a,0xf9feff,0xfffefb,0xfcf8f5,
// 0xfffffa,0xfffcf7,0x450000,0x8e453f,0xf42116,0xff3227,0x6a4c4e,0x1b0000,0x1b0000,0x6a4c4e,0xff3227,0xf42116,0x8e453f,0x450000,0xfffcf7,0xfffffa,
// 0xfffffa,0xfaf7f2,0x500701,0x924943,0xf32015,0xf01d12,0x1d0001,0xffeef0,0xffeef0,0x1d0001,0xf01d12,0xf32015,0x914842,0x500701,0xfaf7f2,0xfffffa,
// 0xfffcfa,0xfffcfa,0x000200,0x010400,0x05060a,0x000004,0x0a0000,0xfffafd,0xfffafd,0x0a0000,0x000004,0x05060a,0x010400,0x000200,0xfffcfa,0xfffbf9,
// 0xfffaf8,0xfff5f3,0x080b02,0xfefff8,0xfcfdff,0xfeffff,0xfff9fc,0x0a0000,0x0a0000,0xfff9fc,0xfeffff,0xfcfdff,0xfefff8,0x080b02,0xfff5f3,0xfffaf8,
// 0xfbfdff,0xfafcff,0xf5fbf9,0x000402,0xfeffff,0xfafbff,0xf8fff7,0xfbfffa,0xfbfffa,0xf8fff7,0xfafbff,0xfeffff,0x000402,0xf5fbf9,0xfafcff,0xfbfdff,
// 0xf8faff,0xfbfdff,0xfbffff,0x000402,0xf8f9fe,0xfeffff,0xfbfffa,0xf7fef6,0xf7fef6,0xfbfffa,0xfeffff,0xf8f9fe,0x000402,0xfbffff,0xfbfdff,0xf8faff,
// 0xfffdf1,0xfff9ed,0xfffeff,0xfaf8fb,0x030102,0x040203,0xf7fffd,0xf7fffd,0xf7fffd,0xf7fffd,0x040203,0x030102,0xfaf8fb,0xfffeff,0xfff9ed,0xfffdf1,
// 0xfffdf1,0xfff8ec,0xfdfbfe,0xfffeff,0xfbf9fa,0xfbf9fa,0x000b04,0x000500,0x000500,0x000b04,0xfbf9fa,0xfbf9fa,0xfffeff,0xfdfbfe,0xfff8ec,0xfffdf1,
// 0xf8fefa,0xf9fffb,0xfffffd,0xfffffd,0xfefeff,0xfefeff,0xfff7f5,0xfffcfa,0xfffcfa,0xfff7f5,0xfefeff,0xfefeff,0xfffffd,0xfffffd,0xf9fffb,0xf8fefa,
// 0xfafffc,0xf7fdf9,0xfffffd,0xfdfcfa,0xfcfcff,0xf8f8ff,0xfffcfa,0xfff7f5,0xfff7f5,0xfffcfa,0xf8f8ff,0xfcfcff,0xfdfcfa,0xfffffd,0xf7fdf9,0xfafffc