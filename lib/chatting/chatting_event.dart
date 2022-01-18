part of 'chatting_bloc.dart';

abstract class ChattingEvent extends Equatable {
  const ChattingEvent();
}

class InitEvent extends ChattingEvent{

  @override
  List<Object?> get props => [];

}
