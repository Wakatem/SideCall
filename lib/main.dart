import 'package:flutter/material.dart';
import 'custom_window.dart';
import 'homepage.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Side Call',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Scaffold(
          backgroundColor: const Color.fromRGBO(16, 24, 38, 1),
          body: Homepage(),
          ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  setupWindow();
}
