import 'package:ardunio_image/headers.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const clientID = 0;
  BluetoothConnection? connection;

  bool isConnecting = true;
  bool get isConnected {
    final cc = Get.find<ChatController>();
    return cc.connection != null && cc.connection!.isConnected;
  }

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().connectDevice();
    // final hc = Get.find<HomeController>();
    // final cc = Get.find<ChatController>();
    // if (hc.conBDevice == null) {
    //   Get.snackbar('Error', 'Try Again');
    //   Get.back();
    // }

    // cc.connectedDevice = hc.conBDevice;
    // BluetoothConnection.toAddress(hc.conBDevice!.address).then((con) {
    //   cc.connection = con;

    //   setState(() {
    //     cc.isConnecting.value = false;
    //     cc.isDisconnecting.value = false;
    //   });

    //   cc.connection!.input!.listen(cc.onDataReceived).onDone(() {
    //     if (isDisconnecting) {
    //       Get.snackbar('Disconnecting', 'Disconnecting locally!');
    //       Get.back();
    //     } else {
    //       Get.snackbar('Disconnecting', 'Disconnected remotely!');
    //       Get.back();
    //     }
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   });
    // }).catchError((error) {
    //   Get.snackbar('exception occured', 'Cannot connect, exception occured');
    //   Get.back();
    // });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    final cc = Get.find<ChatController>();
    cc.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          cc.updateValue.value;
          return Text(
            (cc.isConnecting.value
                ? 'Connecting chat to ${cc.connectedDevice!.name}...'
                : cc.isConnected
                    ? 'Live chat with ${cc.connectedDevice!.name}'
                    : 'Chat log with ${cc.connectedDevice!.name}'),
            style: const TextStyle(color: Colors.black),
          );
        }),
        elevation: 1,
        backgroundColor: Colors.white70,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Obx(() {
                cc.messages.value;
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      MessageTile(message: cc.messages[index]),
                  itemCount: cc.messages.length,
                  padding: const EdgeInsets.all(12.0),
                  controller: cc.listScrollController,
                );
              }),
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Obx(() {
                        cc.updateValue.value;
                        return TextField(
                          controller: cc.textEditingController,
                          style: const TextStyle(fontSize: 15.0),
                          decoration: InputDecoration.collapsed(
                            hintText: cc.isConnecting.value
                                ? 'Wait until connected...'
                                : cc.isConnected
                                    ? 'Type your message...'
                                    : 'Chat got disconnected',
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          enabled: isConnected,
                        );
                      })),
                ),
                Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      cc.updateValue.value;
                      return IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: isConnected
                              ? () =>
                                  cc.sendMessage(cc.textEditingController.text)
                              : null);
                    })),
                Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      cc.updateValue.value;
                      return IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: isConnected
                              ? () =>
                                  cc.sendMessage(cc.textEditingController.text)
                              : null);
                    })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
