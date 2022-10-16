import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserFirestore {
  //1でFirebaseFirestoreの実体を取得し格納。2でuserコレクションの情報格納
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance; //1
  static final _userCollection = _firebaseFirestoreInstance.collection('user'); //2

  static Future<void> createUser() async{
    try{
      //Map型でデータを入れてく
       await _userCollection.add({
        'name' : '太郎',
         'image_path' : 'https://i-ogp.pximg.net/c/540x540_70/img-master/img/2014/06/06/18/29/24/43923614_p0_square1200.jpg'
       });
       print('アカウント作成完了');
    } catch(e) {
      print('アカウント作成失敗 ====== $e'); //$eでエラーメッセージも表示
    }
  }
}