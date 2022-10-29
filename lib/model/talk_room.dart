import 'package:firebase/model/user.dart';

class TalkRoom {
  String roomid;
  User talkUser;
  String? message;


  TalkRoom({
    required this.roomid,
    required this.talkUser,
    this.message,
  });
}
