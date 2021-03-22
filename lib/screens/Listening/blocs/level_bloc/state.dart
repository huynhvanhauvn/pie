import 'package:equatable/equatable.dart';
import 'package:pie/models/level.dart';

abstract class LevelState extends Equatable {
  @override
  List<Object> get props => [];
}
class LevelInitial extends LevelState {}
class LevelLoading extends LevelState {}
class LevelSuccess extends LevelState {
  final List<Level> levels;
  LevelSuccess({this.levels});

  @override
  List<Object> get props => [levels];
}
class LevelFailure extends LevelState {}