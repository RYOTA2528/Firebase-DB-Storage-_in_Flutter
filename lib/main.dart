import 'package:firebase/firebase_options.dart';
import 'package:firebase/firestore/room_firestore.dart';
import 'package:firebase/firestore/user_firestore.dart';
import 'package:firebase/pages/top_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
 final myUid = await UserFirestore.createUser(); //ユーザーの作成&idの格納
  if(myUid==null) return;
  RoomFirestore.createRoom(myUid);

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
