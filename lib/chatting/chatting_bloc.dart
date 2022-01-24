import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chatting_event.dart';
part 'chatting_state.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  ChattingBloc() : super(ChattingInitial());
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  Stream<ChattingState> mapEventToState(
    ChattingEvent event,
  ) async* {
    on<InitEvent>((event, emit) => emit (ChattingInitial()));
  }
}
