import 'package:firebase/model/user.dart';

class TalkRoom {
  String roomid;
  User talkUser;
  String? lastMessage;

  TalkRoom({
    required this.roomid,
    required this.talkUser,
    this.lastMessage,
  });
}
