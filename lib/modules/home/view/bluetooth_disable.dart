import 'package:ardunio_image/headers.dart';

class BluetoothDisable extends StatelessWidget {
  const BluetoothDisable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          IconPath.bluetoothError,
          height: 300,
        ),
        const Text(
          'Opps!\nBluetooth not enabled',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 30,
          ),
        )
      ],
    );
  }
}
