import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChattingScreen extends StatefulWidget {
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Here we go chatting...'),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.emoji_emotions_outlined),
                labelText: 'Message',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }
}
