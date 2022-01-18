abstract class FirebaseResponse {}

class FireBaseResponseError extends FirebaseResponse {
  final String message;

  FireBaseResponseError(this.message);
}

class User extends FirebaseResponse {
  final bool isNewUser;
  final String username;
  final String displayName;
  final String email;
  final bool isAnonymous;
  final int phoneNumber;
  final String photoURL;
  final String uid;

  User(
      {required this.displayName,
      required this.email,
      required this.isAnonymous,
      required this.phoneNumber,
      required this.photoURL,
      required this.uid,
      required this.isNewUser,
      required this.username});

  factory User.fromJson(Map json) {
    return User(
      isNewUser: false,
      phoneNumber: 12345,
      username: 'dds',
      displayName: '',
      uid: '',
      isAnonymous: false,
      email: '',
      photoURL: '',
    );
  }
}
