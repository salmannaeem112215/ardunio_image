import 'dart:io';
import 'package:image/image.dart' as imagi;
import 'package:ardunio_image/headers.dart';

enum ImageState { select, selected, croped, uploading, completed }

class ImageController extends GetxController {
  GlobalKey one = GlobalKey();
  final state = ImageState.select.obs;
  final selectedImagePath = ''.obs;
  final selectedImageSize = ''.obs;
  final size = const Size(16, 16).obs;

  final cropImagePath = ''.obs;
  final cropImageSize = ''.obs;

  final compressImagePath = ''.obs;
  final compressImageSize = ''.obs;

  Future<List<Uint8List>> extractGifFrames(File img) async {
    final List<Uint8List> imagess = [];
    final bytes = await img.readAsBytes();
    final decoder = imagi.GifDecoder();
    decoder.decode(bytes);
    print('frames ${decoder.numFrames()}');
    for (int i = 0; i < decoder.numFrames(); i++) {
      final decodedImg = decoder.decodeFrame(i);

      final dir = Directory.systemTemp;
      final targetPath = '${dir.absolute.path}/temp${i}.jpg';
      final ins = imagi.encodeJpg(decodedImg!, quality: 100);
      final val = await imagi.writeFile(targetPath, ins);

      final v = await convertImage(targetPath, height: 16, width: 16);
      // final v = await readFile(newSourcetargetPath);

      print(v!.length);
      print(v.toString());
      state.value = ImageState.select;
      selectedImagePath.value = targetPath;
      state.value = ImageState.croped;

      imagess.add(v);
    }
    return imagess;
  }

  void getImage(ImageSource imageSource,
      {int height = 16, int width = 16}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );
    if (pickedFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      state.value = ImageState.select;
      return;
    }

    selectedImagePath.value = '';
    compressImagePath.value = '';
    selectedImagePath.value = pickedFile.path;
    selectedImageSize.value = _getFileSize(selectedImagePath.value);
    state.value = ImageState.selected;
//    Crop File
    print('Height $height Width $width');
    final cropImageFile = await ImageCropper().cropImage(
      sourcePath: selectedImagePath.value,
      maxHeight: height,
      maxWidth: width,
      aspectRatio:
          CropAspectRatio(ratioY: height.toDouble(), ratioX: width.toDouble()),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );

    if (cropImageFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      state.value = ImageState.select;
      print('HI Error');
      return;
    }

    print('No Erro ${cropImageFile!.path}');
    cropImagePath.value = cropImageFile!.path;
    cropImageSize.value = _getFileSize(cropImagePath.value);
    state.value = ImageState.croped;

    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/temp.jpeg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      cropImagePath.value,
      targetPath,
      quality: 90,
    );
    if (compressedFile == null) {
      Get.snackbar('Error', 'Unable To Compress Image, Please Try Again');
      state.value = ImageState.select;
    }
    compressImagePath.value = compressedFile!.path;
    compressImageSize.value = _getFileSize(compressImagePath.value);
    state.value = ImageState.croped;
    print('Here');
    readImage(File(compressImagePath.value));
  }

  Future<Uint8List?> convertImage(String imgPath,
      {int height = 16, int width = 16}) async {
    selectedImagePath.value = imgPath;
    selectedImageSize.value = _getFileSize(selectedImagePath.value);
    state.value = ImageState.selected;

//    Crop File
    print('Height $height Width $width');
    final cropImageFile = await ImageCropper().cropImage(
      sourcePath: selectedImagePath.value,
      maxHeight: height,
      maxWidth: width,
      aspectRatio:
          CropAspectRatio(ratioY: height.toDouble(), ratioX: width.toDouble()),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
    );

    if (cropImageFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      state.value = ImageState.select;
      print('HI Error');
      return null;
    }

    print('No Erro ${cropImageFile!.path}');
    cropImagePath.value = cropImageFile!.path;
    cropImageSize.value = _getFileSize(cropImagePath.value);
    state.value = ImageState.croped;

    final dir = Directory.systemTemp;
    final targetPath = '${dir.absolute.path}/temp.jpeg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      cropImagePath.value,
      targetPath,
      quality: 90,
    );
    if (compressedFile == null) {
      Get.snackbar('Error', 'Unable To Compress Image, Please Try Again');
      state.value = ImageState.select;
    }
    compressImagePath.value = compressedFile!.path;
    compressImageSize.value = _getFileSize(compressImagePath.value);
    // selectedI
    state.value = ImageState.croped;
    return await readImage(File(compressImagePath.value));
  }

  List<String> imgArray = [];
  Future<Uint8List> readImage(File img) async {
    imgArray.clear();
    final bytes = await img.readAsBytes();
    final decoder = imagi.JpegDecoder();
    final decodedImg = decoder.decode(bytes);
    final decodedBytes = decodedImg!.getBytes(order: imagi.ChannelOrder.rgb);
    print('Decoded Bytes Length ${decodedBytes.length}');
    print('Decoded Bytes $decodedBytes');
    print('${decodedImg!.height} x ${decodedImg!.width}');

    return decodedBytes;
  }

  void getGifImage(ImageSource imageSource,
      {int height = 16, int width = 16}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );
    if (pickedFile == null) {
      Get.snackbar('Error', 'Please Select Image Again');
      state.value = ImageState.select;
      return;
    }

    selectedImagePath.value = '';
    compressImagePath.value = '';
    ImageState.select;
    selectedImagePath.value = pickedFile.path;
    selectedImageSize.value = _getFileSize(selectedImagePath.value);
    state.value = ImageState.selected;
    state.value = ImageState.croped;

    final s = await extractGifFrames(
      File(selectedImagePath.value),
    );
    print(s.length);
  }

  String _getFileSize(String path) {
    return '${(File(path).lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB';
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


