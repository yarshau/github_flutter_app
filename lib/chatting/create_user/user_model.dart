import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseResponse {}

class FireBaseResponseError extends FirebaseResponse {
  final String message;

  FireBaseResponseError(this.message);
}

class UserModel extends FirebaseResponse {
  final bool isNewUser;
  final String? displayName;
  final String? email;
  final bool isAnonymous;
  final String? phoneNumber;
  final String? photoURL;
  final String uid;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final bool emailVerified;

//  final List<UserInfo> providerData;

  UserModel({
    this.isAnonymous = false,
    this.isNewUser = true,
    this.emailVerified = true,
    this.creationTime,
    this.lastSignInTime,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoURL,
    required this.uid,
//    required this.providerData
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
        isNewUser: true,
        phoneNumber: user.phoneNumber,
        displayName: user.displayName,
        uid: user.uid,
        isAnonymous: user.isAnonymous,
        email: user.email,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
        creationTime: user.metadata.creationTime,
        lastSignInTime: user.metadata.lastSignInTime
    );
  }

  factory UserModel.fromJson(user) {
    return UserModel(
        isNewUser: true,
        phoneNumber: user['phoneNumber'],
        displayName: user['displayName'],
        uid: user['uid'],
        isAnonymous: user['isAnonymous'],
        email: user['email'],
        photoURL: user['photoURL'],
        emailVerified: user['emailVerified'],
        creationTime: Timestamp.now().toDate(),
        lastSignInTime: Timestamp.now().toDate());
  }

  Map<String, dynamic> toFireStore(String uid, String displayName, String? email, phoneNumber, photoURL) {
    return {
      'isNewUser': isNewUser,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'uid': uid,
      'isAnonymous': isAnonymous,
      'email': email,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
    };
  }

//  @override
//  String toString() {
//    super.toString();
//    return toFireStore().toString();
//  }
}
