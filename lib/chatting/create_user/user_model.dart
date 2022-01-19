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
//  final UserMetadata metadata;
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
//    required this.metadata,
//    required this.providerData
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
        isNewUser: true,
        phoneNumber: user.phoneNumber ?? null,
        displayName: user.displayName,
        uid: user.uid,
        isAnonymous: user.isAnonymous,
        email: user.email,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
//        metadata: user.metadata,
//        providerData: user.providerData
    );
  }

  Map <String, dynamic> toFireStore(){
    return {
      'isNewUser': isNewUser,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'uid': uid,
      'isAnonymous': isAnonymous,
      'email': email,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
//      'metadata': metadata,
//      'providerData': providerData
    };
  }
}
