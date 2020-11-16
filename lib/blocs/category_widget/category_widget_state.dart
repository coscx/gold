import 'package:equatable/equatable.dart';
import 'package:flutter_unit/model/category_model.dart';
import 'package:flutter_unit/model/widget_model.dart';



class CategoryWidgetState extends Equatable{
  @override
  List<Object> get props => [];

}


class CategoryWidgetLoadedState extends CategoryWidgetState {
  final List<WidgetModel> widgets;

  CategoryWidgetLoadedState(this.widgets);

  List<Object> get props => [widgets];

}

class CategoryWidgetEmptyState extends CategoryWidgetState{
  List<Object> get props => [];
}


