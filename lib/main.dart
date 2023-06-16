import 'package:ardunio_image/headers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp(home: MainPage());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ardunio Image',
      initialRoute: AppPages.initial,
      initialBinding: HomeBinding(),
      getPages: AppPages.routes(),
    );
  }
}
