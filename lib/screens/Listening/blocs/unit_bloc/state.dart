import 'package:equatable/equatable.dart';
import 'package:pie/models/level.dart';
import 'package:pie/models/unit.dart';

abstract class UnitState extends Equatable {
  @override
  List<Object> get props => [];
}
class UnitInitial extends UnitState {}
class UnitLoading extends UnitState {}
class UnitSuccess extends UnitState {
  final List<Unit> units;
  UnitSuccess({this.units});

  @override
  List<Object> get props => [units];
}
class UnitFailure extends UnitState {}