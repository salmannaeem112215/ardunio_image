import 'dart:io';
import 'package:image/image.dart' as imagi;
import 'package:ardunio_image/headers.dart';

enum ImageState { select, selected, processing, uploading, completed }

class ImageController extends GetxController {
  GlobalKey one = GlobalKey();
  final state = ImageState.select.obs;
  final count = 0.obs;
  int height = 8;
  int width = 8;
  final selectedImages = <Uint8List>[].obs;

  // Future<List<Uint8List>> getImage(
  //   ImageSource imageSource,
  // ) async {
  //   selectedImagePath.value = '';

  //   final pickedFP = await _pickFile();

  //   if (pickedFP == null) {
  //     Get.snackbar('Error', 'Select Image Again');
  //     return [];
  //   }
  //   // set selectedImg
  //   selectedImagePath.value = pickedFP;
  //   state.value = ImageState.selected;

  //   // get Uint8List
  //   List<Uint8List> images = [];
  //   if (pickedFP.contains('.gif')) {
  //     images = await _convertGif(pickedFP);
  //   } else {
  //     final img = await _convertJpg(pickedFP);
  //     if (img != null) {
  //       images = [img];
  //     } else {
  //       images = [];
  //     }
  //   }
  //   imagesList.clear();
  //   imagesList.assignAll(images);
  //   return images;
  // }

  Future<bool> uploadImage() async {
    return await Get.find<ChatController>().uploadImage(selectedImages);
  }

  // Future<List<Uint8List>> _convertGif(String filePath) async {
  //   final List<Uint8List> imagess = [];
  //   final img = File(filePath);
  //   final bytes = await img.readAsBytes();
  //   final decoder = imagi.GifDecoder();
  //   decoder.decode(bytes);

  //   for (int i = 0; i < decoder.numFrames(); i++) {
  //     final decodedImg = decoder.decodeFrame(i);
  //     if (decodedImg == null) {
  //       Get.snackbar('Error', 'Got 1 image blank in Gif');
  //       continue;
  //     }

  //     final imgPath = await _storeFile(decodedImg, no: i);
  //     if (imgPath == null) {
  //       Get.snackbar('Error',
  //           'Unable to Create temporary image- Free some storagte and try again');
  //       continue;
  //     }
  //     final imgBytes = await _convertJpg(imgPath, no: i);

  //     if (imgBytes == null) {
  //       continue;
  //     }

  //     imagess.add(imgBytes);
  //   }
  //   return imagess;
  // }

  // Future<Uint8List?> _convertJpg(String filePath, {int no = 0}) async {
  //   // crop file
  //   final cropImageFile = await _cropFile(filePath);
  //   if (cropImageFile == null) {
  //     Get.snackbar('Reminder', 'You Skip Image');
  //     return null;
  //   }

  //   //compress file
  //   final compressedFile = await _compressFile(cropImageFile.path, 'temp-$no');
  //   if (compressedFile == null) {
  //     Get.snackbar('Error', 'Unable To Compress Image, Please Try Again');
  //     state.value = ImageState.select;
  //     return null;
  //   }
  //   selectedImagePath.value = compressedFile.path;
  //   return await _imageToUint8List(File(compressedFile.path));
  // }

  Future<Uint8List> _imageToUint8List(File img) async {
    final bytes = await img.readAsBytes();
    final decoder = imagi.JpegDecoder();
    final decodedImg = decoder.decode(bytes);
    final decodedBytes = decodedImg!.getBytes(order: imagi.ChannelOrder.rgb);
    return decodedBytes;
  }

  // Future<String?> _pickFile() async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile == null) {
  //     Get.snackbar('Error', 'Please Select Image Again');
  //     return null;
  //   }
  //   return pickedFile.path;
  // }

  // newCropFile() async {}

  // Future<CroppedFile?> _cropFile(String filePath) async {
  //   final image = await imagi.decodeImageFile(filePath);
  //   print(
  //       "DEBUG: Length is ${image!.getBytes().length}   ${image.frames.length}");

  //   final cImage = imagi.copyResize(
  //     image!,
  //     width: 8,
  //     height: 8,
  //   );

  //   final l = cImage.getBytes().length;
  //   print("DEBUG: Length is $l   ${cImage.numFrames}");

  //   return await ImageCropper().cropImage(
  //     sourcePath: filePath,
  //     maxHeight: height,
  //     maxWidth: width,
  //     aspectRatio:
  //         CropAspectRatio(ratioY: height.toDouble(), ratioX: width.toDouble()),
  //     compressFormat: ImageCompressFormat.jpg,
  //     compressQuality: 100,
  //   );
  // }

  // Future<XFile?> _compressFile(String source, String fileName) async {
  //   final dir = Directory.systemTemp;
  //   final targetPath = '${dir.absolute.path}/temp_$fileName.jpeg';

  //   return await FlutterImageCompress.compressAndGetFile(
  //     source,
  //     targetPath,
  //     quality: 90,
  //   );
  // }

  Future<String?> _storeFile(imagi.Image img, {int no = 0}) async {
    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/store_temp-$no.jpeg';
    final ins = imagi.encodeJpg(img, quality: 100);
    final val = await imagi.writeFile(targetPath, ins);
    return val == false ? null : targetPath;
  }

  String imgPath({int no = 0}) {
    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/store_temp-$no.jpeg';
    return targetPath;
  }

  String uint8ToString(Uint8List img) {
    String val = '';
    int length = img.length;
    int totalPixels = img.length ~/ 3;
    for (int i = 0; i < length; i += 3) {
      val +=
          '0x${intToHex(img[i])}${intToHex(img[i + 1])}${intToHex(img[i + 2])}';
      int index = (i + 3) ~/ 3;
      if (index % width == 0) {
        val += index == totalPixels ? '\n' : ', \n';
      } else {
        val += ', ';
      }
    }
    return val;
  }

  String intToHex(int n) {
    if (n < 0 || n > 255) {
      throw ArgumentError("Integer value must be between 0 and 255.");
    }
    String hexString = n.toRadixString(16).toUpperCase();
    return hexString.padLeft(2, '0');
  }

  convertImage() async {
    try {
      state.value = ImageState.select;
      final pFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pFile == null) return;

      imagi.Image image;
      if (pFile.path.contains('.gif')) {
        // IS GIF
        print("DEBUG: is GIF");
        final img = await imagi.decodeGifFile(pFile.path);
        if (img == null) return;
        image = img;
      } else {
        // IS IMAGE
        print("DEBUG: is Image");
        final img = await imagi.decodeImageFile(pFile.path);
        if (img == null) return;
        image = img;
      }

      print("DEBUG: FRAMSES  ${image.frames.length}");
      List<Uint8List> images = [];

      for (int i = 0; i < image.frames.length; i++) {
        final img = image.getFrame(i);
        final cImage = imagi.copyResize(img, height: height, width: width);
        final cPath = await _storeFile(cImage, no: i);
        final data = await _imageToUint8List(File(cPath!));
        print("DEBUG: ADDED IMAGE $i   ${data.length}");
        images.add(data);
      }

      selectedImages.clear();
      selectedImages.assignAll(images);
      count.value++;

      state.value = ImageState.selected;

      copyDataToClipboard(selectedImages);
    } catch (e) {
      print("DEBUG: ERROR HERE $e");
    }
  }
}
