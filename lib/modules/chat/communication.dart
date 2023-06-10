import 'package:ardunio_image/headers.dart';

class Communication {
  //Bluetooth
  late FlutterBluetoothSerial fls;
  BluetoothConnection? connection;
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  String result = '';

  // Connect to the device via Bluetooth
  Future<void> connectBl(address) async {
    print('I Am Here');
    await BluetoothConnection.toAddress(address).then((_connection) {
      print('Connected to the device');
      connection = _connection;

      // Creates a listener to receive data
      connection!.input!.listen(onDataReceived).onDone(() {});
    }).catchError((error) {
      Get.snackbar('Connection Error1', 'Cannot connect, exception occured');
      Get.back();
      // Get.toNamed(AppPages.selectDevice);
    });
  }

  // When receive information
  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    result = String.fromCharCodes(buffer);
  }

  // To send Message
  Future<void> sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
      } catch (e) {}
    }
  }

  Future<void> dispose() async {
    fls.setPairingRequestHandler(null);
    if (connection != null && connection!.isConnected) {
      connection!.dispose();
      connection = null;
    }
  }
}
