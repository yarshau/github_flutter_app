import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      print(user.toString());
    } catch (e) {
      throw e;
    }
  }

  Future<String> createNewUser(String email, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password,)).user;
      await user!.updateDisplayName(
          email.replaceRange(email.indexOf('@'), email.length, ''));
//      print(('additional info${user.additionalUserInfo}'));
      FirebaseAuth.instance.currentUser;
      final currentUser = await FirebaseAuth.instance.currentUser;;
      print('currentUser $currentUser');
//      final js = await json.decode(currentUser);
      print('_auth.currentUser.toString() ${_auth.currentUser.toString()}');
      print('_auth.currentUser.runtimeType ${_auth.currentUser.runtimeType}');
      print('user.toString()  ${user.toString()}');
//      print('json $js');
      final list = FirebaseFirestore.instance.collection('users').doc();
      list.set({'uid': '${user.toString()}'});
      return user.toString();
    } catch (e) {
      print('${e.toString()}');
      return e.toString();
    }
  }

  Future getUsers() async {
    final users = await _auth.currentUser!.updatePhotoURL(
        'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cGhvdG98ZW58MHx8MHx8&w=1000&q=80');
//    final currentUser = await _auth.currentUser;
//  print('current is: ${currentUser!.uid}');
//  return currentUser!.uid;
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc("docID")
        .get();
  }
}
