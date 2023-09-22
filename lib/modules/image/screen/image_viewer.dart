import 'package:ardunio_image/headers.dart';

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'dart:io' as io;

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    super.key,
    required this.postMedia,
    required this.height,
    required this.width,
  });
  final int height;
  final int width;
  final List<Uint8List> postMedia;
  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int _currentIndex = 0;
  final controller = cs.CarouselController();

  void onBackTap() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        controller.jumpToPage(_currentIndex);
      });
    }
  }

  void onNextTap() {
    if (_currentIndex < widget.postMedia.length - 1) {
      setState(() {
        _currentIndex++;
        controller.jumpToPage(_currentIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ic = Get.find<ImageController>();
    int count = 0;
    return Container(
      color: Colors.grey,
      child: AspectRatio(
        aspectRatio: widget.width / widget.height,
        child: Stack(
          children: [
            SizedBox.expand(
              child: cs.CarouselSlider(
                items: widget.postMedia
                    .map((image) => Image.file(
                          io.File(ic.imgPath(no: count++)),
                          filterQuality: FilterQuality.none,
                          fit: BoxFit.fitWidth,
                        ))
                    .toList(),
                carouselController: controller,
                options: cs.CarouselOptions(
                  aspectRatio: 4 / 5,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            if (widget.postMedia.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i < widget.postMedia.length;
                            i++) // Replace 3 with the number of items in your carousel
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == i
                                  ? Colors.black87
                                  : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.postMedia.length > 1)
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white30,
                      ),
                      child: IconButton(
                        onPressed: onBackTap,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        color: Colors.white30,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white30,
                      ),
                      child: IconButton(
                        onPressed: onNextTap,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
