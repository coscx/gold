import 'package:flutter/material.dart';

/// create by GUGU Team on 2020-03-29
/// contact me by email 1981462002@qq.com
/// 说明:
//    {
//      "widgetId": 168,
//      "name": '文字样式-ThemeData#TextTheme',
//      "priority": 1,
//      "subtitle":
//          "子组件可以通过ThemeData.of获取主题的数据进行使用。",
//    }
class TextThemeDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var queryData = Theme.of(context).textTheme;
    var styles = {
      "headline: ": queryData.headline1,
      "title: ": queryData.headline6,
      "subhead: ": queryData.subtitle1,
      "subtitle: ": queryData.bodyText2,
      "body2: ": queryData.bodyText1,
      "button: ": queryData.button,
      "overline: ": queryData.overline,
      "subtitle: ": queryData.subtitle2,
      "button: ": queryData.caption,
      "display1: ": queryData.headline4,
      "display2: ": queryData.headline3,
      "display3: ": queryData.headline2,
      "display4: ": queryData.headline1,
    };

    return Container(
      child: Column(
        children: styles.keys.map((e) => buildItem(e, styles[e])).toList(),
      ),
    );
  }

  Widget buildItem(String e, TextStyle style) => Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              e,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "@toly",
              style: style,
            )
          ],
        ),
      ),
      Divider(
        height: 1,
      )
    ],
  );
}