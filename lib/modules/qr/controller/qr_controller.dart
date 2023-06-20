import 'package:ardunio_image/headers.dart';

class QrController extends GetxController {
  Future<QrData?> scanQr() async {
    try {
      final scannedQrCode = await FlutterBarcodeScanner.scanBarcode(
        '#666666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (scannedQrCode == '-1') {
        Get.snackbar('QR Scanner ', 'Scanning Process Canceled');
        return null;
      } else {
        return QrData.fromJson(scannedQrCode);
      }
    } on PlatformException {
      return null;
    }
  }
}
