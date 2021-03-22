import 'package:equatable/equatable.dart';
import 'package:pie/models/audio.dart';

abstract class AudioDetailState extends Equatable {
  @override
  List<Object> get props => [];
}
class AudioDetailInitial extends AudioDetailState {}
class AudioDetailLoading extends AudioDetailState {}
class AudioDetailSuccess extends AudioDetailState {
  final Audio audio;
  AudioDetailSuccess({this.audio});

  @override
  List<Object> get props => [audio];
}
class AudioDetailFailure extends AudioDetailState {}