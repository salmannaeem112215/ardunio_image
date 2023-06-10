import 'package:ardunio_image/headers.dart';

class SelectDeviceController extends GetxController {
  RxList<DeviceWithAvailability> devices = <DeviceWithAvailability>[].obs;
  final toUpdate = false.obs;
  final isDiscovering = false.obs;
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;

  Rx<BluetoothDevice> selectedDevice =
      const BluetoothDevice(address: 'asdsadas').obs;

  @override
  void onInit() {
    super.onInit();

    isDiscovering.value = true;

    startDiscovery();

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      devices.value = bondedDevices
          .map((device) =>
              DeviceWithAvailability(device, DeviceAvailability.maybe, 1))
          .toList();
      doUpdate();
      update();
    });
  }

  doUpdate() {
    print('update Called');
    toUpdate.value = !toUpdate.value;
  }

  void startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      print('Dsicovery Result  $r');
      for (var d in devices) {
        if (d.device == r.device) {
          d.availability = DeviceAvailability.yes;
          d.rssi = r.rssi;
        }
      }
      doUpdate();

      update();
    });

    _discoveryStreamSubscription!.onDone(() {
      isDiscovering.value = false;
      doUpdate();
      update();
    });
  }

  void restartDiscovery() {
    isDiscovering.value = true;
    startDiscovery();
    doUpdate();
    update();
  }

  @override
  void onClose() {
    _discoveryStreamSubscription?.cancel();
    super.onClose();
  }
}

class DeviceWithAvailability {
  BluetoothDevice device;
  DeviceAvailability availability;
  int rssi;

  DeviceWithAvailability(this.device, this.availability, this.rssi);
}

enum DeviceAvailability {
  no,
  maybe,
  yes,
}
