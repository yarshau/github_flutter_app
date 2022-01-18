import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/chatting/chatting_bloc.dart';
import 'package:github_flutter_app/login/auth_service.dart';
import 'firebase_client.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseClient _firebaseClient = FirebaseClient();
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Material(
//      child: BlocListener<ChattingBloc, ChattingState>(
//        listener: (context, state) {
//          if(state is ChattingInitial){
//            return Image.network();
//          }
//        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Here we go chatting...'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                            icon: Icon(Icons.emoji_emotions_outlined),
                            onPressed: () async {
//                              await _firebaseClient.upload();
                            }),
                        labelText: 'Message',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  await _firebaseClient.getUsersInfo();
                }, child: Text('users'))
              ],
            ),
          ],
        ),
//      ),
    );
  }
}
