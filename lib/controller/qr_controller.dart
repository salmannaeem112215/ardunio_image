import 'package:ardunio_image/headers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrController extends GetxController {
  final name = TextEditingController();
  final address = TextEditingController();
  final pincode = TextEditingController();

  final qrValue = ''.obs;
  final scannedQrCode = ''.obs;

  void setQrCodeValue(String val) {
    qrValue.value = val;
  }

  void valueChanges() {
    qrValue.value =
        'Address: ${address.text}\nName: ${name.text}\nPIN Code: ${pincode.text}';
  }

  Future<void> scanQr() async {
    try {
      scannedQrCode.value = await FlutterBarcodeScanner.scanBarcode(
        '#666666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      print(scannedQrCode.value);
    } on PlatformException {}
  }
}
