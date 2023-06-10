import 'package:ardunio_image/headers.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QrController _qrController = Get.put(QrController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _qrController.scanQr();
                            },
                            child: const Text('Scan QR Code')),
                        const Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Flexible(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Connection Credentails'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _qrController.name,
                          decoration: kInputDecoration('Name'),
                          onChanged: (val) => _qrController.valueChanges(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _qrController.address,
                          decoration: kInputDecoration('Address'),
                          onChanged: (val) => _qrController.valueChanges(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          // validator: (value) => ,
                          keyboardType: TextInputType.phone,
                          controller: _qrController.pincode,
                          decoration: kInputDecoration('PIN Code'),
                          onChanged: (val) => _qrController.valueChanges(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          final sc = Get.find<SelectDeviceController>();
                          for (var element in sc.devices) {
                            if (element.device.address ==
                                _qrController.address.text) {
                              sc.selectedDevice.value = element.device;
                            }
                          }

                          if (sc.selectedDevice.value.address ==
                              _qrController.address.text) {
                            Get.toNamed(AppPages.chat);
                          } else {
                            Get.snackbar('Paired Device Error',
                                'Device Not Found in Paired. Please Paired Device with given Credentials ');
                            await Future.delayed(const Duration(seconds: 2));
                            Get.find<BluetoothController>()
                                .openBluetoothSettings();
                          }
                        },
                        child: const Text('Connect')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

kInputDecoration(String lable) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelText: lable,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(fontSize: 18),
    );
