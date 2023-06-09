import 'package:ardunio_image/headers.dart';

class BluetoothController extends GetxController {
  Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;
  Rx<String> address = "...".obs;
  Rx<String> name = "...".obs;

  late Communication _communication;

  @override
  void onInit() {
    super.onInit();
    _communication = Communication();
    _initBluetoothState();
  }

  Future<void> _initBluetoothState() async {
    bluetoothState.value = await FlutterBluetoothSerial.instance.state;
    address.value = await FlutterBluetoothSerial.instance.address ?? '';
    name.value = await FlutterBluetoothSerial.instance.name ?? '';

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      bluetoothState.value = state;
    });
  }

  // this module will tell to on the phone bluetooth
  void enableBluetooth() async {
    if (bluetoothState.value.isEnabled) {
      await FlutterBluetoothSerial.instance.requestDisable();
    } else {
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    // bluetoothState.value = await FlutterBluetoothSerial.instance.state;
  }

  void openBluetoothSettings() {
    print('Going to OPen Bluetooth');
    FlutterBluetoothSerial.instance.openSettings();
  }

  Future<void> connectToDevice(String deviceAddress) async {
    await _communication.connectBl(deviceAddress);
    _communication.sendMessage("Hello");
  }
}
