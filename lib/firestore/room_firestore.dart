import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/user_firestore.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance; //1
  static final _roomCollection = _firebaseFirestoreInstance.collection('room'); //2

  //新しいトークルームの作成
  static Future<void> createRoom(String myUid) async {
    //タイミングとしては新しいユーザが追加されたタイミングで作成。その為まずはfetchUserメソッド&return docsでドキュメントを取得
    final docs = await UserFirestore.fetchUsers();
    try{
      if(docs == null) return; //nullなら後続の処理をしないようにする。
      docs.forEach((doc) async {
        if(doc.id == myUid) return;
        await _roomCollection.add({
          'joined_user_ids': [doc.id, myUid], //myUidとUserドキュメントidを格納
          'created_time': Timestamp.now()
        });
      });
    } catch(e){
      print('ルームの作成失敗 ==== $e');
    }
 }
}