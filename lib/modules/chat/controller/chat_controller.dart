import 'package:ardunio_image/headers.dart';

class ChatController extends GetxController {
  static const clientID = 0;
  BluetoothDevice? connectedDevice;
  BluetoothConnection? connection;
  RxBool isConnecting = true.obs;
  bool get isConnected => connection != null && connection!.isConnected;
  RxBool updateValue = false.obs;
  RxBool isDisconnecting = false.obs;

  final messages = <Message>[].obs;
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  RxBool isTyping = false.obs;
  final ScrollController listScrollController = ScrollController();

  doUpdate() {
    updateValue.value = !updateValue.value;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  void disconnect() {
    if (isConnected) {
      isDisconnecting.value = true;
      connection!.dispose();
      connection = null;
    }
  }

  void connectDevice() {
    final hc = Get.find<HomeController>();
    final cc = Get.find<ChatController>();
    if (hc.conBDevice == null) {
      Get.snackbar('Error', 'Try Again');
      Get.back();
    }

    cc.connectedDevice = hc.conBDevice;
    BluetoothConnection.toAddress(hc.conBDevice!.address).then((con) {
      cc.connection = con;

      // setState(() {
      cc.isConnecting.value = false;
      cc.isDisconnecting.value = false;
      // });
      doUpdate();

      cc.connection!.input!.listen(cc.onDataReceived).onDone(() {
        if (isDisconnecting.value) {
          Get.snackbar('Disconnecting', 'Disconnecting locally!');
          Get.back();
        } else {
          Get.snackbar('Disconnecting', 'Disconnected remotely!');
          Get.back();
        }
        // if (mounted) {
        //   setState(() {});
        // }
      });
    }).catchError((error) {
      Get.snackbar('exception occured', 'Cannot connect, exception occured');
      Get.back();
    });
  }

  void sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text == '3') {
      startUpload();
      return;
    }

    if (text.isNotEmpty) {
      try {
        List<int> messageBytes = [];
        pic1.forEach((element) {
          messageBytes
              .add((element >> 16) & 0xFF); // Most significant byte (MSB)
          messageBytes.add((element >> 8) & 0xFF); // Middle byte
          messageBytes.add(element & 0xFF); // Least significant byte (LSB)
        });

        messageBytes.insert(0, 16); // width
        messageBytes.insert(0, 16); // length
        messageBytes.insert(0, 1); // images

        messageBytes.add(10);

        int chunkSize = 60;
        int totalChunks = (messageBytes.length / chunkSize).ceil();

        for (int i = 0; i < totalChunks; i++) {
          int start = i * chunkSize;
          int end = (i + 1) * chunkSize;
          end = end > messageBytes.length ? messageBytes.length : end;

          List<int> chunk = messageBytes.sublist(start, end);
          connection!.output.add(Uint8List.fromList(chunk));
          await connection!.output.allSent;
          await Future.delayed(Duration(milliseconds: 200));
          print('Chunk $start - $end');
        }

        // TODO: setState
        // setState(() {
        messages.add(Message(clientID, pic2.toString()));
        // });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
            listScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 333),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        // Ignore error, but notify state
        doUpdate();
      }
    }
  }

  void startUpload() {
    sendCustomMessage("U");
  }

  void sendCustomMessage(String text) async {
    textEditingController.clear();
    connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
    await connection!.output.allSent;

    // TODO set state
    // setState(() {
    messages.add(Message(clientID, pic2.toString()));
    // });

    Future.delayed(const Duration(milliseconds: 333)).then((_) {
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 333),
        curve: Curves.easeOut,
      );
    });
  }

  void onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }

    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

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

    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      messages.add(
        Message(
          1,
          backspacesCounter > 0
              ? _messageBuffer.substring(
                  0, _messageBuffer.length - backspacesCounter)
              : _messageBuffer + dataString.substring(0, index),
        ),
      );
      _messageBuffer = dataString.substring(index);
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }

    doUpdate();
  }

  clearChat() {
    messages.clear();
  }
}

List<int> pic2 = [0xb8b6aa, 0xb8b6aa];

