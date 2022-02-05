part of 'chatting_bloc.dart';

abstract class ChattingState extends Equatable {
  const ChattingState();
}

class ChattingInitial extends ChattingState {
  List<UserModel> users;

  ChattingInitial({required this.users});

  @override
  List<Object> get props => [];
}

class EmptyState extends ChattingState {

  @override
  List<Object> get props => [];
}

class OpenSelectedUser extends ChattingState {

  final String userId;

  OpenSelectedUser({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SendMessageState extends ChattingState {
  final List<String> myListMessages;

  SendMessageState({required this.myListMessages});

  @override
  List<Object> get props => [myListMessages];
}