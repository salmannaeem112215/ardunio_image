import 'package:ardunio_image/headers.dart';

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
    final qr =
        QrData(name: name.text, address: address.text, pin: pincode.text);
    qrValue.value = json.encode(qr.toJson());
  }

  Future<QrData?> scanQr() async {
    try {
      scannedQrCode.value = await FlutterBarcodeScanner.scanBarcode(
        '#666666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (scannedQrCode.value == '-1') {
        return null;
      } else {
        return QrData.fromJson(scannedQrCode.value);
      }
    } on PlatformException {
      return null;
    }
  }

  void extractValues(String inputString) {
    final qr = QrData.fromJson(inputString);
    name.text = qr.name;
    address.text = qr.address;
    pincode.text = qr.pin;
  }

// Example usage
  final inputString =
      'Address: "HC:00:00:00:00"\nName: "John Doe"\nPIN Code: "123456"';
}
