import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/app/api/issues_api.dart';
import 'package:flutter_unit/app/enums.dart';
import 'package:flutter_unit/app/res/cons.dart';
import 'package:flutter_unit/repositories/itf/widget_repository.dart';
import 'dart:convert';
import 'home_event.dart';
import 'home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WidgetRepository repository;

  HomeBloc({@required this.repository});

  @override
  HomeState get initialState => WidgetsLoading();

  Color get activeHomeColor {

    if (state is WidgetsLoaded) {
      return Color(Cons.tabColors[(state as WidgetsLoaded).activeFamily.index]);
    }
    return Color(Cons.tabColors[0]);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is EventTabTap) {

      yield* _mapLoadWidgetToState(event.family);
    }
    if (event is EventCheckUser) {

      var user=event.user;
      List<dynamic> users =state.props.elementAt(2);
      var status = event.status;
      try {
        var newUsers= users.where((element) =>
        element['memberId'] != user['memberId']
        ).toList();


        yield CheckUserSuccess(widgets: state.props.elementAt(1), activeFamily: state.props.elementAt(0),photos: newUsers);
      } catch (err) {
        print(err);
        yield WidgetsLoadFailed();
      }

    }
    if (event is EventDelImg) {

      var img=event.user;
      List<dynamic> oldUsers = state.props.elementAt(2);
      var newUserBond=jsonDecode(jsonEncode(oldUsers));
      var status = event.status;
      try {
        var newUsers= newUserBond.map((item) {
          if(item['memberId'] == img['memberId']){
            List<dynamic>  images = item['imageurl'];
            var items= images.where((element) =>
            element['imgId'] != img['imgId']
            ).toList();
            item['imageurl']=items;
            return item;
          }else{
            return item;
          }

        }).toList();

        yield DelImgSuccess(widgets: state.props.elementAt(1), activeFamily: state.props.elementAt(0),photos: newUsers);
      } catch (err) {
        print(err);
        yield WidgetsLoadFailed();
      }

    }
  }

  Stream<HomeState> _mapLoadWidgetToState(WidgetFamily family) async* {
    yield WidgetsLoading();
    try {

      var result= await IssuesApi.getPhoto('', '1');
      if  (result['code']==200){


      } else{

      }
      final widgets = await this.repository.loadWidgets(family);
      yield WidgetsLoaded(widgets: widgets, activeFamily: family,photos: result['data']['photo_list']);

    } catch (err) {
      print(err);
      yield WidgetsLoadFailed();
    }
  }

}
