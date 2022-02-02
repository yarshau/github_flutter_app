import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_flutter_app/chatting/chatting_bloc.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';

import 'login/auth_service.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _messageController = TextEditingController();
  AuthService _authService = AuthService();

  late String userId;
  late Future<List<UserModel>> users;
  late ChattingBloc _bloc;
  List myListMessages = [];

  @override
  void initState() {
    super.initState();
    AuthService _authService = AuthService();
    _bloc = ChattingBloc(_authService);
    userId = _authService.getCurrentUserId;
    users = _authService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: FutureBuilder(
              future: _getAvatar(context, userId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  print('snaphot : ${snapshot.data.toString()}');
                  return CircleAvatar(
                      backgroundColor: Colors.black12,
                      foregroundColor: Colors.yellowAccent,
                      backgroundImage: NetworkImage(snapshot.data));
                } else {
                  return CircularProgressIndicator();
                }
              }),
          actions: [
            IconButton(
                onPressed: () async {
                  await _authService.logOut();
                  Navigator.pushReplacementNamed(context, 'my_app');
                },
                icon: Icon(Icons.exit_to_app)),
          ]),
      body: BlocProvider(
        create: (context) => _bloc,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            usersRaw(),
            Spacer(),
            ChattingWidget(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _bloc
                          .add(SendMessageEvent(text: _messageController.text));
                    },
                    child: Text('Send'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getAvatar(BuildContext context, String userId) async {
    String imageUrl = await _authService.getUserAvatar(userId);
    return imageUrl;
  }

  Widget usersRaw() {
    return FutureBuilder<List<UserModel>>(
        future: _authService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('snapshot list of USERS: ${snapshot.data}');
            return Container(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final user = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        _bloc.add(OpenChatWithUserEvent(user.uid));
                      },
                      child: Column(
                        children: [
                          Flexible(
                            flex: 10,
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(user.photoURL!),
                            ),
                          ),
                          Flexible(flex: 3, child: Text('${user.displayName}'))
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else
            return Text('No data');
        });
  }

  Widget ChattingWidget() {
    return BlocBuilder<ChattingBloc, ChattingState>(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          print('state ${state}');
          if (state is OpenSelectedUser) {
            return Text(state.userId);
          }
          if (state is SendMessageState) {
            myListMessages.add(state.text);
            return messageWidget();
          } else
            return Text('sa');
        });
  }

  Widget messageWidget() {
    return ListView.builder(
      itemBuilder: (_, index) => Container(child: Text(myListMessages[index])),
      itemCount: myListMessages.length,

    );
  }
}
