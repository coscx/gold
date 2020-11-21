

import 'package:flutter/material.dart';
import 'package:flutter_unit/app/api/issues_api.dart';
import 'package:flutter_unit/app/utils/convert.dart';
import 'package:flutter_unit/repositories/itf/widget_repository.dart';

import 'search_event.dart';
import 'search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final WidgetRepository repository;

  SearchBloc({@required this.repository});
  @override
  SearchState get initialState => SearchStateNoSearch();//初始状态


  @override
  Stream<SearchState> transformEvents(
      Stream<SearchEvent> events,
      Stream<SearchState> Function(SearchEvent event) next,) {
    return super.transformEvents(events
        .debounceTime(Duration(milliseconds: 500),),
      next,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event,) async* {
    if (event is EventTextChanged) {
      if (event.args.name.isEmpty&&event.args.stars.every((e)=>e==-1)) {
        yield SearchStateNoSearch();
      } else {
        yield SearchStateLoading();
        try {
          var args= event.args;
          //final results = await repository.searchWidgets(event.args);
          final results = await this.repository.loadWidgets(Convert.toFamily(6));
          //var newUserBond=results.reversed.toList();
          var key=event.args.name;
          if (key==null){
            key="";
          }
          if(key==""){
            //yield SearchStateNoSearch();
            //return;
          }
          var result= await IssuesApi.searchPhoto(event.args.name, '1');
          if  (result['code']==200){


          } else{

          }
          if(result['data']['photo_list'].length==0){
            yield SearchStateEmpty();
          }else{
            yield   SearchStateSuccess(results,result['data']['photo_list']);
          }

          print('mapEventToState');
        } catch (error) {
          print(error);
          yield  SearchStateError();
        }
      }
    }
  }
}