import 'package:firebase/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TalkRoomPage extends StatefulWidget {
  final String name;
  const TalkRoomPage(this.name, {Key? key}) : super(key: key);

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList = [
    Message(message: "こんにちは", isMe: true, sendTime: DateTime.now()),
    Message(message: "久しぶりだねあああああああああああああああああああああ", isMe: false, sendTime: DateTime.now()),
    Message(message: "元気かい？？", isMe: false, sendTime: DateTime.now()),
    Message(message: "こんにちは", isMe: true, sendTime: DateTime.now()),
    Message(message: "久しぶりだねあああああああああああああああああああああ", isMe: false, sendTime: DateTime.now()),
    Message(message: "元気かい？？", isMe: false, sendTime: DateTime.now()),
    Message(message: "こんにちは", isMe: true, sendTime: DateTime.now()),
    Message(message: "久しぶりだねあああああああああああああああああああああ", isMe: false, sendTime: DateTime.now()),
    Message(message: "元気かい？？", isMe: false, sendTime: DateTime.now()),
    Message(message: "こんにちは", isMe: true, sendTime: DateTime.now()),
    Message(message: "久しぶりだねあああああああああああああああああああああ", isMe: false, sendTime: DateTime.now()),
    Message(message: "元気かい？？", isMe: false, sendTime: DateTime.now()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text(widget.name)),
      body: ListView.builder(
          physics: const RangeMaintainingScrollPhysics(), //子要素が画面幅を超えるぐらいになった時ListViewのスクロールができるよう調整。
          shrinkWrap: true, //子要素が少ない状態だとListViewによりその後の余白も含まれてしまってるため、子要素の幅だけでListViewがきくように変更
          reverse: true, //スクロールを下からできるように調整
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,//時間の位置を下にずらした
              //このままではintlライブラリが読み込まれてしまうのでimportにasをつけて変更
              textDirection: messageList[index].isMe == true ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: index == 0 ? 10 : 0),//bottomをindex[0]の時設定
                  child: Container(
                      //文字が画面を超えることを考慮しconstraintsプロパティでメッセージmaxWidthの幅を画面6割に調整。
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: messageList[index].isMe == true ? Colors.green : Colors.white,//自分・相手でメッセージの色を分ける。
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Text(messageList[index].message)),
                ),
                Text(intl.DateFormat('HH:mm').format(messageList[index].sendTime))//intlライブラリの導入によりTextではString型しか使用できない問題を解決
              ],
            );
          }
      ),
    );
  }
}

