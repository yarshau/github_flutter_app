import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_flutter_app/chatting/chatting_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../login/auth_service.dart';


class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  AuthService _authService = AuthService();
  final _email = TextEditingController(text: 'yar@test.com');
  final _password = TextEditingController(text: '123456');
  final _confirm_password = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  File? _image;

  Future _getImage() async {
    try {
      final _image = await ImagePicker().pickImage(source: ImageSource.gallery);
      final imageTemporary = File(_image!.path);
      setState(() => this._image = imageTemporary);

    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(children: [
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!value.contains('@') ||
                              !value.contains('.')) {
                            return 'Please enter valid email';
                          }
                        },
                        controller: _email,
                        decoration: InputDecoration(
                            labelText: 'Email \ *',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (value.length < 6) {
                            return 'The length of password should be 6 or more symbols';
                          }
                        },
                        controller: _password,
                        decoration: InputDecoration(
                            labelText: 'Password \ *',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirm_password,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                      ),
                    ]),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: _getImage,
                              child: Container(
                                color: Colors.black12,
                                height: 130,
                                width: 130,
                                child: _image == null
                                    ? Icon(FontAwesomeIcons.image)
                                    : Image.file(_image!),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _phoneNumber,
                            decoration: InputDecoration(
                                labelText: 'Phone Number \ *',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                child: Text('Create'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String result = await _authService.createNewUser(
                        _email.text, _password.text, _phoneNumber.text, image: _image);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$result')),
                    );
                    _isVisible = true;
                    setState(() {});
                  }
                },
              ),
              TextButton(onPressed: () {}, child: Text('users')),
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
