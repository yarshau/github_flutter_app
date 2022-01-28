import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_flutter_app/login/auth_service.dart';
import 'package:github_flutter_app/login/login_page.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _messageController = TextEditingController();
  AuthService _authService = AuthService();

  late String userId;

  @override
  void initState() {
    super.initState();
    User? user = _authService.getUser();
    userId = user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: FutureBuilder(
                future: _getAvatar(context, userId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    print('snaphot : ${snapshot.data.toString()}');
                    return CircleAvatar(child: snapshot.data);
                  } else {
                    return Text('no avatar');
                  }
                })),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await _authService.logOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('log out')),
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
                    onPressed: () async {
//                      await _firebaseClient.getUserAvatar();
                    },
                    child: Text('users'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Image?> _getAvatar(BuildContext context, String userId) async {
    Image? image;
    String imageUrl = await _authService.getUserAvatar(userId);
    print('imageURLL $imageUrl');
    image = Image.network(imageUrl);
    return image;
  }
}
