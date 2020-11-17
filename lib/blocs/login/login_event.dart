import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unit/app/enums.dart';
import 'package:flutter_unit/storage/po/widget_po.dart';
import 'package:flutter_unit/model/widget_model.dart';



abstract class LoginEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class EventLogin extends LoginEvent {
  final String username;
  final String password;
  EventLogin({this.username,this.password});
}

class EventLoginFailed extends LoginEvent {

}
