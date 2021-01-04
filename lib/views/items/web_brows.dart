import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPageUI extends StatefulWidget {
  //标题
  String title;
  //链接
  String url;

  WebViewPageUI({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewPageUIState();
  }
}

class WebViewPageUIState extends State<WebViewPageUI> {
  bool isLoad = true;

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      debugPrint('state:_' + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: WebviewScaffold(
      url: widget.url,
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: new Text(widget.title,
           style: TextStyle(color: Colors.black)
        ),
        bottom: new PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: isLoad
                ?  LinearProgressIndicator()
                :  Divider(
              height: 1.0,
              color: Colors.white,
            )),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    ));
  }
}