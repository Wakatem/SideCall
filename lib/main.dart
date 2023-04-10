import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
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
      home: const Homepage(),
    );
  }
}

void setupWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 600),
    center: true,
    windowButtonVisibility: true,
    titleBarStyle: TitleBarStyle.normal,
    maximumSize: Size(1000, 600),
    minimumSize: Size(1000, 600),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupWindow();
  runApp(const MyApp());
}
