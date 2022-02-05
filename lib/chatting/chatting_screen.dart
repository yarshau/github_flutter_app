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

  @override
  void initState() {
    super.initState();
    AuthService _authService = AuthService();
    _bloc = ChattingBloc(_authService);
    userId = _authService.getCurrentUserId;
    users = _authService.getAllUsers();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: FutureBuilder(
              future:  _getAvatar(context, userId),
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
                            onPressed: () {}),
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
//    return BlocBuilder<ChattingBloc, ChattingState>(
//        bloc: _bloc,
//        builder: (BuildContext context, state) {
//          if (state is EmptyState) {
//            child:
//            ListView.builder(
//                scrollDirection: Axis.horizontal,
//                itemCount: _bloc.users.length,
//                itemBuilder: (context, index) {
//                  final user = _bloc.users[index];
//                  return Container(
//                      margin: const EdgeInsets.only(right: 12),
//                      child: GestureDetector(
//                          onTap: () {
//                            _bloc.add(OpenChatWithUserEvent(user.uid));
//                          },
//                          child: Column(
//                            children: [
//                              Flexible(
//                                flex: 10,
//                                child: CircleAvatar(
//                                  radius: 24,
//                                  backgroundImage: NetworkImage(user.photoURL!),
//                                ),
//                              ),
//                              Flexible(
//                                  flex: 3, child: Text('${user.displayName}'))
//                            ],
//                          )));
//                });
//          }
//          print('state ${state}');
//          if (state is OpenSelectedUser) {
//            return Text(state.userId);
//          }
//          return Text('Not Loaded EmptyState');
//        });

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
          if (state is SendMessageState) {
            print('stateTEXTTT ${state.myListMessages}');
            if (state.myListMessages.isEmpty) {
              return Text(
                'Send a Greeting to yor penpall',
                style: TextStyle(fontSize: 15),
              );
            }
            return messageWidget(state.myListMessages);
          } else
            return Text('unknownState');
        });
  }

  Widget messageWidget(List myListMessages) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemBuilder: (_, index) => Chip(
            label: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'My Message:  ${myListMessages[index]}',
                  style: TextStyle(fontSize: 15),
                ))),
        itemCount: myListMessages.length,
      ),
    );
  }
}
