import 'package:equatable/equatable.dart';
import 'package:flutter_unit/model/widget_model.dart';


/// 说明: 详情事件

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object> get props => [];
}


class FetchWidgetDetail extends DetailEvent {
  final WidgetModel widgetModel;
  final Map<String,dynamic> photo;
  const FetchWidgetDetail(this.widgetModel,this.photo);

  @override
  List<Object> get props => [widgetModel,photo];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: $widgetModel}';
  }
}


class ResetDetailState extends DetailEvent {

}

class ChangeSexDetail extends DetailEvent {
  final int sex;
  final Map<String,dynamic> photo;
  const ChangeSexDetail(this.sex,this.photo);

  @override
  List<Object> get props => [sex,photo];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}