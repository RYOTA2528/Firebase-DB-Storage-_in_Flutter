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
  final myUid = await UserFirestore.createUser(); //ユーザーの作成&idの格納
  if(myUid==null) return;
  await SharedPrefs.setUid(myUid); //端末へユーザー情報の登録
  RoomFirestore.createRoom(myUid); //トークルームの作成処理

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
