import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/chat/view/message_box.dart';
import 'package:ardunio_image/modules/chat/view/message_list.dart';
import 'package:ardunio_image/modules/chat/view/no_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().connectDevice();
  }

  @override
  void dispose() {
    final cc = Get.find<ChatController>();
    cc.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();

    return Scaffold(
      appBar: appbar(cc),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Obx(() {
                if (cc.messages.isEmpty) {
                  return const NoMessage();
                } else {
                  return const MessageList();
                }
              }),
            ),
            const SizedBox(height: 8),
            const MessageBox(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  AppBar appbar(ChatController cc) {
    return AppBar(
      title: Obx(
        () {
          cc.updateValue.value;
          return Text(
            (cc.isConnecting.value
                ? 'Connecting chat to ${cc.connectedDevice!.name}...'
                : cc.isConnected
                    ? 'Live chat with ${cc.connectedDevice!.name}'
                    : 'Chat log with ${cc.connectedDevice!.name}'),
            style: const TextStyle(color: Colors.black),
          );
        },
      ),
      actions: [
        Tooltip(
          message: 'Clear Chat',
          child: IconButton(
            icon: const Icon(Icons.clear_all_rounded),
            onPressed: () {
              cc.clearChat();
            },
          ),
        ),
      ],
      elevation: 1,
      backgroundColor: Colors.white70,
      iconTheme: const IconThemeData(color: Colors.black54),
    );
  }
}