List<int> pic1 = [
  0xb8b6aa,
  0x59574b,
  0x0b0f00,
  0x5a5e46,
  0x547562,
  0x294a37,
  0x241414,
  0x4d3d3d,
  0x000403,
  0x4d5756,
  0x201f1a,
  0x8e8d88,
  0xffeee8,
  0x55423c,
  0xaaa7b0,
  0x78757e,
  0x605e52,
  0x100e02,
  0x81856d,
  0x161a02,
  0x4b6c59,
  0x032411,
  0x534343,
  0x695959,
  0x030d0c,
  0x182221,
  0x161510,
  0xd2d1cc,
  0xcebbb5,
  0xf5e2dc,
  0x010007,
  0xc2bfc8,
  0x6e5e69,
  0x1b0b16,
  0xab7e81,
  0xdaadb0,
  0xb4b0a7,
  0x48443b,
  0x6a2738,
  0xce8b9c,
  0x7f5c62,
  0x6a474d,
  0x372e4b,
  0x948ba8,
  0x7b5d39,
  0x987a56,
  0xcdb9c4,
  0xbca8b3,
  0x7a6a75,
  0x8a7a85,
  0x825558,
  0x3a0d10,
  0xbbb7ae,
  0xa7a39a,
  0x935061,
  0xc07d8e,
  0x512e34,
  0x3b181e,
  0x564d6a,
  0xa39ab7,
  0xd3b591,
  0xc4a682,
  0xdbc7d2,
  0x634f5a,
  0x36485e,
  0x4f6177,
  0x50657a,
  0x475c71,
  0xffd5e8,
  0x7c495c,
  0x1e0c02,
  0x1a0800,
  0x3a356f,
  0x2a255f,
  0x4b2123,
  0x441a1c,
  0x341f28,
  0x432e37,
  0xc54a69,
  0xae3352,
  0x5b6d83,
  0x44566c,
  0x60758a,
  0x40556a,
  0x6c394c,
  0x270007,
  0x29170d,
  0xfeece2,
  0xd7d2ff,
  0x231e58,
  0x885e60,
  0x4d2325,
  0x503b44,
  0x18030c,
  0x8f1433,
  0xa72c4b,
  0x324853,
  0x000c17,
  0x462b34,
  0xd2b7c0,
  0x535852,
  0xe5eae4,
  0xbdbab3,
  0xf2efe8,
  0x240d17,
  0xb39ca6,
  0xfbeef5,
  0x22151c,
  0x261100,
  0xd1bc9d,
  0x0b0200,
  0x120900,
  0x778d98,
  0x304651,
  0xf4d9e2,
  0xffe9f2,
  0xacb1ab,
  0xdce1db,
  0xfffff8,
  0xdddad3,
  0xffe9f3,
  0xdbc4ce,
  0xc4b7be,
  0x30232a,
  0x978263,
  0xdfcaab,
  0xe6ddd4,
  0x1d140b,
  0x4e7475,
  0x305657,
  0xa88a7e,
  0x94766a,
  0x61636f,
  0x595b67,
  0x4e5b6d,
  0x475466,
  0x8e7356,
  0x240900,
  0x785b7b,
  0x3c1f3f,
  0x935945,
  0x8c523e,
  0x6f6d7b,
  0x1d1b29,
  0x001a1b,
  0x00191a,
  0xeccec2,
  0xdfc1b5,
  0x121420,
  0x767884,
  0xc6d3e5,
  0x7e8b9d,
  0x694e31,
  0x6d5235,
  0x694c6c,
  0x4b2e4e,
  0x965c48,
  0x370000,
  0x7f7d8b,
  0x1e1c2a,
  0x532041,
  0x431031,
  0xee8da8,
  0xffa6c1,
  0x00031b,
  0xb4c6de,
  0xc996c1,
  0xdba8d3,
  0x251329,
  0xcbb9cf,
  0x8a0216,
  0xd54d61,
  0x732767,
  0xaa5e9e,
  0x97809c,
  0x917a96,
  0x280016,
  0x30001e,
  0x93324d,
  0xa84762,
  0xb3c5dd,
  0x1f3149,
  0x693661,
  0xc08db8,
  0x36243a,
  0x453349,
  0xd95165,
  0xc63e52,
  0x9c5090,
  0xae62a2,
  0xfbe4ff,
  0x5b4460,
  0x353130,
  0xa6a2a1,
  0x090500,
  0x716d54,
  0x160309,
  0x635056,
  0x13080c,
  0x2d2226,
  0xbdafac,
  0x190b08,
  0x542d1e,
  0xb89182,
  0x8b7a84,
  0x33222c,
  0x00140e,
  0x00150f,
  0xdbd7d6,
  0x787473,
  0x353118,
  0x928e75,
  0x49363c,
  0x9e8b91,
  0xaca1a5,
  0xddd2d6,
  0x251714,
  0x382a27,
  0x714a3b,
  0xe1baab,
  0x4d3c46,
  0x36252f,
  0xb6cdc7,
  0x09201a,
  0xa69c9d,
  0xc5bbbc,
  0x6a6b4b,
  0x7d7e5e,
  0x8a8b7b,
  0x979888,
  0xb3a09c,
  0xfae7e3,
  0xc4bda3,
  0x4e472d,
  0x2f2d30,
  0x858386,
  0xf7d9bf,
  0xffe3c9,
  0xd1cbcb,
  0x1c1616,
  0x221819,
  0x988e8f,
  0xd3d4b4,
  0x888969,
  0x272818,
  0x2c2d1d,
  0x382521,
  0x33201c,
  0x2a2309,
  0x3b341a,
  0x262427,
  0x2e2c2f,
  0xcdaf95,
  0xc1a389,
  0x211b1b,
  0x171111,
];
