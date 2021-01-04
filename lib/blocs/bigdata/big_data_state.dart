import 'package:equatable/equatable.dart';
import '../../big_data_menu_entity.dart';
import '../../big_datas_entity.dart';



/// 说明: 主页状态类

abstract class BigDataState extends Equatable {
  const BigDataState();

  @override
  List<Object> get props => [];
}

class BigDataInitals extends BigDataState {
  const BigDataInitals();

  @override
  List<Object> get props => [];
}

class GetBigDataSuccess extends BigDataState {

  final BigDataMenuEntity big;

  const GetBigDataSuccess(this.big);
  @override
  List<Object> get props => [big];
}