import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trustdine_kds/screens/Auth/login.dart';
import 'package:trustdine_kds/screens/homescreen/homescreen.dart';
import 'package:trustdine_kds/storage/cache.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await SecureStorageManager.getToken();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null ? MyApp() : LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
