import 'package:equatable/equatable.dart';


abstract class DataEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class EventGetData extends DataEvent {

  EventGetData();

}
