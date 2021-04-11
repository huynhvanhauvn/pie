import 'package:equatable/equatable.dart';
import 'package:pie/models/audio.dart';

abstract class AudioState extends Equatable {
  @override
  List<Object> get props => [];
}
class AudioInitial extends AudioState {}
class AudioLoading extends AudioState {}
class AudioSuccess extends AudioState {
  final List<Audio> audios;
  AudioSuccess({this.audios});

  @override
  List<Object> get props => [audios];
}
class AudioFailure extends AudioState {}