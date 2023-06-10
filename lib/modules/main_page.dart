// import 'package:ardunio_image/headers.dart';

// class MainPage extends StatelessWidget {
//   final BluetoothController _bluetoothController =
//       Get.put(BluetoothController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Bluetooth Serial'),
//         ),
//         body: Obx(() => ListView(
//               children: <Widget>[
//                 const Divider(),
//                 const ListTile(title: Text('General')),
//                 SwitchListTile(
//                   title: const Text('Enable Bluetooth'),
//                   value: _bluetoothController.bluetoothState.value.isEnabled,
//                   onChanged: (bool value) async {
//                     _bluetoothController.enableBluetooth();
//                   },
//                 ),
//                 ListTile(
//                   title: const Text('Bluetooth status'),
//                   subtitle: Text(
//                       _bluetoothController.bluetoothState.value.toString()),
//                   trailing: ElevatedButton(
//                     child: const Text('Settings'),
//                     onPressed: () {
//                       _bluetoothController.openBluetoothSettings();
//                     },
//                   ),
//                 ),
//                 ListTile(
//                   title: const Text('Local adapter address'),
//                   subtitle: Text(_bluetoothController.address.value),
//                 ),
//                 ListTile(
//                   title: const Text('Local adapter name'),
//                   subtitle: Text(_bluetoothController.name.value),
//                   onLongPress: null,
//                 ),
//                 Divider(),
//                 ListTile(title: const Text('Devices discovery and connection')),
//                 ListTile(
//                   title: ElevatedButton(
//                       child: const Text('Connect to paired device to chat'),
//                       onPressed: () async {
//                         Get.toNamed(AppPages.selectDevice);
//                       }),
//                 ),
//               ],
//             )));
//   }
// }
