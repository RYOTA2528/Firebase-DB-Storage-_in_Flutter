import 'package:firebase/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TalkRoomPage extends StatefulWidget {
  final String name;
  const TalkRoomPage(this.name, {Key? key}) : super(key: key);

  @override
  State<TalkRoomPage> createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList = [
    Message(message: "こんにちは", isMe: true, sendTime: DateTime.now()),
    Message(message: "久しぶりだね！", isMe: false, sendTime: DateTime.now()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: ListView.builder(
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(messageList[index].message),
                Text("")
              ],
            );
          }
      ),
    );
  }
}

