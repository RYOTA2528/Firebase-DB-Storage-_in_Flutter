import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/user_firestore.dart';
import 'package:firebase/model/message.dart';
import 'package:firebase/model/talk_room.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/pages/talk_room_page.dart';
import 'package:firebase/utils/shared_prefs.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance; //1
  static final _roomCollection = _firebaseFirestoreInstance.collection('room'); //2
  //streamに入る値（自分が参加してるルームの情報の更新）があり次第StreamBuilderが動き出すようスナップショット作成。
  static final joinedRoomSnapshot = _roomCollection.where('joined_user_ids', arrayContains: SharedPrefs.fetchUid()).snapshots();

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
    //192.168.232.2
 }
  //自分が参加してるの取得（実体を生み出す処理）
  static Future<List<TalkRoom>?> fetchMyRoom(QuerySnapshot snapshot) async {
    try{
      String myUid = SharedPrefs.fetchUid()!;
      //先程作成したTalkRoomモデルを使い実体作成していくため空配列用意。
      List<TalkRoom> talkRooms =[];
      for(var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> userIds = data['joined_user_ids'];
        late String talkUserId;
        for (var userId in userIds) {
          if (userId == myUid) continue; //myUidの時だけ取得せず続けてfor文で取り出す。
          //取り出したuserIdを別変数に格納。（遅延初期化）
          talkUserId = userId;
        }
        //上記で取得したtalkUserIdを使い今度はtalkUserをfor分の中で一人ずつ取得する処理を記載。
        User? talkUser = await UserFirestore.fetchUser(talkUserId);
        if (talkUser == null) return null;
          final talkRoom = TalkRoom(
              roomid: doc.id,
              talkUser: talkUser,
              message: data['message']
          );
        talkRooms.add(talkRoom);
      }
      return talkRooms;
      print('トークルームの数は====${talkRooms.length}');
    } catch(e) {
        print('トークルームの取得に失敗しました。');
        return null;
    }
  }
  //そのユーザーとのトークルームを取得する。
  static Stream<QuerySnapshot> fetchMessageSnapshot(String roomid) {
    return _roomCollection.doc(roomid).collection('message').orderBy('send_time', descending: true).snapshots();
  }

  //送信されたmessageをmessageCollectionへ追加する処理
  static Future<void> sendMessage({required String roomid, required String message,}) async{
    try{
      //meesageCollectionへ値を追加するためにmessageCollectionを取得
      final messageCollection = _roomCollection.doc(roomid).collection('message');
      //今回はListで表示ではなくあくまでFirebaseのmessageCollection への追加のため下記で追加
      await messageCollection.add({
        'message' : message,
        'sender_id' : SharedPrefs.fetchUid(), //自分のidであることを
        'send_time' : Timestamp.now(), //現在時刻を送
      });
      //lastMessageの情報を追加（更新）する。
      await _roomCollection.doc(roomid).update({
        'message' : message
      });
    } catch(e) {
      return print('メッセージ送信失敗 ====== ${e}');
    }
}
}