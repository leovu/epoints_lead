

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomFileView extends StatefulWidget {

  final String url;
  final String title;

  CustomFileView(this.url, this.title);

  @override
  CustomFileViewState createState() => CustomFileViewState();
}

class CustomFileViewState extends State<CustomFileView> {

  WebViewController _controller;

  bool _isStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {

      },
      onWebResourceError: (WebResourceError error) {},
    ),
  )
  ..loadRequest(Uri.parse(Platform.isAndroid?"https://docs.google.com/viewer?embedded=true&url=${widget.url}":widget.url));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      body: ["jpeg", "jpg", "png"].contains(widget.url.split(".").last)?CustomNetworkImage(
        width: double.infinity,
        height: double.infinity,
        url: widget.url,
        fit: BoxFit.contain,
      ):WebViewWidget(controller: _controller),
    );
  }
}
