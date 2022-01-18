import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:github_flutter_app/login/auth_service.dart';


class FirebaseClient{
AuthService _authService = AuthService();
  Future <void> getUsersInfo() async {
//    FirebaseFirestore.instance.collectionGroup()
    final list = await FirebaseFirestore.instance.collection('users');
    final currentUsers = await _authService.getUsers();
    print('list  33333 $list');
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
