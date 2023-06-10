// import 'package:ardunio_image/headers.dart';

// class SelectDeviceScreen extends StatelessWidget {
//   const SelectDeviceScreen({super.key});
//   final bool checkAvailability = false;

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<SelectDeviceController>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select device'),
//         actions: <Widget>[
//           Obx(
//             () => controller.isDiscovering.value
//                 ? FittedBox(
//                     child: Container(
//                       margin: const EdgeInsets.all(16.0),
//                       child: const CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     ),
//                   )
//                 : IconButton(
//                     icon: const Icon(Icons.replay),
//                     onPressed: controller.restartDiscovery,
//                   ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         controller.devices.value;
//         controller.toUpdate.value;
//         print('Rebuild');
//         return ListView.builder(
//           itemBuilder: (_, index) => SelectDeviceListTile(
//             deviceWA: controller.devices[index],
//             key: Key(
//               '${controller.devices[index].rssi} ${controller.devices[index].availability == DeviceAvailability.yes}',
//             ),
//           ),
//           itemCount: controller.devices.length,
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.qr_code_scanner_rounded),
//         onPressed: () {
//           Get.toNamed(AppPages.scan);
//         },
//       ),
//     );
//   }
// }
