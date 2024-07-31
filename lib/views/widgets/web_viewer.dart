import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:believer/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewer extends StatefulWidget {
  const WebViewer({super.key, required this.url});

  final String url;

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewController controller;

  bool loading = true;
  Timer? time;

  @override
  void dispose() {
    if (time != null) {
      time!.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              loading = false;
            });
          },
          onUrlChange: (UrlChange change) async {
            // print('object2' + change.url.toString());
            if (change.url!
                .startsWith('https://ipg.comtrust.ae/e/nvoice/Receipt?n=')) {
              time = Timer.periodic(const Duration(seconds: 1), (timer) {
                Future future = controller
                    .runJavaScriptReturningResult("document.body.innerText");
                future.then((data) {
                  String text = Platform.isIOS
                      ? data.toString()
                      : jsonDecode(data).toString();
                  if (text.contains('Invoice ID')) {
                    Get.find<UserController>()
                        .changeDone(text.contains('Successful'));

                    Navigator.pop(context);
                  }
                });
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
