

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class CustomFileView extends StatefulWidget {

  final String url;
  final String title;

  CustomFileView(this.url, this.title);

  @override
  CustomFileViewState createState() => CustomFileViewState();
}

class CustomFileViewState extends State<CustomFileView> {

  WebViewPlusController _controller;

  bool _isStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: widget.title,
      body: ["jpeg", "jpg", "png"].contains(widget.url.split(".").last)?CustomNetworkImage(
        width: double.infinity,
        height: double.infinity,
        url: widget.url,
        fit: BoxFit.contain,
      ):WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: Platform.isAndroid?"https://docs.google.com/viewer?embedded=true&url=${widget.url}":widget.url,
        onWebViewCreated: (controller){
          _controller = controller;
        },
        onPageFinished: (url){
          if(!_isStarted){
            Future.delayed(Duration(milliseconds: 500)).then((value) => _controller.webViewController.reload());
          }
        },
        onPageStarted: (url){
          _isStarted = true;
        },
      ),
    );
  }
}

class CustomHtmlView extends StatelessWidget {

  final String html;

  const CustomHtmlView(this.html, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(html == null){
      return Container();
    }
    return WebViewPlus(
      initialUrl: "about:blank",
      onWebViewCreated: (controller){
        controller.loadUrl(Uri.dataFromString(
            html,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8')
        ).toString());
      },
    );
  }
}
