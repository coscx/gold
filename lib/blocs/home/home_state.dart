import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unit/app/enums.dart';
import 'package:flutter_unit/model/widget_model.dart';

/// 说明: 主页状态类

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class WidgetsLoading extends HomeState {
  const WidgetsLoading();

  @override
  List<Object> get props => [];
}

class WidgetsLoaded extends HomeState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  const WidgetsLoaded(
      {this.activeFamily, this.widgets = const [],this.photos});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class WidgetsLoadFailed extends HomeState {
  const WidgetsLoadFailed();

  @override
  List<Object> get props => [];
}


class CheckUserSuccess extends HomeState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  const CheckUserSuccess(
      {this.activeFamily, this.widgets = const [],this.photos});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class DelImgSuccess extends HomeState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  const DelImgSuccess(
      {this.activeFamily, this.widgets = const [],this.photos});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}