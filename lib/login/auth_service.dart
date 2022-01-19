import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';

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
//      final currentUser1 = await _auth.;;
//      print('currentUser ${a}');
//      final js = (json.decode() as List<dynamic>)

      final UserModel userInfo = UserModel.fromFirebaseUser(user);


//      print('_auth.currentUser.toString() ${_auth.currentUser.toString()}');
//      print('_auth.currentUser.runtimeType ${_auth.currentUser}');
//      print('user.toString()  ${user.toString()}');
//      print('json $js');
      final list = FirebaseFirestore.instance.collection('users').doc();
      list.set(userInfo.toFireStore());
      return user.toString();
    } catch (e) {
      print('${e.toString()}');
      return e.toString();
    }
  }

  Future getUsers() async {
    final a = FirebaseAdmin.instance.initializeApp();
    final b = await a.auth().listUsers();
    print ('bbbb $b');
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc("docID")
        .get();
  }
}
