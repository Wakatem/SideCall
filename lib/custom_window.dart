import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class CustomWindowTop extends StatelessWidget {
  const CustomWindowTop({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
      color: const Color.fromRGBO(16, 24, 38, 1),
      width: 0,
      child: WindowTitleBarBox(
        child: Row(
          children: [Expanded(child: MoveWindow()), const WindowButtons()],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Colors.white70,
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: Colors.white70,
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}

void setupWindow() {
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1000, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.maxSize = initialSize;
    win.alignment = Alignment.center;
    win.show();
  });
}
