import 'package:flutter/material.dart';
import 'package:github_flutter_app/chatting/chatting_screen.dart';
import 'package:github_flutter_app/login/auth_service.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  AuthService _authService = AuthService();
  final _email = TextEditingController(text: 'yar@test.com');
  final _password = TextEditingController(text: '123456');
  final _confirm_password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Text('Create a new account in a moment',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue)),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter valid email';
                  }
                  ;
                },
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (value.length < 6) {
                    return 'The length of password should be 6 or more symbols';
                  }
                },
                controller: _password,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: _confirm_password,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              ElevatedButton(
                child: Text('Create'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String result = await _authService.createNewUser(
                        _email.text, _password.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$result')),
                    );
                    _isVisible = true;
                    setState(() {

                    });
                  }
                },
              ),
              TextButton(
                  onPressed: () {
                    _authService.getUsers();
                  },
                  child: Text('users')),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChattingScreen()),
          );
        }),
      ),
    );
  }
}
