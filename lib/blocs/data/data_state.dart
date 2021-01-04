import 'package:equatable/equatable.dart';
import '../../big_datas_entity.dart';



/// 说明: 主页状态类

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitals extends DataState {
  const DataInitals();

  @override
  List<Object> get props => [];
}

class GetDataSuccess extends DataState {

  final BigDatasEntity big;

  const GetDataSuccess(this.big);
  @override
  List<Object> get props => [big];
}