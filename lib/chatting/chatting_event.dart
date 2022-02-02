part of 'chatting_bloc.dart';

abstract class ChattingEvent extends Equatable {
  const ChattingEvent();
}

class InitEvent extends ChattingEvent{

  @override
  List<Object?> get props => [];

}

class OpenChatWithUserEvent extends ChattingEvent{
  final String userid;

  OpenChatWithUserEvent(this.userid);

  @override
  List<Object> get props => [userid];
}

class SendMessageEvent extends ChattingEvent {
  final String text;

  SendMessageEvent({required this.text});

  @override
  List<Object> get props => [];
}