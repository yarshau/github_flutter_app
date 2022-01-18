import 'package:flutter/material.dart';
import 'package:github_flutter_app/chatting/create_user/create_user_page.dart';
import 'package:github_flutter_app/login/auth_service.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final nickname = TextEditingController();
  final password = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _authService.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.hasError}');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                      controller: nickname,
                      decoration: InputDecoration(
                          labelText: 'NickName', border: OutlineInputBorder())),
                  SizedBox(height: 10),
                  TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder())),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton(
                        child: Text('Sign Up'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateUserPage()));
                        }),
                    ElevatedButton(
                        child: Text('Login'),
                        onPressed: () {
                          _authService.signInWithEmailAndPassword(
                              nickname.text, password.text);
                          FocusManager.instance.primaryFocus?.unfocus();
                          password.clear();
                        }),
                  ]),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
