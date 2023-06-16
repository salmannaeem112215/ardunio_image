import 'package:ardunio_image/headers.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.whom == ChatController.clientID
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          width: 222.0,
          decoration: BoxDecoration(
              color: message.whom == ChatController.clientID
                  ? Colors.blueAccent
                  : Colors.grey,
              borderRadius: BorderRadius.circular(7.0)),
          child: Text(
              (text) {
                return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
              }(message.text.trim()),
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
