import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/user_firestore.dart';
import 'package:firebase/model/talk_room.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/pages/talk_room_page.dart';
import 'package:firebase/utils/shared_prefs.dart';

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
  //自分が参加してるの取得（実体を生み出す処理）
  static Future<void> fetchMyRoom() async {
    try{
      String myUid = SharedPrefs.fetchUid()!;
      //自分が参加してるルームのドキュメントだけを取得
      final snapshot = await _roomCollection.where('joined_user_ids', arrayContains: myUid).get();
      //先程作成したTalkRoomモデルを使い実体作成していくため空配列用意。
      List<TalkRoom> talkRooms =[];
      for(var doc in snapshot.docs) {
        List<dynamic> userIds = doc.data()['joined_user_ids'];
        late String talkUserId;
        for (var userId in userIds) {
          if (userId == myUid) continue;
          //取り出したuserIdを別変数に格納。（初期化は別の場所で行うためlate）
          talkUserId = userId;
        }
        //上記で取得したtalkUserIdを使い今度はtalkUserをfor分の中で一人ずつ取得する処理を記載。
        User? talkUser = await UserFirestore.fetchUser(talkUserId);
        if (talkUser == null) return;
          final talkRoom = TalkRoom(
              roomid: doc.id,
              talkUser: talkUser,
              lastMessage: doc.data()['last_Message']
          );
        talkRooms.add(talkRoom);
      }
      print('トークルームの数は====${talkRooms.length}');
    } catch(e) {
        print('トークルームの取得に失敗しました。');
    }
  }
}