import 'package:ardunio_image/headers.dart';

class BluetoothEnable extends StatelessWidget {
  const BluetoothEnable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          IconPath.bluetoothError,
          height: 400,
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
