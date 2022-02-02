import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';
import 'package:github_flutter_app/chatting/login/auth_service.dart';

part 'chatting_event.dart';

part 'chatting_state.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  AuthService _authService;

  List<UserModel> _users = [];

  ChattingBloc(this._authService) : super(EmptyState());

  @override
  Stream<ChattingState> mapEventToState(
    ChattingEvent event,
  ) async* {
    _authService.getAllUsers().then((value) => _users = value);
    on<InitEvent>((event, emit) => emit(ChattingInitial(users: _users)));
    on<OpenChatWithUserEvent>(
        (event, state) => emit(OpenSelectedUser(userId: event.userid)));
    on<SendMessageEvent>((event, state) {
      print('SendMessageEvent');
      emit(SendMessageState(text: event.text));
    });
  }
}
