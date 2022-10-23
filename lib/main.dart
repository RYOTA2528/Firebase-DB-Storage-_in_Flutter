import 'package:firebase/firebase_options.dart';
import 'package:firebase/firestore/room_firestore.dart';
import 'package:firebase/firestore/user_firestore.dart';
import 'package:firebase/pages/top_page.dart';
import 'package:firebase/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.setPrefsInstance();
  String? uid = SharedPrefs.fetchUid(); // /端末へ登録されてるuidの情報をとってくる。
  // 登録済みユーザーがいる場合orいない場合でそれぞれ処理を分岐
  if(uid == null) {
    final myUid = await UserFirestore.createUser(); //ユーザーの作成&idの格納
    if(myUid != null) {
      RoomFirestore.createRoom(myUid);
    }
    return await SharedPrefs.setUid(myUid!); //myUidの情報を端末へユーザー情報の登録。
  } else {
    RoomFirestore.createRoom(uid);
  }
  //上記まではidでの分岐。下記で実際の実態に対しての処理を記載。
  //自分が参加してるroomの取得
  await RoomFirestore.fetchMyRoom();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}
