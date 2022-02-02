import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:github_flutter_app/chatting/create_user/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDatabase realtimeDatabase = FirebaseDatabase.instance;

  Future<Object?> signInWithEmailAndPassword(
      String email, String password) async {
    _auth.idTokenChanges();
    try {
      final user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      print(user.toString());
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    CollectionReference<Map<String, dynamic>> users =
        _firestore.collection('users');
//    UserModel.fromFirebaseUser(users);
    QuerySnapshot querySnapshot = await users.get();
    // if write these 2 strings in 1 - getting 2 nulls   -- why???
    final allData = querySnapshot.docs;
    List<UserModel> listUsers =
        allData.map((e) => UserModel.fromJson(e.data())).toList();
    listUsers.removeWhere((element) => element.uid == getCurrentUserId);
    return listUsers;
  }

  String get getCurrentUserId {
    return _auth.currentUser!.uid;
  }

  Future<String> createNewUser(
      String email, String password, String phoneNumber,
      {File? image}) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      sendUserToFirestore(user!, phoneNumber, image: image);
      return user.toString();
    } catch (e) {
      print('${e.toString()}');
      return e.toString();
    }
  }

  Future<void> sendUserToFirestore(User user, phoneNumber,
      {File? image}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final displayName = user.email!
        .replaceRange(user.email!.indexOf('@'), user.email!.length, '');
    String avatarUrl = '';
    if (image != null) {
      await _storage.ref('avatars/${user.uid}').putFile(image);
      avatarUrl = await _storage.ref('avatars/${user.uid}').getDownloadURL();
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();

    UserModel userModel = UserModel(
        displayName: displayName,
        email: user.email,
        phoneNumber: phoneNumber,
        photoURL: user.photoURL,
        uid: user.uid);
    batch.set(
        FirebaseFirestore.instance.collection('users').doc(),
        userModel.toFireStore(
            user.uid, displayName, user.email, phoneNumber, user.photoURL));
    users.doc(user.uid).set(userModel.toFireStore(
        user.uid, displayName, user.email, phoneNumber, avatarUrl));
  }

  Future<DocumentSnapshot> getData() async {
    await Firebase.initializeApp();
    return await _firestore.collection("users").doc("docID").get();
  }

  Future getUserAvatar(userId) async {
//    print('userData.uid  ${userData}');
    try {
      final avatar;
      avatar = await _storage.ref('avatars/${userId}').getDownloadURL();
      print('nnnaaaameee $avatar)');
      return avatar;
    } catch (e) {
      print('eeeeeee $e');
    }

//    print('list  33333 $avatar');
  }

  Future logOut() async {
    await _auth.signOut();
  }


//Stream stream(){
//    return realtimeDatabase.
//}


}
