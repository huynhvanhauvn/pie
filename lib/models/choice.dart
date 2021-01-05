import 'package:equatable/equatable.dart';

class Choice extends Equatable {
  final String title;
  final int value;

  Choice({this.title, this.value});

  @override
  // TODO: implement props
  List<Object> get props => [title, value];
}