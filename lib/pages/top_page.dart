import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firestore/room_firestore.dart';
import 'package:firebase/model/talk_room.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/pages/setting_profile_page.dart';
import 'package:firebase/pages/talk_room_page.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("チャットアプリ"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingProfilePage()));
          }, icon: Icon(Icons.settings))
        ],
      ),
      //リアルタイムで更新されるように修正。
      body:StreamBuilder<QuerySnapshot>(
        stream: RoomFirestore.joinedRoomSnapshot,
        builder: (context, streamsnapshot) {
          if(streamsnapshot.data != null) {
            return FutureBuilder<List<TalkRoom>?>(
                future: RoomFirestore.fetchMyRoom(streamsnapshot.data!),
                builder: (context, futuresnapshot) {
                  if(futuresnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else{
                    if(futuresnapshot.data != null){
                      List<TalkRoom> talkRooms = futuresnapshot.data!; //futuresnapshotはfetchMyRoomメソッドの戻り値であり同じ型の変数へ代入。
                      return ListView.builder(
                          itemCount: talkRooms.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                print(talkRooms[index].roomid);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => TalkRoomPage(talkRooms[index])));
                              },
                              child: SizedBox(
                                height: 80,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                        talkRooms[index].talkUser.imagePath.toString() == null ? null : NetworkImage(talkRooms[index].talkUser.imagePath!),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(talkRooms[index].talkUser.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        Text(talkRooms[index].talkUser.lastMessage, style: const TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Text('トークルームの取得に失敗しました');
                    }
                  }
                }
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      ),
    );
  }
}

