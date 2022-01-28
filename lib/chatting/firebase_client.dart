import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class FirebaseClient{
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future  getUserAvatar(String userId) async {
    final avatar = await storage.ref('avatars/$userId').getDownloadURL();
        print('list  33333 $avatar');

    return avatar;
  }

//  Future uploadUserIdToFirestoreDatabase() async{
//  final yarik = FirebaseFirestore.instance.collection('Yarik').doc();
//  await yarik.set({'username': 'yarik'});
//    final list = FirebaseFirestore.instance.collection('users').doc();
//    final k = await _authService.getUsers();
//    print ('liiiiist ${k.toString()}');
//    list.set({'uid': '${k.toString()}'});
//  }

}
