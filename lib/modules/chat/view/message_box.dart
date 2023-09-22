import 'package:ardunio_image/headers.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();
    return Row(
      children: [
        const SizedBox(width: 16),
        Flexible(child: Obx(() {
          cc.updateValue.value;
          return TextField(
            controller: cc.textEditingController,
            onChanged: (s) {
              if (s.trim().isEmpty) {
                cc.isTyping.value = false;
              } else {
                cc.isTyping.value = true;
              }
            },
            decoration: InputDecoration(
              hintText: cc.isConnecting.value
                  ? 'Wait until connected...'
                  : cc.isConnected
                      ? 'Type your message...'
                      : 'Chat got disconnected',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black45),
              ),
            ),
            enabled: cc.isConnected,
          );
        })),
        Obx(() {
          cc.updateValue.value;
          if (cc.isTyping.value) {
            return Transform.rotate(
              angle: -3.142 / 8,
              child: Tooltip(
                message: 'SEND MESSAGE',
                child: IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.send),
                    onPressed: cc.isConnected
                        ? () => cc.sendMessage(cc.textEditingController.text)
                        : null),
              ),
            );
          } else {
            return Tooltip(
              message: 'Upload Image',
              child: IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.image),
                  onPressed: cc.isConnected
                      ? () => Get.toNamed(AppPages.image)
                      : () => Get.toNamed(AppPages.image)
                  // :null
                  ),
            );
          }
        }),
      ],
    );
  }
}
