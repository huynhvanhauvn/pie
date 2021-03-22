import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ListeningEvent extends Equatable {}

class GetListLevel extends ListeningEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetListUnit extends ListeningEvent {
  final String id;

  GetListUnit({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class GetListAudio extends ListeningEvent {
  final String idUnit;
  final String idLevel;

  GetListAudio({@required this.idUnit, @required this.idLevel});

  @override
  // TODO: implement props
  List<Object> get props => [idUnit, idLevel];
}

class GetAudio extends ListeningEvent {
  final String id;

  GetAudio({@required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
