import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/home/view/home_tile.dart';

class BluetoothEnable extends StatelessWidget {
  const BluetoothEnable({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = Get.find<HomeController>();
    return Column(
      children: [
        HomeTile(
          image: IconPath.warning,
          text: 'For new device... \nConnect from here first.',
          onTap: hc.openBluetoothSettings,
          color: const Color(0xFFDD636E),
          label: 'Bluetooth Settings',
        ),
        const Divider(),
        HomeTile(
          image: IconPath.scan,
          text: 'Scan Qr Code to .. \nConnect with device.     ',
          onTap: () async {
            final qrData = await Get.find<QrController>().scanQr();
            if (qrData == null) {
              Get.snackbar('Scanning Cancel', 'Qr Scanning Mode Cancel');
            } else {
              //get Bluetooth Devices and connect it
              final devices = await hc.scanDevice();
              BluetoothDevice? deviceToConnect;
              for (var element in devices) {
                if (element.address == qrData.address) {
                  deviceToConnect = element;
                }
              }
              if (deviceToConnect == null) {
                Get.snackbar(
                  'Error Device Pairing',
                  'Device is not paired with your phone. please go to Bluetooth Setting to pair device',
                );
              } else {
                print('hi');
              }
            }
          },
          color: const Color(0xff285680),
          label: 'Scan Now',
          iconWidth: 130,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
