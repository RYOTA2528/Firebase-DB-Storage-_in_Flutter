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
  List<User> userList = [
    User(name: 'ビーバー', uid: 'abc', imagePath: 'https://i-ogp.pximg.net/c/540x540_70/img-master/img/2014/06/06/18/29/24/43923614_p0_square1200.jpg', lastMessage: "ビーバーです。"),
    User(name: 'ジョージ', uid: 'def', imagePath: 'https://marushinbtoc.itembox.design/item/category/george.png', lastMessage: "おさるのジョージ")
  ];

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
      body:ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TalkRoomPage(userList[index].name)));
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
                          userList[index].imagePath.toString() == null ? null : NetworkImage(userList[index].imagePath!),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userList[index].name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Text(userList[index].lastMessage, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

