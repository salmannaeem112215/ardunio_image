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
            child: Column(
              children: [
                Obx(
                  () => QrImageView(
                    data: _qrController.qrValue.value,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 16),
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
                ElevatedButton(
                    onPressed: () {
                      _qrController.scanQr();
                    },
                    child: const Text('Scan Devices'))
              ],
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
