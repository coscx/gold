import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:flutter_unit/app/res/cons.dart';
import 'package:flutter_unit/app/res/style/shape/coupon_shape_border.dart';
import 'package:flutter_unit/blocs/collect/collect_bloc.dart';
import 'package:flutter_unit/blocs/collect/collect_state.dart';
import 'package:flutter_unit/blocs/detail/detail_bloc.dart';
import 'package:flutter_unit/blocs/detail/detail_event.dart';
import 'package:flutter_unit/blocs/home/home_bloc.dart';
import 'package:flutter_unit/blocs/home/home_event.dart';
import 'package:flutter_unit/components/permanent/circle_image.dart';
import 'package:flutter_unit/components/permanent/circle_text.dart';
import 'package:flutter_unit/components/permanent/feedback_widget.dart';
import 'package:flutter_unit/components/permanent/tag.dart';
import 'package:flutter_unit/model/widget_model.dart';
import 'package:flutter_unit/app/router.dart';
import 'package:flutter_unit/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_unit/views/pages/home/PreviewImagesWidget.dart';
class PhotoWidgetListItem extends StatelessWidget {
  final WidgetModel data;
  final bool hasTopHole;
  final bool hasBottomHole;
  final bool isClip;
  final Map<String,dynamic>  photo;
  PhotoWidgetListItem(
      {this.data,
      this.hasTopHole = true,
      this.hasBottomHole = false,
      this.isClip = true,
      this.photo,
      });

  final List<int> colors = Cons.tabColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Stack(
        children: <Widget>[
          isClip
              ? ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: CouponShapeBorder(
                          hasTopHole: hasTopHole,
                          hasBottomHole: hasBottomHole,
                          hasLine: false,
                          edgeRadius: 25,
                          lineRate: 0.20)),
                  child: buildContent( context),
                )
              : Column(
            children: [
              FeedbackWidget(
                onPressed: () {
                  BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(data,photo));
                  Navigator.pushNamed(context, UnitRouter.widget_detail, arguments: data);
                },
                child:  buildContent( context),
              ),

              buildMiddle(context),
            //_buildCollectTag(Theme.of(context).primaryColor)
        ],
      ),
    ]
      )
    );
  }
Widget buildCard (BuildContext context,Map<String,dynamic> img){
    return     Stack(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[

                Column(
                  children:<Widget> [
                    FeedbackWidget(
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (c, a, s) => PreviewImagesWidget([img['imagepath']],initialPage: 1,)));

                      },
                      child: Container(
                      child: CachedNetworkImage(imageUrl: img['imagepath'],
                      width: 80,
                      height: 150,
                      ),
                      ),

                    )
                    ,

                  ],

                ),

              ],

            ),
            padding: const EdgeInsets.all(2),
            decoration:const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),

          Positioned(
              top: 5,
              right: 5,
              child:
              FeedbackWidget(
                onPressed: () {
                  _deletePhoto(context,img);
                },
                child: const Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red,
                ),
              )
          ),
        ]
    );

}

  Widget buildMiddle (BuildContext context,){
    List<dynamic> imgList =photo['imageurl'];
    List<Widget> list = [];
    imgList.map((images) => {

      list.add( buildCard(context,images))

    }


    ).toList();
    return          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Expanded(child:
          Wrap(
          spacing: 5, //主轴上子控件的间距
            runSpacing: 0, //交叉轴上子控件之间的间距
            children: [
              ...list


            ],

          )
        ),

        Column(
          children: [

            buildRefuseButton(context,"拒绝",Colors.red),
            build100Button(context,"通过1",Colors.green),
            build80Button(context,"通过2",Colors.blue),
            build60Button(context,"通过3",Colors.purple),
            buildHideButton(context,"隐藏",Colors.deepPurple),

          ],
        )

        ]
    );
  }
  _deletePhoto(BuildContext context,Map<String,dynamic> img) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '删除图片',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventDelImg(img,1));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _refuseUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '拒绝此用户',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,1));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _hideUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '隐藏该用户',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,5));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  Widget buildButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){

          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
      );
}
  Widget build100Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,2));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget build80Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,3));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget build60Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,4));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildRefuseButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            _refuseUser(context);
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }

  Widget buildHideButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            _hideUser(context);
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildContent(BuildContext context) => Container(
        color: Color(colors[data.family.index]).withAlpha(66),
        height: 95,
        padding: const EdgeInsets.only(top: 10, left: 0, right: 10, bottom: 5),
        child: Row(
          children: <Widget>[
            buildLeading(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitle(),

                  _buildSummary(),

                ],
              ),
            ),
          ],
        ),
      );

  Widget buildLeading() => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Hero(
          tag: "hero_widget_image_${photo['memberId'].toString()}",
          child: photo['img'] == null
              ? Material(
                  color: Colors.transparent,
                  child: CircleText(
                    text: photo['userName'],
                    size: 60,
                    color: invColor,
                  ),
                )
              : Container(
            child: CachedNetworkImage(imageUrl: photo['img'],
              width: 82.0,
              height: 100.0,
            ),
          )
          ,
        ),
      );

  Color get invColor {
    return Color(colors[data.family.index]);
  }

  Widget _buildCollectTag(Color color) {
    return Positioned(
        top: 0,
        right: 40,
        child: BlocBuilder<CollectBloc, CollectState>(builder: (_, s) {
          bool show = s.widgets.contains(data);
          return Opacity(
            opacity: show ? 1.0 : 0.0,
            child: SizedOverflowBox(
              alignment: Alignment.bottomCenter,
              size: const Size(0, 20 - 6.0),
              child: Tag(
                color: color,
                shadowHeight: 6.0,
                size: const Size(15, 20),
              ),
            ),
          );
        }));
  }

  Widget _buildTitle() {
    return Expanded(
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Expanded(
            child: Text(photo['userName'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.white, offset: Offset(.3, .3))
                    ])),
          ),
          StarScore(
            star: Star(emptyColor: Colors.white, size: 15, fillColor: invColor),
            score: data.lever,
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 5),
      child: Container(
        child: Text(
          //尾部摘要
          photo['intro']== ''?'什么也没有':photo['intro'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600], fontSize: 14, shadows: [
            const Shadow(color: Colors.white, offset: const Offset(.5, .5))
          ]),
        ),
      ),
    );
  }
}
