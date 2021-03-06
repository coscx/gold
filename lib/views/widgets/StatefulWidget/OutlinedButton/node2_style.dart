import 'package:flutter/material.dart';

/// create by GUGU Team on 2020/9/21
/// contact me by email 1981462002@qq.com
/// 说明:
//    {
//      "widgetId": 355,
//      "name": 'OutlinedButton样式',
//      "priority": 2,
//      "subtitle":
//          "【style】 : 按钮样式   【ButtonStyle】\n"
//          "【focusNode】 : 焦点   【FocusNode】\n"
//          "【clipBehavior】 : 裁剪行为   【Clip】\n"
//          "【autofocus】 : 自动聚焦   【bool】",
//    }

class OutlinedButtonStyleDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        spacing: 10,
        children: [
          OutlinedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                primary: Colors.white,
                elevation: 2,
                shadowColor: Colors.orangeAccent),
            child: Text('ElevatedButton样式'),
            onPressed: _onPressed,
            onLongPress: _onLongPress,
          ),
          OutlinedButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                primary: Colors.black,
                side: BorderSide(color: Colors.blue,width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                // elevation: 2,
                shadowColor: Colors.orangeAccent),
            child: Text('ElevatedButton边线'),
            autofocus: false,
            onPressed: _onPressed,
            onLongPress: _onLongPress,
          ),
        ],
      ),
    );
  }

  _onPressed() {}

  _onLongPress() {}
}
