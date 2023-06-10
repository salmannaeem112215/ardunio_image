import 'package:ardunio_image/headers.dart';

class HomeController extends GetxController {
  final instance = FlutterBluetoothSerial.instance;

  Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;
  BluetoothDevice? conBDevice = null;

  @override
  void onInit() {
    super.onInit();
    _initBluetoothState();
  }

  Future<void> _initBluetoothState() async {
    bluetoothState.value = await instance.state;

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
  }

  void openBluetoothSettings() {
    instance.openSettings();
  }

  Future<List<BluetoothDevice>> scanDevice() async {
    final devices = await instance.getBondedDevices();
    return devices;
  }

  // Future<void> connectToDevice(String deviceAddress) async {
  //   await _communication.connectBl(deviceAddress);
  //   _communication.sendMessage("Hello");
  // }
}
