import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unit/app/api/issues_api.dart';
import 'package:flutter_unit/model/widget_model.dart';
import 'package:flutter_unit/repositories/itf/widget_repository.dart';

import 'detail_event.dart';
import 'detail_state.dart';



class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final WidgetRepository repository;

  DetailBloc({@required this.repository});

  @override
  DetailState get initialState => DetailLoading();

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is FetchWidgetDetail) {
      yield* _mapLoadWidgetToState(event.widgetModel,event.photo);
    }
    if(event is ResetDetailState){
      yield DetailLoading();
    }

    if(event is ChangeSexDetail){
      try {
        WidgetModel widgetModel=  state.props.elementAt(0);
        Map<String ,dynamic> userdetails=  state.props.elementAt(3);
        final nodes = await this.repository.loadNode(widgetModel);
        final links = await this.repository.loadWidget(widgetModel.links);

        var result= await IssuesApi.changeSexDetail(event.photo['user']['memberId'].toString(),event.sex);
        if  (result['code']==200){
          userdetails['user']['sex']=event.sex;
        }


        yield DetailWithData(widgetModel: widgetModel, nodes: nodes,links: links,userdetails: userdetails);


      } catch (_) {
        yield DetailFailed();
      }
    }
  }

  Stream<DetailState> _mapLoadWidgetToState(
      WidgetModel widgetModel, Map<String,dynamic> photo) async* {
    yield DetailLoading();
    try {
      final nodes = await this.repository.loadNode(widgetModel);
      final links = await this.repository.loadWidget(widgetModel.links);
      var result= await IssuesApi.getUserDetail(photo['memberId'].toString());
      if  (result['code']==200){

      } else{

      }
      if(nodes.isEmpty){
        yield DetailEmpty();
      }else{
        yield DetailWithData(widgetModel: widgetModel, nodes: nodes,links: links,userdetails: result['data']);
      }

    } catch (_) {
      yield DetailFailed();
    }
  }
}
