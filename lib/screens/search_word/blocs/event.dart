import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {}

class SearchWord extends SearchEvent {
  String keyword;
  bool isRefresh;

  SearchWord({this.keyword, this.isRefresh});

  @override
  // TODO: implement props
  List<Object> get props => [keyword, isRefresh];
}
