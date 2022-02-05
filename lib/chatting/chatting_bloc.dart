import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';
import 'package:github_flutter_app/chatting/login/auth_service.dart';

part 'chatting_event.dart';
part 'chatting_state.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  AuthService _authService;

  List<UserModel> users = [];
  List<String> myListMessages = [];

  ChattingBloc(this._authService) : super(EmptyState()) {
    on<InitEvent>((event, emit) async {
      await _authService.getAllUsers().then((value) => users = value);
      emit(ChattingInitial(users: users));
    });
    on<OpenChatWithUserEvent>(
        (event, state) => emit(OpenSelectedUser(userId: event.userid)));
    on<SendMessageEvent>((event, state) {
      myListMessages.add(event.text);
      print('SendMessageEvent $myListMessages');
      _authService.sendMessage(message: event.text);
      emit(SendMessageState(myListMessages: myListMessages));
    });
  }
}
