import 'dart:io';
import 'package:image/image.dart' as imagi;
import 'package:ardunio_image/headers.dart';

enum ImageState { select, selected, processing, uploading, completed }

class ImageController extends GetxController {
  GlobalKey one = GlobalKey();
  final state = ImageState.select.obs;
  int height = 16;
  int width = 16;
  final selectedImagePath = ''.obs;

  Future<List<Uint8List>> getImage(ImageSource imageSource,
      {int height = 16, int width = 16}) async {
    selectedImagePath.value = '';

    final pickedFP = await _pickFile();

    if (pickedFP == null) {
      Get.snackbar('Error', 'Select Image Again');
      return [];
    }
    // set selectedImg
    selectedImagePath.value = pickedFP;
    state.value = ImageState.selected;

    // get Uint8List
    List<Uint8List> images = [];
    if (pickedFP.contains('.gif')) {
      images = await _convertGif(pickedFP);
    } else {
      final img = await _convertJpg(pickedFP);
      if (img != null) {
        images = [img];
      } else {
        images = [];
      }
    }
    return images;
  }

  Future<List<Uint8List>> _convertGif(String filePath) async {
    final List<Uint8List> imagess = [];

    final img = File(filePath);
    final bytes = await img.readAsBytes();
    final decoder = imagi.GifDecoder();
    decoder.decode(bytes);

    for (int i = 0; i < decoder.numFrames(); i++) {
      final decodedImg = decoder.decodeFrame(i);
      if (decodedImg == null) {
        Get.snackbar('Error', 'Got 1 image blank in Gif');
        continue;
      }

      final imgPath = await _storeFile(decodedImg, no: i);
      print(' Image Path $imgPath');
      if (imgPath == null) {
        Get.snackbar('Error',
            'Unable to Create temporary image- Free some storagte and try again');
        continue;
      }
      final imgBytes = await _convertJpg(imgPath, no: i);

      if (imgBytes == null) {
        Get.snackbar('Error', 'Unable To convert List');
        continue;
      }

      imagess.add(imgBytes);
    }
    return imagess;
  }

  Future<Uint8List?> _convertJpg(String filePath, {int no = 0}) async {
    // crop file
    print('To Cropped Image Path $filePath');
    final cropImageFile = await _cropFile(filePath);
    if (cropImageFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      return null;
    }

    //compress file
    final compressedFile = await _compressFile(cropImageFile.path, 'temp-$no');
    if (compressedFile == null) {
      Get.snackbar('Error', 'Unable To Compress Image, Please Try Again');
      state.value = ImageState.select;
      return null;
    }

    print('To Compressed Image Path ${compressedFile.path}');
    return await _imageToUint8List(File(compressedFile.path));
  }

  Future<Uint8List> _imageToUint8List(File img) async {
    final bytes = await img.readAsBytes();
    final decoder = imagi.JpegDecoder();
    final decodedImg = decoder.decode(bytes);
    final decodedBytes = decodedImg!.getBytes(order: imagi.ChannelOrder.rgb);
    return decodedBytes;
  }

  Future<String?> _pickFile() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      return null;
    }
    return pickedFile.path;
  }

  Future<CroppedFile?> _cropFile(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: height,
      maxWidth: width,
      aspectRatio:
          CropAspectRatio(ratioY: height.toDouble(), ratioX: width.toDouble()),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );
  }

  Future<XFile?> _compressFile(String source, String fileName) async {
    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/temp_$fileName.jpeg';

    return await FlutterImageCompress.compressAndGetFile(
      source,
      targetPath,
      quality: 90,
    );
  }

  Future<String?> _storeFile(imagi.Image img, {int no = 0}) async {
    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/store_temp-$no.jpg';
    final ins = imagi.encodeJpg(img, quality: 100);
    final val = await imagi.writeFile(targetPath, ins);
    return val == false ? null : targetPath;
  }

  String uint8ToString(Uint8List img) {
    String val = '';
    for (int i = 0; i < img.length; i += 3) {
      val +=
          '0x${intToHex(img[i])}${intToHex(img[i + 1])}${intToHex(img[i + 2])}, ';
      if (i % 16 == 0 && i != 0) {
        val += '\n';
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
}





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
