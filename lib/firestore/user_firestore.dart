import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserFirestore {
  //1でFirebaseFirestoreの実体を取得し格納。2でuserコレクションの情報格納
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance; //1
  static final _userCollection = _firebaseFirestoreInstance.collection('user'); //2

  //Firebaseへユーザを追加する処理
  static Future<String?> createUser() async{
    try{
      //Map型でデータを入れてく
       await _userCollection.add({
        'name' : '太郎',
         'image_path' : 'https://i-ogp.pximg.net/c/540x540_70/img-master/img/2014/06/06/18/29/24/43923614_p0_square1200.jpg'
       });
       print('アカウント作成完了');
       return _userCollection.id;

    } catch(e) {
      print('アカウント作成失敗 ====== $e'); //$eでエラーメッセージも表示
      return null;
    }
  }

  //Firebaseから全ユーザーを取得してくる処理
  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async{
    try{
      final snapshot = await _userCollection.get();
      print('sanapshotの中身は=====${snapshot}');
      //_userCollectionの中のドキュメント情報を一つ一つとりだす。
      snapshot.docs.forEach((doc) {
        print('ドキュメントID====${doc.id}, 名前=====${doc.data()['name']}');
      });
      return snapshot.docs;
    } catch(e){
      print('ユーザー情報取得の失敗');
      return null;
    }
  }
}