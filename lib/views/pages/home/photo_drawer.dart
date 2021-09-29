import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/app/router.dart';
import 'package:flutter_unit/app/res/toly_icon.dart';
import 'package:flutter_unit/blocs/bloc_exp.dart';
import 'package:flutter_unit/blocs/point/point_bloc.dart';
import 'package:flutter_unit/blocs/point/point_event.dart';

import 'package:flutter_unit/views/common/unit_drawer_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
/// 说明:

class PhotoDrawer extends StatelessWidget {

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
            Container(
              child: CachedNetworkImage(imageUrl: "https://gugu-1300042725.cos.ap-shanghai.myqcloud.com/612653_WnwL7GT",
                width: 500,
                height: 1300,
              ),
            )

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
