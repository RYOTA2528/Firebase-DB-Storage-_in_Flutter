import 'package:firebase/utils/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _preferences;
    //SharedPrefesの実体を取得する処理
  static Future<void> setPrefsInstance() async{
    if(_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
      }
    }
    //与えられたuidをSharedPreferencesに登録する（端末に保存する）
  static Future<void> setUid(String uid) async {
    await _preferences!.setString('uid', uid);
  }
    //端末へ登録されてるuidの情報をとってくる。
  static String? fetchUid() {
      return _preferences!.getString('uid');
  }
}