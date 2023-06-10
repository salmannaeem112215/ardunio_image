import 'package:ardunio_image/headers.dart';

class BluetoothController extends GetxController {
  final instance = FlutterBluetoothSerial.instance;

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
    bluetoothState.value = await instance.state;
    address.value = await instance.address ?? '';
    name.value = await instance.name ?? '';

    instance.onStateChanged().listen(
          (state) => setBluetoothSate(state),
        );
  }

  void setBluetoothSate(BluetoothState state) {
    bluetoothState.value = state;
    if (state == BluetoothState.STATE_BLE_TURNING_OFF ||
        state == BluetoothState.STATE_OFF) {
      if (Get.currentRoute != AppPages.home) {
        Get.snackbar(
            'Bluetooth Disconnected', 'Please Turn on Your Bluetooth ');
        Get.toNamed(AppPages.home);
      }
    }
  }

  // this module will tell to on the phone bluetooth
  void enableBluetooth() async {
    if (bluetoothState.value.isEnabled) {
      await instance.requestDisable();
    } else {
      await instance.requestEnable();
    }
    // bluetoothState.value = await FlutterBluetoothSerial.instance.state;
  }

  void openBluetoothSettings() {
    print('Going to OPen Bluetooth');
    instance.openSettings();
  }

  Future<void> connectToDevice(String deviceAddress) async {
    await _communication.connectBl(deviceAddress);
    _communication.sendMessage("Hello");
  }
}
