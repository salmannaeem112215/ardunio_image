// import 'package:ardunio_image/headers.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cc = Get.find<ChatController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() {
//           cc.isConnecting.value;
//           print(cc.isConnecting.value);
//           final title = cc.isConnecting.value
//               ? 'Connecting chat to ${cc.connectedDevice!.name}...'
//               : (cc.connection.value != null &&
//                       cc.connection.value!.isConnected)
//                   ? 'Live chat with ${cc.connectedDevice!.name}'
//                   : 'Chat log with ${cc.connectedDevice!.name}';
//           return Text(
//             title,
//             style: const TextStyle(color: Colors.black),
//           );
//         }),
//         elevation: 1,
//         backgroundColor: Colors.white70,
//         iconTheme: const IconThemeData(color: Colors.black54),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
            // Flexible(
            //   child: Obx(() {
            //     cc.messages.value;
            //     return ListView.builder(
            //       itemBuilder: (context, index) =>
            //           MessageTile(message: cc.messages[index]),
            //       itemCount: cc.messages.length,
            //       padding: const EdgeInsets.all(12.0),
            //       controller: cc.listScrollController,
            //     );
            //   }),
            // ),
//             Row(
//               children: [
//                 Flexible(
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 16.0),
//                     child: Obx(() {
//                       String hintText = cc.isConnecting.value
//                           ? 'Wait until connected...'
//                           : (cc.connection.value != null &&
//                                   cc.connection.value!.isConnected)
//                               ? 'Type your message...'
//                               : 'Chat got disconnected';
//                       return TextField(
//                         style: const TextStyle(fontSize: 15.0),
//                         controller: cc.textEditingController,
//                         decoration: InputDecoration.collapsed(
//                           hintText: hintText,
//                           hintStyle: const TextStyle(color: Colors.grey),
//                         ),
//                         enabled: cc.isConnected,
//                       );
//                     }),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8.0),
//                   child: IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: cc.isConnected
//                           ? () => cc.sendMessage(cc.textEditingController.text)
//                           : null),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
