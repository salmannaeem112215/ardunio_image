import 'package:ardunio_image/headers.dart';
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
          child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => SwitchListTile(
                title: const Text('Enable Bluetooth'),
                value: hc.bluetoothState.value.isEnabled,
                onChanged: (bool value) async {
                  hc.enableBluetooth();
                },
              ),
            ),
            const Divider(),
            Obx(
              () => hc.bluetoothState.value.isEnabled != true
                  ? const BluetoothDisable()
                  : const Text('Good To Go'),
            ),
          ],
        ),
      )),
    );
  }
}
