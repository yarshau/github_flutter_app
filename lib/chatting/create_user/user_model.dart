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
  String? phoneNumber;
  final String? photoURL;
  final String uid;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final bool emailVerified;
//  final List<UserInfo> providerData;

  UserModel({required this.displayName,
    required this.email,
    required this.isAnonymous,
    required this.phoneNumber,
    required this.photoURL,
    required this.uid,
    required this.isNewUser,
    required this.emailVerified,
    required this.creationTime,
    required this.lastSignInTime
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

  Map <String, dynamic> toFireStore({phoneNumber}){
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

  @override
  String toString() {
    super.toString();
    return toFireStore().toString();
  }
}
