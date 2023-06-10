import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/home/view/bluetooth_enable.dart';
import 'package:ardunio_image/modules/home/view/home_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ardunio Remote',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white70,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => HomeTile(
                  image: IconPath.bluetooth,
                  text: 'Please enable Bluetooth\n to connect with device',
                  widget: Switch(
                    value: hc.bluetoothState.value.isEnabled,
                    onChanged: (c) => hc.enableBluetooth(),
                  ),
                  label: '',
                  color: Colors.white,
                ),
              ),
              const Divider(),
              Obx(
                () => hc.bluetoothState.value.isEnabled != true
                    ? const BluetoothDisable()
                    : const BluetoothEnable(),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
