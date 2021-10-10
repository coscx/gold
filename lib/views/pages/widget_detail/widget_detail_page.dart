import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:flutter_unit/app/res/cons.dart';
import 'package:flutter_unit/app/res/toly_icon.dart';
import 'package:flutter_unit/app/router.dart';
import 'package:flutter_unit/app/utils/Toast.dart';
import 'package:flutter_unit/blocs/bloc_exp.dart';
import 'package:flutter_unit/components/imageview/image_preview_page.dart';
import 'package:flutter_unit/components/imageview/image_preview_view.dart';
import 'package:flutter_unit/components/permanent/circle.dart';
import 'package:flutter_unit/components/permanent/feedback_widget.dart';
import 'package:flutter_unit/components/permanent/panel.dart';
import 'package:flutter_unit/components/project/widget_node_panel.dart';
import 'package:flutter_unit/components/project/widget_node_panel_user_detail.dart';
import 'package:flutter_unit/model/node_model.dart';
import 'package:flutter_unit/model/widget_model.dart';
import 'package:flutter_unit/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_unit/views/dialogs/change_category_dialog.dart';
import 'package:flutter_unit/views/pages/widget_detail/category_end_drawer.dart';
import 'package:flutter_unit/views/widgets/widgets_map.dart';

class WidgetDetailPage extends StatefulWidget {
  final WidgetModel model;

  WidgetDetailPage({this.model});

  @override
  _WidgetDetailPageState createState() => _WidgetDetailPageState();
}

