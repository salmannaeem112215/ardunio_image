// import 'package:ardunio_image/headers.dart';

// class SelectDeviceListTile extends StatelessWidget {
//   const SelectDeviceListTile({
//     super.key,
//     required this.deviceWA,
//   });

//   final DeviceWithAvailability deviceWA;

//   @override
//   Widget build(BuildContext context) {
//     print(deviceWA.availability);
//     return ListTile(
//       onTap: () {
//         print('Connect -> selected ' + deviceWA.device.address);
//         Get.find<SelectDeviceController>().selectedDevice.value =
//             deviceWA.device;

//         Get.toNamed(AppPages.chat);
//       },
//       onLongPress: () {},
//       enabled: deviceWA.availability == DeviceAvailability.maybe,
//       leading: const Icon(Icons.devices),
//       title: Text(deviceWA.device.name ?? "Unknown device"),
//       subtitle: Text(deviceWA.device.address.toString()),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(8.0),
//             child: DefaultTextStyle(
//               style: _computeTextStyle(deviceWA.rssi),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(deviceWA.rssi.toString()),
//                   const Text('dBm'),
//                 ],
//               ),
//             ),
//           ),
//           deviceWA.device.isConnected
//               ? const Icon(Icons.import_export)
//               : const SizedBox.shrink(),
//           deviceWA.device.isBonded
//               ? const Icon(Icons.link)
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }

//   static TextStyle _computeTextStyle(int rssi) {
//     if (rssi >= -35) {
//       return TextStyle(color: Colors.greenAccent[700]);
//     } else if (rssi >= -45) {
//       return TextStyle(
//           color: Color.lerp(
//               Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
//     } else if (rssi >= -55) {
//       return TextStyle(
//           color: Color.lerp(
//               Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
//     } else if (rssi >= -65) {
//       return TextStyle(
//           color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
//     } else if (rssi >= -75) {
//       return TextStyle(
//           color: Color.lerp(
//               Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
//     } else if (rssi >= -85) {
//       return TextStyle(
//           color: Color.lerp(
//               Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
//     } else {
//       return const TextStyle(color: Colors.redAccent);
//     }
//   }
// }
