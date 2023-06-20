import 'package:ardunio_image/headers.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bb;
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  final instance = FlutterBluetoothSerial.instance;
  bool bluetoothAllowed = false;
  Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;
  BluetoothDevice? conBDevice;
  int height = 0;
  int width = 0;

  @override
  void onInit() {
    super.onInit();
    _initBluetoothState();
  }

  Future<void> _initBluetoothState() async {
    bluetoothState.value = await instance.state;
    checkBluetoothPermission();

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
    try {
      print('HIII');
      print('Bluetooth State is ${bb.BluetoothBondState} ');
      if (await askPermission() != true) {
        print('Permission not granted');
        Get.snackbar('Error', 'Please Enable Permission');
        return;
      }
      print('Permission granted');

      print('HIII');

      if (bluetoothState.value.isEnabled) {
        await instance.requestDisable();
      } else {
        await instance.requestEnable();
      }
    } catch (e) {
      print(e);
    }
  }

  void openBluetoothSettings() {
    instance.openSettings();
  }

  Future<List<BluetoothDevice>> scanDevice() async {
    if (await askPermission() != true) {
      Get.snackbar('Error', 'Please Enable Permission');
      return [];
    }
    final devices = await instance.getBondedDevices();
    return devices;
  }

  checkBluetoothPermission() async {
    final status = await Permission.bluetoothConnect.status;
    if (status == PermissionStatus.granted) {
      bluetoothAllowed = true;
    } else {
      await askPermission();
    }
  }

  Future<bool> askPermission() async {
    if (bluetoothAllowed == true) {
      return true;
    }
    final res = await Permission.bluetoothConnect.request();
    if (res == PermissionStatus.granted) {
      bluetoothAllowed = true;
      return true;
    } else {
      bluetoothAllowed = false;
      return false;
    }
  }
  // Future<void> connectToDevice(String deviceAddress) async {
  //   await _communication.connectBl(deviceAddress);
  //   _communication.sendMessage("Hello");
  // }
}
