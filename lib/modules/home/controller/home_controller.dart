import 'package:ardunio_image/headers.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bb;
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  final instance = FlutterBluetoothSerial.instance;
  Rx<BluetoothState> bluetoothState = BluetoothState.UNKNOWN.obs;
  BluetoothDevice? conBDevice;
  int height = 0;
  int width = 0;
  bool get isBluetoothAllowed {
    if (bAdvertise == false || bScan == false || bConnect == false) {
      return false;
    }
    return true;
  }

  bool bAdvertise = false;
  bool bScan = false;
  bool bConnect = false;

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
      if (await askPermissions() != true) {
        Get.snackbar('Error', 'Please Enable Permission');
        return;
      }
      if (bluetoothState.value.isEnabled) {
        await instance.requestDisable();
      } else {
        await instance.requestEnable();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void openBluetoothSettings() {
    instance.openSettings();
  }

  Future<List<BluetoothDevice>> scanDevice() async {
    if (await askPermissions() != true) {
      Get.snackbar('Error', 'Please Enable Permission');
      return [];
    }
    final devices = await instance.getBondedDevices();
    return devices;
  }

  checkBluetoothPermission() async {
    final statusA = await Permission.bluetoothAdvertise.status;
    final statusC = await Permission.bluetoothConnect.status;
    final statusS = await Permission.bluetoothScan.status;

    bAdvertise = statusA == PermissionStatus.granted;
    bConnect = statusC == PermissionStatus.granted;
    bScan = statusS == PermissionStatus.granted;

    isBluetoothAllowed ? null : askPermissions();
  }

  Future<bool> askPermissions() async {
    if (isBluetoothAllowed == true) {
      return true;
    }

    if (bAdvertise != true) {
      final res = await Permission.bluetoothAdvertise.request();
      res.isGranted ? bAdvertise = true : bAdvertise = false;
    }
    if (bConnect != true) {
      final res = await Permission.bluetoothConnect.request();
      res.isGranted ? bConnect = true : bConnect = false;
    }
    if (bScan != true) {
      final res = await Permission.bluetoothScan.request();
      res.isGranted ? bScan = true : bScan = false;
    }
    return isBluetoothAllowed;
  }
}
