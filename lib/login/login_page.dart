import 'package:flutter/material.dart';
import 'package:github_flutter_app/chatting/create_user/create_user_page.dart';
import 'package:github_flutter_app/login/auth_service.dart';

import '../chatting/chatting_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final nickname = TextEditingController(text: 'yar@test.com');
  final password = TextEditingController(text: '123456');
  String error ='';


  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
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
                            labelText: 'Email', border: OutlineInputBorder())),
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
                      SizedBox(width: 20),
                      ElevatedButton(
                          child: Text('Login'),
                          onPressed: () async {
                            Object? login = await _authService.signInWithEmailAndPassword(
                                nickname.text, password.text);
                            if (login == null) {
                              print ('Incorrect Email or Password');
                               setState(() {
                                 error = 'Incorrect Email or Password';
                               });
                            } else {
                              print('login    $login');
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => ChattingScreen()));
                            }  }),
                    ]),
                  SizedBox(height: 15,),
                  Text(error, style: TextStyle(color: Colors.red,fontSize: 20),)
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }


}
