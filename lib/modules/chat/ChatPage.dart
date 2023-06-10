import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/chat/controller/chat_controller.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = <_Message>[];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    final hc = Get.find<HomeController>();
    if (hc.conBDevice == null) {
      Get.snackbar('Error', 'Try Again');
      Get.back();
    }

    Get.find<ChatController>().connectedDevice = hc.conBDevice;
    BluetoothConnection.toAddress(hc.conBDevice!.address).then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        print('HIIIIIIIIIAMI');
        if (isDisconnecting) {
          Get.snackbar('Disconnecting', 'Disconnecting locally!');
          Get.back();
        } else {
          Get.snackbar('Disconnecting', 'Disconnected remotely!');
          Get.back();
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      Get.snackbar('exception occured', 'Cannot connect, exception occured');
      Get.back();
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<ChatController>();

    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ${cc.connectedDevice!.name}...')
              : isConnected
                  ? Text('Live chat with ${cc.connectedDevice!.name}')
                  : Text('Chat log with ${cc.connectedDevice!.name}'))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
