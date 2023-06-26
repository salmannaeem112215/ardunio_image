import 'package:ardunio_image/headers.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();

    return Obx(() => ListView.builder(
          itemBuilder: (context, index) =>
              MessageTile(message: cc.messages[index]),
          itemCount: cc.messages.length,
          padding: const EdgeInsets.all(12.0),
          controller: cc.listScrollController,
        ));
  }
}