class _WidgetDetailPageState extends State<WidgetDetailPage> with SingleTickerProviderStateMixin {
  List<WidgetModel> _modelStack = [];
  GifController controllers;
  @override
  void initState() {
    controllers= GifController(vsync: this);
    _modelStack.add(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CategoryEndDrawer(widget: _modelStack.last),
      appBar: AppBar(
        title: Text("用户详情"),
        actions: <Widget>[
          _buildToHome(),
          _buildCollectButton(_modelStack.last, context),
        ],
      ),
      body: Builder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context) => WillPopScope(
      onWillPop: () => _whenPop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<DetailBloc, DetailState>(builder: _buildTitle),

            BlocBuilder<DetailBloc, DetailState>(builder: _buildDetail)
          ],
        ),
      ));

  Widget _buildToHome() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(Icons.home),
          ),
          onTap: () => Navigator.of(ctx).pop()));

  Widget _buildCollectButton(WidgetModel model, BuildContext context) {
    //监听 CollectBloc 伺机弹出toast
    return BlocListener<CollectBloc, CollectState>(
        listener: (ctx, st) {
         // bool collected = st.widgets.contains(model);
         // String msg = collected ? "收藏【${model.name}】组件成功!" : "已取消【${model.name}】组件收藏!";
         // _showToast(ctx, msg, collected);
        },
        child: FeedbackWidget(
          onPressed: () => BlocProvider.of<CollectBloc>(context)
              .add(ToggleCollectEvent(id: model.id)),
          child: BlocBuilder<CollectBloc, CollectState>(
              builder: (_, s) => Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      s.widgets.contains(model)
                          ? TolyIcon.icon_star_ok
                          : TolyIcon.icon_star_add,
                      size: 25,
                    ),
                  )),
        ));
  }

  _showToast(BuildContext ctx, String msg, bool collected) {
    Toast.toast(
      ctx,
      msg,
      duration: Duration(milliseconds: collected ? 1500 : 600),
      action: collected
          ? SnackBarAction(
              textColor: Colors.white,
              label: '收藏夹管理',
              onPressed: () => Scaffold.of(ctx).openEndDrawer())
          : null,
    );
  }

  final List<int> colors = Cons.tabColors;

  Widget _buildNodes(List<NodeModel> nodes, String name) {
    GlobalState globalState = BlocProvider.of<GlobalBloc>(context).state;
    return Column(
        children: nodes
            .asMap()
            .keys
            .map((i) => WidgetNodePanel(
                  codeStyle: Cons.codeThemeSupport.keys
                      .toList()[globalState.codeStyleIndex],
                  codeFamily: 'Inconsolata',
                  text: nodes[i].name,
                  subText: nodes[i].subtitle,
                  code: nodes[i].code,
                  show: WidgetsMap.map(name)[i],
                ))
            .toList());
  }

  Future<bool> _whenPop(BuildContext context) async {
    if (Scaffold.of(context).isEndDrawerOpen) return true;

    _modelStack.removeLast();
    if (_modelStack.length > 0) {
      setState(() {
        Map<String,dynamic> photo;
        BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(_modelStack.last,photo));
      });
      return false;
    } else {
      return true;
    }
  }

  Widget _buildDetail(BuildContext context, DetailState state) {
    print('build---${state.runtimeType}---');
    if (state is DetailWithData) {

     List pair= state.userdetails['pair'];
     List like= state.userdetails['like'];
     List belike= state.userdetails['belike'];
     List ai= state.userdetails['ai'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                  padding:  const EdgeInsets.only(
                    top: 4.0,
                    left: 10.0,
                  ),
                  child:  Text(
                    "修改性别: ",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                GestureDetector(
                onTap: (){
                controllers.value = 0;
                controllers.duration=Duration(milliseconds:400);
                // from current frame to 26 frame
                controllers.animateTo(30);
               _changeSex(context,state.userdetails);
                },
                child: Container(
                width: 60,
                height: 60,
                child: GifImage(

                  controller: controllers,
                  image:   Image.asset(
                    "assets/images/sex.gif",
                  ).image,
                ),
              ))
            ],
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "使用总次数: "+state.userdetails['allindex'].toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "配对率: "+state.userdetails['pairs'].toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),


          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "高危用户: "+(state.userdetails['user']['facescore']== 10?"是":"否"),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "审核状态: "+(state.userdetails['user']['checked']== 1?"未审核":"已审核"),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "注册时间: "+(state.userdetails['user']['addtime']== 0?"":DateTime.fromMillisecondsSinceEpoch(state.userdetails['user']['addtime']*1000).toString()),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),


          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "最后活跃时间: "+(state.userdetails['user']['timesd']== 0?"":DateTime.fromMillisecondsSinceEpoch(state.userdetails['user']['timesd']*1000).toString()),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),


          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "审核时间: "+ (state.userdetails['user']['checktime']== 0?"":DateTime.fromMillisecondsSinceEpoch(state.userdetails['user']['checktime']*1000).toString()),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),

            ],
          ),


          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "会员到期时间: ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                 state.userdetails['user']['endtime']==""?"未开通会员":state.userdetails['user']['endtime'],
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "封号状态: ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  "正常",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "剩余",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  state.userdetails['user']['status']==1?state.userdetails['disday']:"0",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  "天",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .start,
            children: <Widget>[
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child: Circle(
                  color: Colors.blue,
                  radius: 5,
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "禁言状态: ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  "正常",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 10.0,
                ),
                child:  Text(
                  "剩余",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  state.userdetails['user']['comment']==1?state.userdetails['day']:"0",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding:  const EdgeInsets.only(
                  top: 4.0,
                  left: 2.0,
                ),
                child:  Text(
                  "天",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          WidgetNodePanelDetail(
              codeFamily: 'Inconsolata',
              text: "用户图片",
              code: "",
              show:  _buildLinkTo(
                context,
                state.userdetails,
              ),
          ),

          //_buildNodes(state.nodes, state.widgetModel.name)
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "滑动次数 ("+state.userdetails['slidenum'].toString()+"次 A:"+state.userdetails['slidenumA'].toString()+")",
            code: "",
            show: Container()
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "滑动过TA ("+state.userdetails['clickhisnum'].toString()+"次 A:"+state.userdetails['clickhisnumA'].toString()+")",
            code: "待完善",
            show: Container(


            )
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "配对人数 ("+state.userdetails['pairnum'].toString()+"次 A:"+state.userdetails['pairnumA'].toString()+")",
            code: "待完善",
            show: Container(
              width: 500,
              // height: 300,
              child:
              Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: pair.map((e) =>
                  GestureDetector(
                    onTap:() {
                      BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(widget.model,e));
                      Navigator.pushNamed(context, UnitRouter.widget_detail, arguments: widget.model);
                    },
                    //() => _onLongPress(context,img['imagepath']),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage( e['thumbimg']),
                  ))


                  ).toList()),

            )
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "TA喜欢的 ("+state.userdetails['likenum'].toString()+"次 A:"+state.userdetails['likenumA'].toString()+")",
            code: "待完善",
            show: Container(
              width: 500,
              // height: 300,
              child:
              Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: like.map((e) =>
                      GestureDetector(
                          onTap:() {
                            BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(widget.model,e));
                            Navigator.pushNamed(context, UnitRouter.widget_detail, arguments: widget.model);
                          },
                          //() => _onLongPress(context,img['imagepath']),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage( e['thumbimg']),
                          ))

                  ).toList()),

            )
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "喜欢TA的 ("+state.userdetails['belikenum'].toString()+"次 A:"+state.userdetails['belikenumA'].toString()+")",
            code: "待完善",
            show: Container(
              width: 500,
              // height: 300,
              child:
              Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: belike.map((e) =>
                      GestureDetector(
                          onTap:() {
                            BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(widget.model,e));
                            Navigator.pushNamed(context, UnitRouter.widget_detail, arguments: widget.model);
                          },
                          //() => _onLongPress(context,img['imagepath']),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage( e['thumbimg']),
                          ))

                  ).toList()),

            )
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "AI照片 ("+state.userdetails['ainum'].toString()+"张)",
            code: "待完善",
            show: Container(
              width: 500,
              // height: 300,
              child:
              Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 10,
                  children: ai.map((e) =>
                      GestureDetector(
                          onTap:() {
                            ImagePreview.preview(
                              context,
                              images: List.generate(1, (index) {
                                return ImageOptions(
                                  url: e['imagepath'],
                                  tag: e['imagepath'],
                                );
                              }),

                            );
                          },
                          //() => _onLongPress(context,img['imagepath']),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage( e['imagepath']),
                          ))
                  ).toList()),

            ),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "被投诉记录 ("+state.userdetails['complainnumA'].toString()+"次)",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "解除配对 ("+state.userdetails['unpairnum'].toString()+"次 A:"+state.userdetails['unpairnumA'].toString()+")",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "TA的定位",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "订单记录",
            code: "待完善",
            show: Container(),
          )
          ,

        ],
      );
    }
    return Container();
  }
  Widget _buildTitle(BuildContext context, DetailState state) {
    print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      return WidgetDetailTitle(
        model: _modelStack.last,
        usertail: state.userdetails,

      );
    }
    return Container();
  }
  Widget _buildLinkTo(BuildContext context, Map<String,dynamic> userdetail) {

    List<dynamic> imgList =userdetail['images'];
    List<Widget> list = [];
    imgList.map((e) => {

      list.add( Stack(
      children:<Widget> [
          GestureDetector(
          onTap:() {
              ImagePreview.preview(
              context,
              images: List.generate(1, (index) {
                  return ImageOptions(
                    url: e['imagepath'],
                    tag: e['imagepath'],
                    );
                  }),

              );
          },
        //() => _onLongPress(context,img['imagepath']),
          child: Container(
          color: Colors.black12,
          margin: EdgeInsets.all(10),
          width: 110,
          height: 200,
          child: Image(
            image: FadeInImage.assetNetwork(
              placeholder:'assets/images/icon_head.webp',
              image:e['imagepath'],
            ).image,
          ),

        )),
        Positioned(
            top: 8,
            right: 5,
            child:
            FeedbackWidget(
              onPressed: () {
                _deletePhoto(context,e);
              },
              child: const Icon(
                CupertinoIcons.delete_solid,
                color: Colors.red,
              ),
            )
        ),
      ],

    ))

    }


    ).toList();


    return Wrap(
      children: [
        ...list
      ],
    );
  }
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
_changeSex(BuildContext context,Map<String,dynamic> img) {
  showDialog(
      context: context,
      builder: (ctx) => Dialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          width: 50,
          child: ChangeCategoryDialog(
            title: '修改性别',
            content: '是否确定继续执行?',
            onSubmit: () {
              BlocProvider.of<DetailBloc>(context).add(ChangeSexDetail(1,img));
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('修改成功'),
                backgroundColor: Colors.green,
              ));
              Navigator.of(context).pop();
            },
            onCancel: (){
              BlocProvider.of<DetailBloc>(context).add(ChangeSexDetail(2,img));
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('修改成功'),
                backgroundColor: Colors.green,
              ));
              Navigator.of(context).pop();
            },
          ),
        ),
      ));
}
class WidgetDetailTitle extends StatelessWidget {
  final WidgetModel model;
  final Map<String,dynamic> usertail;
  WidgetDetailTitle({this.model,this.usertail});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildLeft(model,usertail),
            _buildRight(model,usertail),
          ],
        ),
        Divider(),
      ],
    ));
  }

  final List<int> colors = Cons.tabColors;

  Widget _buildLeft(WidgetModel model,Map<String,dynamic> usertail) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 20),
              child: Text(
                "用户名："  + usertail['user']['userName'],
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1EBBFD),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,top: 2),
              child: Panel(child: Text(
                   "性别："  + (usertail['user']['sex'].toString()=="1"?"男":"女")+
                   " 年龄："  + usertail['user']['age'].toString()+
                   " 手机号："  + usertail['user']['tel'].toString()+
                   " 颜值："  + usertail['user']['facescore'].toString()
              )),
            )
          ],
        ),
      );

  Widget _buildRight(WidgetModel model,Map<String,dynamic> usertail) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Hero(
                  tag: "hero_widget_image_${usertail['user']['memberId'].toString()}",
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: model.image == null
                          ? Image.asset('assets/images/caver.webp')
                          : Image(image: FadeInImage.assetNetwork(
                        placeholder:'assets/images/icon_head.webp',
                        image:usertail['user']['img'],
                      ).image))),
            ),
          ),

        ],
      );
}
