import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:webview_windows/webview_windows.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class CallPage extends StatefulWidget {
  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  String script =
      "document.getElementById('room').value='Ceep'; document.getElementByClassName('group mt-4 flex w-full items-center justify-center rounded-md bg-rose-600 px-5 py-3 text-white transition focus:outline-none focus:ring focus:ring-yellow-400 sm:mt-0 sm:w-auto').click(); ";
  final controller = WebviewController();
  var displayPage = false;

  Future<void> initializePage() async {
    await controller.initialize();
    await controller.setBackgroundColor(Colors.transparent);
    await controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await controller.loadUrl('https://www.free4.chat/');

    if (controller.value.isInitialized) {
      await controller.executeScript(script);
      //await controller.reload();
      setState(() {
        displayPage = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializePage();
  }

  @override
  Widget build(BuildContext context) {
    return displayPage ? Webview(controller) : Container();
  }
}

Future<WebviewPermissionDecision> _onPermissionRequested(
    String url, WebviewPermissionKind kind, bool isUserInitiated) async {
  final decision = await showDialog<WebviewPermissionDecision>(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('WebView permission requested'),
      content: Text('WebView has requested permission \'$kind\''),
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              Navigator.pop(context, WebviewPermissionDecision.deny),
          child: const Text('Deny'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, WebviewPermissionDecision.allow),
          child: const Text('Allow'),
        ),
      ],
    ),
  );

  return decision ?? WebviewPermissionDecision.none;
}
