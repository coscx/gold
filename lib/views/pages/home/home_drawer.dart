import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/app/router.dart';
import 'package:flutter_unit/app/res/toly_icon.dart';
import 'package:flutter_unit/blocs/bloc_exp.dart';
import 'package:flutter_unit/blocs/point/point_bloc.dart';
import 'package:flutter_unit/blocs/point/point_event.dart';

import 'package:flutter_unit/views/common/unit_drawer_header.dart';

/// 说明:

class HomeDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {

    final Color color = BlocProvider.of<HomeBloc>(context).activeHomeColor;

    return Container(
        color: color.withAlpha(33),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UnitDrawerHeader(color: color),
            _buildItem(context, TolyIcon.icon_them, '应用设置', UnitRouter.setting),
            _buildItem(context, TolyIcon.icon_layout, '数据统计', null),
            Divider(height: 1),

            _buildItem(context, TolyIcon.icon_code, 'Dart 手册', null),
            Divider(height: 1),
            _buildItem(context, Icons.info, '关于应用', UnitRouter.about_app),
            _buildItem(context, TolyIcon.icon_kafei, '联系我们', UnitRouter.about_me),
          ],
        ),
      );
  }


  Widget _buildItem(
          BuildContext context, IconData icon, String title, String linkTo,{VoidCallback onTap}) =>
      ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        trailing:
            Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
        onTap: () {
          if (linkTo != null && linkTo.isNotEmpty) {
            Navigator.of(context).pushNamed(linkTo);
            if(onTap!=null) onTap();
          }
        },
      );
}
