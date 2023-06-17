import 'package:ardunio_image/headers.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final ic = Get.find<ImageController>();

    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GallaryButton(
            img: IconPath.openGallary,
            onTap: () async {
              // Get.back();
              ic.state.value = ImageState.select;
              final list = await ic.getImage(ImageSource.gallery);
              if (list.isEmpty) {
                ic.state.value = ImageState.select;
              } else {
                ic.state.value = ImageState.selected;
                copyDataToClipboard(list);
              }
            },
          ),
          const SizedBox(width: 20),
          if (ic.state.value != ImageState.select)
            GallaryButton(
              img: IconPath.send,
              color: const Color.fromARGB(134, 76, 175, 79),
              onTap: () async {
                ic.state.value = ImageState.uploading;
                final res = await ic.uploadImage();
                if (res == true) {
                  Get.snackbar('Image Upload', 'Succes');
                  ic.state.value = ImageState.selected;
                } else {
                  Get.snackbar('Failed', 'Try Again');
                  ic.state.value = ImageState.select;
                }
              },
            ),
        ],
      ),
    );
  }
}
