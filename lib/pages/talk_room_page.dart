import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/room_firestore.dart';
import 'package:firebase/model/message.dart';
import 'package:firebase/model/talk_room.dart';
import 'package:firebase/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final TalkRoom talkRoom;
  const TalkRoomPage(this.talkRoom, {Key? key}) : super(key: key);

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text(widget.talkRoom.talkUser.name)),
      body: Stack(
        // alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: RoomFirestore.fetchMessageSnapshot(widget.talkRoom.roomid),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Padding(
                  //ListViewBuilderの中のList文字がメッセージ用Containerで隠れてしまってるため、同じ高さの余白作成
                  padding: const EdgeInsets.only(bottom: 60),
                  child: ListView.builder(
                      physics: const RangeMaintainingScrollPhysics(), //子要素が画面幅を超えるぐらいになった時ListViewのスクロールができるよう調整。
                      shrinkWrap: true, //子要素が少ない状態だとListViewによりその後の余白も含まれてしまってるため、子要素の幅だけでListViewがきくように変更
                      reverse: true, //スクロールを下からできるように調整
                      itemCount: snapshot.data!.docs.length, //meesageコレクションの中のドキュメント全てを取得
                      itemBuilder: (context, index) {
                        //今度はさらにdoc一つの情報を取得。
                        final doc = snapshot.data!.docs[index];
                        //上記でドキュメントのdataを取得できたためMessgeのインスタンスをいよいよ出力。
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //Object型をＭap<String, dynamic>型へ変換
                        final Message message = Message(message: data['message'], isMe: SharedPrefs.fetchUid() == data['sender_id'], sendTime: data['send_time']);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,//時間の位置を下にずらした
                          //このままではintlライブラリが読み込まれてしまうのでimportにasをつけて変更
                          textDirection: message.isMe == true ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: index == 0 ? 10 : 0),//bottomをindex[0]の時設定
                              child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: message.isMe == true ? Colors.green : Colors.white,//自分・相手でメッセージの色を分ける。
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Text(message.message)),
                            ),
                            Text(intl.DateFormat('HH:mm').format(message.sendTime.toDate()))//intlライブラリの導入によりTextではString型しか使用できない問題を解決
                          ],
                        );
                      }
                  ),
                );
              } else {
                return const Center(child: Text('まだメッセージがありません'));
              }
            }
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 7),
                            ),
                    ),
                        )),
                    IconButton(
                        onPressed: () {
                          RoomFirestore.sendMessage(
                              roomid: widget.talkRoom.roomid,
                              message: controller.text
                          );
                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).padding.bottom,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}

