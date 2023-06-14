import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomHtml extends StatelessWidget {

  final String? html;
  final ScrollPhysics? physics;

  CustomHtml(this.html, {this.physics});

  @override
  Widget build(BuildContext context) {
    return html == null?Container():SingleChildScrollView(
        physics: physics??AlwaysScrollableScrollPhysics(),
        child: HtmlWidget(
          html!,
          onTapUrl: (url) => launch(url),
        )
    );
  }
}