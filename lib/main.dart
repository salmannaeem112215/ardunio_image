import 'package:ardunio_image/headers.dart';
import 'package:ardunio_image/modules/qr_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp(home: MainPage());
    return GetMaterialApp(home: QrScreen());
  }
}
