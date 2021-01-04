import 'package:equatable/equatable.dart';

abstract class BigDataEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class EventGetBigData extends BigDataEvent {

  EventGetBigData();

}
