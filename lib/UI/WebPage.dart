import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebPage extends StatefulWidget {
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url:"http://jurusanit.epizy.com/", //for http add AndroidManifest.xml <Application after @mipmap android:usesCleartextTraffic="true"
      withJavascript: true,
      withZoom: false,
      hidden: true,
      appBar: AppBar(
        elevation: 1,
        actions: <Widget>[
          InkWell(
            child: Icon(
              Icons.arrow_back,
              size: 30.0,
            ),
            onTap: () {
              flutterWebviewPlugin.goBack();
            },
          ),
          Spacer(),
          InkWell(
              child: Icon(
                Icons.refresh,
                size: 30.0,
              ),
              onTap: () {
                flutterWebviewPlugin.reload();
                // flutterWebviewPlugin.reloadUrl("any link");
              }),
          Spacer(),
          InkWell(
            child: Icon(
              Icons.arrow_forward,
              size: 30.0,
            ),
            onTap: () {
              flutterWebviewPlugin.goForward();
            },
          ),
        ],
      ),
    );
  }
}
