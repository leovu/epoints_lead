import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomHtml extends StatelessWidget {

  final String html;
  final ScrollPhysics physics;

  CustomHtml(this.html, {this.physics});

  @override
  Widget build(BuildContext context) {
    return html == null?Container():SingleChildScrollView(
        physics: physics??AlwaysScrollableScrollPhysics(),
        child: Html(
          data: html,
          onLinkTap: (url, _, attributes, element){
            launch(url);
          },
        )
    );
  }
}