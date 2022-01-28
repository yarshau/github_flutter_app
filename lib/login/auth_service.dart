import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<Object?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      final user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password))
          .user;
      print(user.toString());
      return user;
    } catch (e) {
      print (e);
      return null;
    }
  }

  User? getUser(){
    return FirebaseAuth.instance.currentUser;
  }


  Future<String> createNewUser(String email, String password,
      String phoneNumber,
      {File? image}) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user;
      await user!.updateDisplayName(
          email.replaceRange(email.indexOf('@'), email.length, ''));
      final UserModel userInfo = UserModel.fromFirebaseUser(user);
      final Map<String, dynamic> sendUser =
      userInfo.toFireStore(phoneNumber: phoneNumber);
      final userMap =
      await FirebaseFirestore.instance.collection('users').doc();
      userMap.set(sendUser);
      if (image != null) {
        _storage.ref('avatars/${user.uid}').putFile(image);
      }
      print('sendUser: ${userInfo.uid}');
      return sendUser.toString();
    } catch (e) {
      print('${e.toString()}');
      return e.toString();
    }
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc("docID")
        .get();
  }

  Future getUserAvatar(userId) async {
//    print('userData.uid  ${userData}');
    try {
      final  avatar ;
      avatar = await _storage.ref('avatars/${userId}').getDownloadURL();
      print('nnnaaaameee $avatar)');
      return avatar;

    }
    catch (e){print('eeeeeee $e');}

//    print('list  33333 $avatar');
  }


  Future logOut() async{
    await _auth.signOut();
  }
}
